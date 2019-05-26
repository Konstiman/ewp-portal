package Manager::EntityManager;

use Moose;
use namespace::autoclean;
use utf8;

=head1 DESCRIPTION

TODO dokumentace

=cut

use Entity::Institution;

=head1 ATTRIBUTES

=head2 C<dbh : DBI>

Povinny atribut pro ulozeni instance databaze.

=cut

has 'dbh' => (
    is       => 'ro',
    isa      => 'Object',
    required => 1
);

=head1 METHODS

=head2 C<clearDatabase () : None>

Smaze obsah neciselnikovych tabulek v db.

=cut

sub clearDatabase {
    my $self = shift;

    # index
    $self->dbh->do( 'ALTER TABLE institution DROP INDEX mainindex' );
    # unit
    $self->dbh->do('DELETE FROM unit_name');
    $self->dbh->do('DELETE FROM unit_website');
    $self->dbh->do('DELETE FROM unit_factsheet');
    $self->dbh->do('DELETE FROM unit_contact');
    $self->dbh->do('DELETE FROM unit');
    # institution
    $self->dbh->do('DELETE FROM institution_name');
    $self->dbh->do('DELETE FROM institution_website');
    $self->dbh->do('DELETE FROM institution_factsheet');
    $self->dbh->do('DELETE FROM institution_other_id');
    $self->dbh->do('DELETE FROM institution_contact');
    $self->dbh->do('DELETE FROM institution');
    # common types
    $self->dbh->do('DELETE FROM contact_name');
    $self->dbh->do('DELETE FROM contact_email');
    $self->dbh->do('DELETE FROM contact_phone');
    $self->dbh->do('DELETE FROM contact_fax');
    $self->dbh->do('DELETE FROM contact_description');
    $self->dbh->do('DELETE FROM contact');
    $self->dbh->do('DELETE FROM address');

    # TODO mazat vsechno (ve spravnem poradi!)
}

=head2 C<getCountryId ( code : Str ) : Int>

Vraci id zeme podle kodu, pokud je zeme s timto kodem ulozena v databazi.

Hleda v tabulce `country`.

=cut

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

=head2 C<saveCountryCode ( code : Str ) : Int>

Ulozi kod zeme do databaze do tabulky `country`. Vraci id nove vlozeneho zaznamu.

=cut

sub saveCountryCode {
    my $self = shift;
    my $code = shift;

    $code = uc $code;

    my $res = $self->dbh->do( 'INSERT INTO country (code) VALUES (?)', undef, $code );

    if ($res) {
        return $self->dbh->{mysql_insertid};
    }

    warn "execution failed:" . $self->dbh->errstr();

    return undef;
}

=head2 C<saveAddress ( address : Entity::Address ) : Entity::Address>

Ulozi objekt adresy do databaze do tabulky `address`. Objektu nastavi id nove vlozeneho zaznamu.

=cut

sub saveAddress {
    my $self    = shift;
    my $address = shift;

    my $countryId = undef;

    if ( $address->country ) {
        $countryId = $self->getCountryId( $address->country );
        if ( !$countryId ) {
            $countryId = $self->saveCountryCode( $address->country );
        }
    }

    my $res = $self->dbh->do(
        'INSERT INTO address 
        (recipient, addressLines, buildingNumber, buildingName, streetName, unit, 
        floor, pobox, deliveryPoint, postalCode, locality, region, country) 
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

    warn "execution failed:" . $self->dbh->errstr();

    return undef;
}

=head2 C<saveInstitution ( institution : Entity::Institution ) : Entity::Institution>

Ulozi objekt instituce do databaze do tabulky `institution` a navazujicich tabulek. Objektu nastavi id nove vlozeneho zaznamu.

TODO refaktorovat do vice mensich metod.

=cut

sub saveInstitution {
    my $self        = shift;
    my $institution = shift;

    if ( $institution->locationAddress ) {
        $self->saveAddress( $institution->locationAddress );
    }

    if ( $institution->mailingAddress ) {
        $self->saveAddress( $institution->mailingAddress );
    }

    my $res = $self->dbh->do( 'INSERT INTO institution (identifier, abbreviation, logo_url, location_address, mailing_address) VALUES (?,?,?,?,?)', undef, $institution->identifier, $institution->abbreviation, $institution->logoUrl, ( $institution->locationAddress ? $institution->locationAddress->id : undef ), ( $institution->mailingAddress ? $institution->mailingAddress->id : undef ) );

    if ( !$res ) {

        warn "execution failed:" . $self->dbh->errstr();
        return 0;
    }

    $institution->id( $self->dbh->{mysql_insertid} );

    my $langMap = $self->_getLangMap();

    if ( $institution->otherIdentifiers ) {
        foreach my $type ( keys %{ $institution->otherIdentifiers } ) {
            my $res = $self->dbh->do( 'INSERT INTO institution_other_id (institution, identifier, type) VALUES (?,?,?)', undef, $institution->id, $institution->otherIdentifiers->{$type}, lc $type );

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

            my $res = $self->dbh->do( 'INSERT INTO institution_name (institution, name, language) VALUES (?,?,?)', undef, $institution->id, $institution->names->{$lang}, $langId );

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

            my $res = $self->dbh->do( 'INSERT INTO institution_website (institution, url, language) VALUES (?,?,?)', undef, $institution->id, $url, $langId );

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

            my $res = $self->dbh->do( 'INSERT INTO institution_factsheet (institution, name, url, language) VALUES (?,?,?,?)', undef, $institution->id, 'Factsheet' . ( $lang ne 'unknown' ? ' (' . uc $lang . ')' : '' ), $url, $langId );

            warn "execution failed:" . $self->dbh->errstr() if !$res;
        }
    }

    if ( $institution->contacts ) {
        foreach my $contactObject ( @{ $institution->contacts } ) {
            $self->saveContact($contactObject);
            if ( $contactObject->id ) {
                my $res = $self->dbh->do( 'INSERT INTO institution_contact (institution, contact) VALUES (?,?)', undef, $institution->id, $contactObject->id );

                warn "execution failed:" . $self->dbh->errstr() if !$res;
            }
        }
    }

    return $institution;
}

=head2 C<saveContact ( contact : Entity::Contact ) : Entity::Contact>

Ulozi objekt kontaktu do databaze do tabulky `contact` a navazujicich podtabulek. Objektu nastavi id nove vlozeneho zaznamu.

TODO refaktorovat do vice mensich metod.

=cut

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

            my $res = $self->dbh->do( 'INSERT INTO contact_name (contact, name, language, type) VALUES (?,?,?,?)', undef, $contact->id, $contact->names->{$lang}, $langId, 'contact-name' );

            warn "execution failed:" . $self->dbh->errstr() if !$res;
        }
    }

    if ( $contact->emails ) {
        foreach my $email ( @{ $contact->emails } ) {
            my $res = $self->dbh->do( 'INSERT INTO contact_email (contact, email) VALUES (?,?)', undef, $contact->id, $email );

            warn "execution failed:" . $self->dbh->errstr() if !$res;
        }
    }

    if ( $contact->phones ) {
        foreach my $phone ( @{ $contact->phones } ) {
            my $res = $self->dbh->do( 'INSERT INTO contact_phone (contact, phoneNumber) VALUES (?,?)', undef, $contact->id, $phone );

            warn "execution failed:" . $self->dbh->errstr() if !$res;
        }
    }

    if ( $contact->faxes ) {
        foreach my $fax ( @{ $contact->faxes } ) {
            my $res = $self->dbh->do( 'INSERT INTO contact_fax (contact, faxNumber) VALUES (?,?)', undef, $contact->id, $fax );

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

            my $res = $self->dbh->do( 'INSERT INTO contact_description (contact, text, language) VALUES (?,?,?)', undef, $contact->id, $contact->description->{$lang}, $langId );

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

    my $res = $self->dbh->do( 'INSERT INTO language (abbreviation, name) VALUES (?, \'\')', undef, $lang );

    if ($res) {
        return $self->dbh->{mysql_insertid};
    }

    warn "execution failed:" . $self->dbh->errstr();

    return undef;
}

=head2 C<saveUnit ( unit : Entity::Unit ) : Entity::Unit>

Ulozi objekt organizacni jednotky do databaze do tabulky `organizational_unit` a navazujicich tabulek. 
Objektu nastavi id nove vlozeneho zaznamu.

TODO refaktorovat do vice mensich metod.

=cut

sub saveUnit {
    my $self = shift;
    my $unit = shift;

    if ( $unit->locationAddress ) {
        $self->saveAddress( $unit->locationAddress );
    }

    if ( $unit->mailingAddress ) {
        $self->saveAddress( $unit->mailingAddress );
    }

    # TODO root + parent
    my $res = $self->dbh->do( 
        'INSERT INTO unit (identifier, institution, code, abbreviation, logo_url, location_address, mailing_address) 
        VALUES (?,?,?,?,?,?,?)', 
        undef, 
        $unit->identifier,
        $unit->institution->id,
        $unit->code,
        $unit->abbreviation, 
        $unit->logoUrl, 
        ( $unit->locationAddress ? $unit->locationAddress->id : undef ), 
        ( $unit->mailingAddress ? $unit->mailingAddress->id : undef ) 
    );

    if ( !$res ) {

        warn "execution failed:" . $self->dbh->errstr();
        return 0;
    }

    $unit->id( $self->dbh->{mysql_insertid} );

    my $langMap = $self->_getLangMap();

    if ( $unit->names ) {
        foreach my $lang ( keys %{ $unit->names } ) {
            my $langId = undef;
            if ( $lang ne 'unknown' ) {
                $langId = $langMap->{ lc $lang };
                if ( !$langId ) {
                    $langId = $self->_saveLanguage($lang);
                    $langMap->{ lc $lang } = $langId;
                }
            }

            my $res = $self->dbh->do( 
                'INSERT INTO unit_name (unit, name, language) VALUES (?,?,?)', 
                undef, $unit->id, $unit->names->{$lang}, $langId 
            );

            warn "execution failed:" . $self->dbh->errstr() if !$res;
        }
    }

    if ( $unit->websites ) {
        foreach my $url ( keys %{ $unit->websites } ) {
            my $lang   = $unit->websites->{$url};
            my $langId = undef;
            if ( $lang ne 'unknown' ) {
                $langId = $langMap->{ lc $lang };
                if ( !$langId ) {
                    $langId = $self->_saveLanguage($lang);
                    $langMap->{ lc $lang } = $langId;
                }
            }

            my $res = $self->dbh->do( 
                'INSERT INTO unit_website (unit, url, language) VALUES (?,?,?)', 
                undef, $unit->id, $url, $langId 
            );

            warn "execution failed:" . $self->dbh->errstr() if !$res;
        }
    }

    if ( $unit->factsheets ) {
        foreach my $url ( keys %{ $unit->factsheets } ) {
            my $lang   = $unit->factsheets->{$url};
            my $langId = undef;
            if ( $lang ne 'unknown' ) {
                $langId = $langMap->{ lc $lang };
                if ( !$langId ) {
                    $langId = $self->_saveLanguage($lang);
                    $langMap->{ lc $lang } = $langId;
                }
            }

            my $res = $self->dbh->do( 
                'INSERT INTO unit_factsheet (unit, name, url, language) VALUES (?,?,?,?)', 
                undef, $unit->id, 'Factsheet' . ( $lang ne 'unknown' ? ' (' . uc $lang . ')' : '' ), $url, $langId 
            );

            warn "execution failed:" . $self->dbh->errstr() if !$res;
        }
    }

    if ( $unit->contacts ) {
        foreach my $contactObject ( @{ $unit->contacts } ) {
            $self->saveContact($contactObject);
            if ( $contactObject->id ) {
                my $res = $self->dbh->do( 
                    'INSERT INTO unit_contact (unit, contact) VALUES (?,?)', 
                    undef, $unit->id, $contactObject->id 
                );

                warn "execution failed:" . $self->dbh->errstr() if !$res;
            }
        }
    }

    return $unit;
}

=head2 C<saveOpportunity ( opportunity : Entity::LearningOpportunity ) : Entity::LearningOpportunity>

Ulozi objekt studijni prilezitosti do databaze do tabulky `learning_opportunity` a navazujicich tabulek. 
Objektu nastavi id nove vlozeneho zaznamu.

TODO refaktorovat do vice mensich metod.

=cut

sub saveOpportunity {
    my $opportunity = shift;

    # TODO

    return $opportunity;
}

=head2 C<saveIndex (institution : Entity::Institution, units : ArrayRef[Entity::Unit], courses : ArrayRef[Entity::LearningOpportunity]) : Bool>

Z objektu instituce a k ni souvisejicich jednotek a kurzu vytvori a ulozi textovou reprezentaci instituce, ktera je nasledne
pouzita pro fulltextove vyhledavani na Studentskem portalu.

=cut

sub saveIndex {
    my $self        = shift;
    my $institution = shift;
    my $units       = shift;
    my $courses     = shift;

    my $content = '';

    $content .= $self->_getInstitutionText($institution);

    foreach my $unit (@$units) {
        $content .= $self->_getUnitText($unit);
    }

    foreach my $course (@$courses) {
        $content .= $self->_getOpportunityText($course);
    }

    return $self->dbh->do( 'UPDATE institution SET `fulltext` = ? WHERE id = ?', undef, $content, $institution->id );
}

sub _getInstitutionText {
    my $self        = shift;
    my $institution = shift;

    my $text = '';

    if ( $institution->names ) {
        $text .= join( ' ', values %{ $institution->names } );
    }

    if ( $institution->abbreviation ) {
        $text .= "\n" . $institution->abbreviation;
    }

    if ( $institution->websites ) {
        $text .= "\n" . join( "\n", keys %{ $institution->websites } );
    }

    # TODO kontakty

    # TODO adresy

    return $text;
}

sub _getUnitText {
    my $self = shift;
    my $unit = shift;

    my $text = '';

    # TODO

    return $text;
}

sub _getOpportunityText {
    my $self        = shift;
    my $opportunity = shift;

    my $text = '';

    # TODO

    return $text;
}

=head2 C<createIndex () : Bool>

Vytvori fulltext index pro vyhledavani v institucich.

=cut

sub createIndex {
    my $self = shift;

    return $self->dbh->do( 'CREATE FULLTEXT INDEX mainindex ON institution(`fulltext`)' );
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
