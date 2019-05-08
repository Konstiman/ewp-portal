package Manager::EntityManager;
 
use Moose;

use Entity::Institution;

has 'dbh' => (
    is  => 'ro',
    isa => 'Object',
    required => 1
);

# TODO dokumentace

sub clearDatabase {
    my $self = shift;

    $self->dbh->do( 'DELETE FROM institution' );
    $self->dbh->do( 'DELETE FROM address' );

    # TODO mazat vsechno (ve spravnem poradi!)
}

sub getCountryId {
    my $self = shift;
    my $code = shift;

    $code = uc $code;

    my $sth = $self->dbh->prepare('SELECT id FROM country WHERE code = ?');

    if (!$sth) {
        warn "prepare statement failed: " . $self->dbh->errstr();
        return undef;
    }

    if (!$sth->execute($code)) {
        warn "execution failed: " . $self->dbh->errstr();
        return undef;
    }

    my $ref = $sth->fetchrow_hashref();
    $sth->finish();

    if ($ref) {
        return $ref->{ 'id' };
    }

    return undef;
}

sub saveCountryCode {
    my $self = shift;
    my $code = shift;

    $code = uc $code;

    my $res = $self->dbh->do(
        'INSERT INTO country (code) VALUES (?)',
        undef,
        $code
    );

    if ( $res ) {
        return $self->dbh->{mysql_insertid};
    }

    # TODO
    warn "execution failed:" . $self->dbh->errstr();

    return undef;
}

sub saveAddress {
    my $self = shift;
    my $address = shift;

    my $countryId = $self->getCountryId( $address->country );
    if (!$countryId) {
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

    if ( $res ) {
        $address->id($self->dbh->{mysql_insertid});
        return $address;
    }

    # TODO
    warn "execution failed:" . $self->dbh->errstr();

    return 0;
}

sub saveInstitution {
    my $self        = shift;
    my $institution = shift;

    if ($institution->locationAddress) {
        $self->saveAddress($institution->locationAddress);
    }

    my $res = $self->dbh->do(
        'INSERT INTO institution (identifier, abbreviation, logo_url, location_address, mailing_address) VALUES (?,?,?,?,?)',
        undef,
        $institution->identifier,
        $institution->abbreviation,
        $institution->logoUrl,
        ( $institution->locationAddress ? $institution->locationAddress->id : undef ),
        ( $institution->mailingAddress ? $institution->mailingAddress->id : undef )
    );

    if ( $res ) {
        $institution->id($self->dbh->{mysql_insertid});
        return $institution;
    }

    # TODO
    warn "execution failed:" . $self->dbh->errstr();

    return 0;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
