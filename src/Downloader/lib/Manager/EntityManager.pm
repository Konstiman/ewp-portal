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

    # TODO mazat vsechno
}

sub saveInstitution {
    my $self        = shift;
    my $institution = shift;

    my $res = $self->dbh->do(
        'INSERT INTO institution (identifier, abbreviation, logo_url) VALUES (?,?,?)',
        undef,
        $institution->identifier,
        $institution->abbreviation,
        $institution->logoUrl,
        # TODO address
        # TODO address
    );

    if ( $res ) {
        return 1;
    }

    # TODO
    # "execution failed:" . $dbh->errstr()

    return 0;
}

sub getLastInsertedId {
    my $self = shift;

    return $self->dbh->{mysql_insertid};
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
