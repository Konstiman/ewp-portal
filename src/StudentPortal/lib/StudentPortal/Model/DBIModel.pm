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

=head1 NAME

StudentPortal::Model::DBIModel - DBI Model Class

=head1 SYNOPSIS

See L<StudentPortal>

=head1 DESCRIPTION

DBI Model Class.

=head1 METHODS

=head2 getInstitutionsListData

Returns list with all institutions and their basic data:
id, identifier, names, abbreviation, logo, locality and country.

=cut

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

=head2 getInstitutionCountriesData

Returns list with all countries with at least one institution. Each entry
contains country id and country name.

=cut

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

=head2 getInstitutionData

Returns hash with information about the address specified by parameter.

=cut

sub getAddress {
    my $self = shift;
    my $id   = shift;

    my $dbh = $self->dbh;

    my $sth = $dbh->prepare('
        SELECT  recipient,
                addressLines,
                buildingNumber,
                buildingName,
                streetName,
                unit,
                floor,
                pobox,
                deliveryPoint,
                postalCode,
                locality,
                region,
                country.name_cz country
        FROM    address
                LEFT JOIN country ON address.country = country.id
        WHERE   address.id = ?'
    );

    if ( !$sth || !$sth->execute($id) ) {
        warn "fail: " . $dbh->errstr();
        return undef;
    }

    my $row = $sth->fetchrow_hashref();
    $sth->finish();

    if (!$row) {
        return undef;
    }

    return $row;
}

=head2 getInstitutionData

Returns hash with information about one particular institution.

=cut

sub getInstitutionData {
    my $self  = shift;
    my $ident = shift;

    my $dbh = $self->dbh;

    my $sth = $dbh->prepare('
        SELECT  inst.id,
                inst.abbreviation,
                inst.logo_url logoUrl,
                inst.location_address locationAddressId,
                inst.mailing_address mailingAddressId
        FROM    institution inst
        WHERE   inst.identifier = ?'
    );

    if ( !$sth || !$sth->execute($ident) ) {
        warn "fail: " . $dbh->errstr();
        return undef;
    }

    my $row = $sth->fetchrow_hashref();
    $sth->finish();

    if (!$row) {
        return undef;
    }

    my %result = %{ $row };

    my $id         = $row->{id};
    my @names      = $self->getInstitutionNames($id);
    my $mainName   = '';
    my @otherNames = ();
    foreach my $nameRef ( @names ) {
        if ( $nameRef->{ lang } && lc $nameRef->{ lang } eq 'en' ) {
            $mainName = $nameRef->{ name };
        }
        else {
            push @otherNames, $nameRef;
        }
    }
    if ( !$mainName ) {
        my $nameRef = shift @otherNames;
        $mainName   = $nameRef->{ name };
    }

    $result{ name } = $mainName;
    $result{ otherNames } = \@otherNames;
    $result{ websites } = $self->getInstitutionWebsites($id);
    #$result{ facsheets } = $self->getInstitutionFactsheets($id);
    #$result{ contacts } = $self->getInstitutionContacts($id);
    $result{ locationAddress } = $self->getAddress($result{ locationAddressId }) if $result{ locationAddressId };
    $result{ mailingAddress } = $self->getAddress($result{ mailingAddressId }) if $result{ mailingAddressId };

    return \%result;
}

sub getInstitutionCities {
    my $self = shift;

    my @institutions = $self->getInstitutionsListData();

    my @result = ();

    foreach my $inst ( @institutions ) {
        my $ident = $inst->{ identifier };
        my $name  = $inst->{ nameEN };
        if (!$name) {
            $name = shift @{ $inst->{ names } };
        }
        my $city    = $inst->{ city }    || '';
        my $country = $inst->{ country } || '';
        push @result, {
            address    => "$city $country",
            name       => $name,
            identifier => $ident
        }
    }

    return wantarray ? @result : \@result;
}

=head2 getInstitutionNames

Returns array of one particular institution's names.

=cut

sub getInstitutionNames {
    my $self = shift;
    my $id   = shift;

    my $dbh = $self->dbh;

    my $sth = $dbh->prepare('
        SELECT  inst.name,
                lang.abbreviation lang,
                lang.flag_url flagUrl
        FROM    institution_name inst
                LEFT JOIN language lang ON inst.language = lang.id
        WHERE   inst.institution = ?'
    );

    if ( !$sth || !$sth->execute($id) ) {
        warn "fail: " . $dbh->errstr();
        return undef;
    }

    my @result = ();

    while ( my $row = $sth->fetchrow_hashref() ) {
        push @result, $row;
    }
    $sth->finish();

    return wantarray ? @result : \@result;
}

=head2 getInstitutionWebsites

Returns array of one particular institution's websites.

=cut

sub getInstitutionWebsites {
    my $self = shift;
    my $id   = shift;

    my $dbh = $self->dbh;

    my $sth = $dbh->prepare('
        SELECT  inst.url,
                lang.abbreviation lang,
                lang.flag_url flagUrl
        FROM    institution_website inst
                LEFT JOIN language lang ON inst.language = lang.id
        WHERE   inst.institution = ?'
    );

    if ( !$sth || !$sth->execute($id) ) {
        warn "fail: " . $dbh->errstr();
        return undef;
    }

    my @result = ();

    while ( my $row = $sth->fetchrow_hashref() ) {
        push @result, $row;
    }
    $sth->finish();

    return wantarray ? @result : \@result;
}

=head1 AUTHOR

Jan Konstant,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
