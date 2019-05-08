package Manager::EntityManager;

use Moose;

use Entity::Institution;

has 'dbh' => (
    is       => 'ro',
    isa      => 'Object',
    required => 1
);

# TODO dokumentace

sub clearDatabase {
    my $self = shift;

    $self->dbh->do('DELETE FROM institution_name');
    $self->dbh->do('DELETE FROM institution_website');
    $self->dbh->do('DELETE FROM institution_factsheet');
    $self->dbh->do('DELETE FROM institution_other_id');
    $self->dbh->do('DELETE FROM institution_contact');
    $self->dbh->do('DELETE FROM institution');
    $self->dbh->do('DELETE FROM contact');
    $self->dbh->do('DELETE FROM address');

    # TODO mazat vsechno (ve spravnem poradi!)
}

sub getCountryId {
    my $self = shift;
    my $code = shift;

    $code = uc $code;

    my $sth = $self->dbh->prepare('SELECT id FROM country WHERE code = ?');

    if ( !$sth ) {
        warn "prepare statement failed: " . $self->dbh->errstr();
        return undef;
    }

    if ( !$sth->execute($code) ) {
        warn "execution failed: " . $self->dbh->errstr();
        return undef;
    }

    my $ref = $sth->fetchrow_hashref();
    $sth->finish();

    if ($ref) {
        return $ref->{'id'};
    }

    return undef;
}

sub saveCountryCode {
    my $self = shift;
    my $code = shift;

    $code = uc $code;

    my $res =
      $self->dbh->do( 'INSERT INTO country (code) VALUES (?)', undef, $code );

    if ($res) {
        return $self->dbh->{mysql_insertid};
    }

    # TODO
    warn "execution failed:" . $self->dbh->errstr();

    return undef;
}

sub saveAddress {
    my $self    = shift;
    my $address = shift;

    my $countryId = $self->getCountryId( $address->country );
    if ( !$countryId ) {
        $countryId = $self->saveCountryCode( $address->country );
    }

    my $res = $self->dbh->do(
        'INSERT INTO address 
        (recipient, addressLines, buildingNumber, buildingName, streetName, unit, floor, pobox, deliveryPoint, postalCode, locality, region, country) 
        VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)',
        undef,
        $address->recipient,
        $address->lines,
        $address->buildingNumber,
        $address->buildingName,
        $address->streetName,
        $address->unit,
        $address->floor,
        $address->pobox,
        $address->deliveryPoint,
        $address->postalCode,
        $address->locality,
        $address->region,
        $countryId
    );

    if ($res) {
        $address->id( $self->dbh->{mysql_insertid} );
        return $address;
    }

    # TODO
    warn "execution failed:" . $self->dbh->errstr();

    return 0;
}

sub saveInstitution {
    my $self        = shift;
    my $institution = shift;

    if ( $institution->locationAddress ) {
        $self->saveAddress( $institution->locationAddress );
    }

    if ( $institution->mailingAddress ) {
        $self->saveAddress( $institution->mailingAddress );
    }

    my $res = $self->dbh->do(
'INSERT INTO institution (identifier, abbreviation, logo_url, location_address, mailing_address) VALUES (?,?,?,?,?)',
        undef,
        $institution->identifier,
        $institution->abbreviation,
        $institution->logoUrl,
        (
            $institution->locationAddress ? $institution->locationAddress->id
            : undef
        ),
        (
            $institution->mailingAddress ? $institution->mailingAddress->id
            : undef
        )
    );

    if ( !$res ) {

        # TODO
        warn "execution failed:" . $self->dbh->errstr();

        return 0;
    }

    $institution->id( $self->dbh->{mysql_insertid} );

    my $langMap = $self->_getLangMap();

    if ( $institution->otherIdentifiers ) {
        foreach my $type ( keys %{ $institution->otherIdentifiers } ) {
            my $res = $self->dbh->do(
'INSERT INTO institution_other_id (institution, identifier, type) VALUES (?,?,?)',
                undef,
                $institution->id,
                $institution->otherIdentifiers->{$type},
                lc $type
            );

            # TODO
            warn "execution failed:" . $self->dbh->errstr() if !$res;
        }
    }

    if ( $institution->names ) {
        foreach my $lang ( keys %{ $institution->names } ) {
            my $langId = undef;
            if ( $lang ne 'unknown' ) {
                $langId = $langMap->{ lc $lang };
                if ( !$langId ) {
                    $langId = $self->_saveLanguage($lang);
                    $langMap->{ lc $lang } = $langId;
                }
            }

            my $res = $self->dbh->do(
'INSERT INTO institution_name (institution, name, language) VALUES (?,?,?)',
                undef,
                $institution->id,
                $institution->names->{$lang},
                $langId
            );

            # TODO
            warn "execution failed:" . $self->dbh->errstr() if !$res;
        }
    }

    if ( $institution->websites ) {
        foreach my $url ( keys %{ $institution->websites } ) {
            my $lang   = $institution->websites->{$url};
            my $langId = undef;
            if ( $lang ne 'unknown' ) {
                $langId = $langMap->{ lc $lang };
                if ( !$langId ) {
                    $langId = $self->_saveLanguage($lang);
                    $langMap->{ lc $lang } = $langId;
                }
            }

            my $res = $self->dbh->do(
'INSERT INTO institution_website (institution, url, language) VALUES (?,?,?)',
                undef, $institution->id, $url, $langId
            );

            # TODO
            warn "execution failed:" . $self->dbh->errstr() if !$res;
        }
    }

    if ( $institution->factsheets ) {
        foreach my $url ( keys %{ $institution->factsheets } ) {
            my $lang   = $institution->factsheets->{$url};
            my $langId = undef;
            if ( $lang ne 'unknown' ) {
                $langId = $langMap->{ lc $lang };
                if ( !$langId ) {
                    $langId = $self->_saveLanguage($lang);
                    $langMap->{ lc $lang } = $langId;
                }
            }

            my $res = $self->dbh->do(
'INSERT INTO institution_factsheet (institution, name, url, language) VALUES (?,?,?,?)',
                undef,
                $institution->id,
                'Factsheet'
                  . ( $lang ne 'unknown' ? ' (' . uc $lang . ')' : '' ),
                $url,
                $langId
            );

            # TODO
            warn "execution failed:" . $self->dbh->errstr() if !$res;
        }
    }

    if ( $institution->contacts ) {
        foreach my $contactObject ( @{ $institution->contacts } ) {
            $self->saveContact($contactObject);
            if ( $contactObject->id ) {
                my $res = $self->dbh->do(
'INSERT INTO institution_contact (institution, contact) VALUES (?,?)',
                    undef, $institution->id, $contactObject->id
                );

                # TODO
                warn "execution failed:" . $self->dbh->errstr() if !$res;
            }
        }
    }

    return $institution;
}

sub saveContact {
    my $self    = shift;
    my $contact = shift;

    # TODO

    if ( $contact->locationAddress ) {
        $self->saveAddress( $contact->locationAddress );
    }

    if ( $contact->mailingAddress ) {
        $self->saveAddress( $contact->mailingAddress );
    }

    my $res = $self->dbh->do(
'INSERT INTO contact (gender, location_address, mailing_address) VALUES (?,?,?)',
        undef,
        $contact->gender,
        (
            $contact->locationAddress ? $contact->locationAddress->id
            : undef
        ),
        (
            $contact->mailingAddress ? $contact->mailingAddress->id
            : undef
        )
    );

    if ( !$res ) {

        # TODO
        warn "execution failed:" . $self->dbh->errstr();

        return 0;
    }

    $contact->id( $self->dbh->{mysql_insertid} );

    my $langMap = $self->_getLangMap();

    if ( $contact->names ) {
        foreach my $lang ( keys %{ $contact->names } ) {
            my $langId = undef;
            if ( $lang ne 'unknown' ) {
                $langId = $langMap->{ lc $lang };
                if ( !$langId ) {
                    $langId = $self->_saveLanguage($lang);
                    $langMap->{ lc $lang } = $langId;
                }
            }

            my $res = $self->dbh->do(
'INSERT INTO contact_name (contact, name, language, type) VALUES (?,?,?,?)',
                undef,
                $contact->id,
                $contact->names->{$lang},
                $langId,
                'contact-name'
            );

            # TODO
            warn "execution failed:" . $self->dbh->errstr() if !$res;
        }
    }

    if ( $contact->emails ) {
        foreach my $email (@{ $contact->emails }) {
            my $res = $self->dbh->do(
'INSERT INTO contact_email (contact, email) VALUES (?,?)',
                undef,
                $contact->id,
                $email
            );

            # TODO
            warn "execution failed:" . $self->dbh->errstr() if !$res;
        }
    }

    if ( $contact->phones ) {
        foreach my $phone (@{ $contact->phones }) {
            my $res = $self->dbh->do(
'INSERT INTO contact_phone (contact, phoneNumber) VALUES (?,?)',
                undef,
                $contact->id,
                $phone
            );

            # TODO
            warn "execution failed:" . $self->dbh->errstr() if !$res;
        }
    }

    if ( $contact->faxes ) {
        foreach my $fax (@{ $contact->faxes }) {
            my $res = $self->dbh->do(
'INSERT INTO contact_fax (contact, faxNumber) VALUES (?,?)',
                undef,
                $contact->id,
                $fax
            );

            # TODO
            warn "execution failed:" . $self->dbh->errstr() if !$res;
        }
    }

    if ( $contact->description ) {
        foreach my $lang ( keys %{ $contact->description } ) {
            my $langId = undef;
            if ( $lang ne 'unknown' ) {
                $langId = $langMap->{ lc $lang };
                if ( !$langId ) {
                    $langId = $self->_saveLanguage($lang);
                    $langMap->{ lc $lang } = $langId;
                }
            }

            my $res = $self->dbh->do(
'INSERT INTO contact_description (contact, text, language) VALUES (?,?,?)',
                undef,
                $contact->id,
                $contact->description->{$lang},
                $langId
            );

            # TODO
            warn "execution failed:" . $self->dbh->errstr() if !$res;
        }
    }
}

sub _getLangMap {
    my $self = shift;

    # TODO cachovat

    my $sth = $self->dbh->prepare('SELECT id, abbreviation FROM language');

    if ( !$sth ) {
        warn "prepare statement failed: " . $self->dbh->errstr();
        return {};
    }

    if ( !$sth->execute() ) {
        warn "execution failed: " . $self->dbh->errstr();
        return {};
    }

    my %map = ();
    while ( my $ref = $sth->fetchrow_hashref() ) {
        $map{ $ref->{'abbreviation'} } = $ref->{'id'};
    }
    $sth->finish();

    return \%map;
}

sub _saveLanguage {
    my $self = shift;
    my $lang = shift;

    $lang = lc $lang;

    my $res = $self->dbh->do(
        'INSERT INTO language (abbreviation, name) VALUES (?, \'\')',
        undef, $lang );

    if ($res) {
        return $self->dbh->{mysql_insertid};
    }

    # TODO
    warn "execution failed:" . $self->dbh->errstr();

    return undef;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
