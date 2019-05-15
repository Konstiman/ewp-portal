package StudentPortal::Model::DBIModel;

use strict;
use warnings;
use parent 'Catalyst::Model::DBI';

__PACKAGE__->config(
    dsn           => 'dbi:mysql:ewpportal',
    user          => 'ewpportal',
    password      => 'ewpportal',
    options       => {
        mysql_enable_utf8 => 1
    },
);

# TODO komentar
sub getInstitutionsListData {
    my $self = shift;

    my $dbh = $self->dbh;

    my $sth = $dbh->prepare('
        SELECT  inst.id,
                inst.identifier,
                names.name,
                lang.abbreviation abbr_lang,
                inst.abbreviation,
                inst.logo_url,
                addr.locality,
                country.name_cz country_cz 
        FROM    institution inst
                INNER JOIN institution_name names ON inst.id = names.institution
                LEFT JOIN language lang ON names.language = lang.id
                LEFT JOIN address addr ON inst.location_address = addr.id
                LEFT JOIN country ON addr.country = country.id'
    );

    if ( !$sth || !$sth->execute() ) {
        warn "fail: " . $dbh->errstr();
        return wantarray ? () : [];
    }

    my %id2Inst = ();
    while (my $row = $sth->fetchrow_hashref()) {
        my $identifier = $row->{'identifier'};
        $id2Inst{ $identifier } = {
            id           => $row->{'id'},
            identifier   => $identifier,
            abbreviation => $row->{'abbreviation'} || '',
            logoUrl      => $row->{'logo_url'}     || '',
            city         => $row->{'locality'}     || '',
            country      => $row->{'country_cz'}   || '',
        } unless $id2Inst{ $identifier };
        
        $id2Inst{ $identifier }->{ names } = [  ] unless $id2Inst{ $identifier }->{ names };
        if ( !( grep { $_ eq $row->{'name'} } @{ $id2Inst{ $identifier }->{ names } } ) ) {
            push @{ $id2Inst{ $identifier }->{ names } }, $row->{'name'};
        }

        if ( $row->{'abbr_lang'} && $row->{'abbr_lang'} eq 'en' ) {
            $id2Inst{ $identifier }->{ nameEN } = $row->{'name'};
        }
    }
    $sth->finish();

    my @institutions = ( values %id2Inst );
    @institutions = sort { $a->{ id } <=> $b->{ id } } @institutions;

    return wantarray ? @institutions : \@institutions;
}

sub getInstitutionCountriesData {
    my $self = shift;

    my $dbh = $self->dbh;

    my $sth = $dbh->prepare('
        SELECT  distinct country.id,
                country.name_cz name 
        FROM    institution inst
                LEFT JOIN address addr ON inst.location_address = addr.id
                LEFT JOIN country ON addr.country = country.id
        ORDER BY name'
    );

    if ( !$sth || !$sth->execute() ) {
        warn "fail: " . $dbh->errstr();
        return wantarray ? () : [];
    }

    my @result = ();
    while (my $row = $sth->fetchrow_hashref()) {
        push @result, $row;
    }
    $sth->finish();

    return wantarray ? @result : \@result;
}

=head1 NAME

StudentPortal::Model::DBIModel - DBI Model Class

=head1 SYNOPSIS

See L<StudentPortal>

=head1 DESCRIPTION

DBI Model Class.

=head1 AUTHOR

Jan Konstant,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
