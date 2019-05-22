package StudentPortal::Model::DBIModel;

use strict;
use warnings;
use parent 'Catalyst::Model::DBI';

use File::Slurp;

my @config = read_file('../config');
my $dsn    = $config[0];
my $user   = $config[1];
my $passwd = $config[2];

chomp( $dsn, $user, $passwd );

__PACKAGE__->config(
    dsn      => $dsn,
    user     => $user,
    password => $passwd,
    options  => {
        mysql_enable_utf8 => 1
    }
);

=head1 NAME

StudentPortal::Model::DBIModel - DBI Model Class

=head1 SYNOPSIS

See L<StudentPortal>

=head1 DESCRIPTION

DBI Model Class. Main data model for Student Portal.

=head1 METHODS

=head2 C<simpleSelect (query : Str, parameters : Array[Str]) : ArrayRef[HashRef[Str]]>

Wrapper method for select procedure that repeats in every db call.

=cut

sub simpleSelect {
    my $self   = shift;
    my $query  = shift;
    my @params = @_;

    my $dbh = $self->dbh;

    $dbh->{mysql_auto_reconnect} = 1;

    my $sth = $dbh->prepare($query);

    if ( !$sth || !$sth->execute(@params) ) {
        warn "Error when executing query:\n$query\nParams: " . join( ', ', @params ) . "\n\n" . $dbh->errstr();
        return wantarray ? () : [];
    }

    my @result = ();
    while ( my $row = $sth->fetchrow_hashref() ) {
        push @result, $row;
    }
    $sth->finish();

    return wantarray ? @result : \@result;
}

=head2 C<getInstitutionsListData () : ArrayRef[HashRef[Str]]>

Returns list with all institutions and their basic data:
id, identifier, names, abbreviation, logo, locality and country.

Takes one parameter: hash with filter options.

=cut

sub getInstitutionsListData {
    my $self   = shift;
    my $filter = shift;

    my $where  = '';
    my @params = ();
    if ( $filter && $filter->{country} ) {
        $where = 'WHERE country.id = ?';
        push @params, $filter->{country};
    }

    my @data = $self->simpleSelect( "
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
                LEFT JOIN country ON addr.country = country.id
        $where", @params );

    my %id2Inst = ();
    foreach my $row (@data) {
        my $identifier = $row->{'identifier'};
        $id2Inst{$identifier} = {
            id           => $row->{'id'},
            identifier   => $identifier,
            abbreviation => $row->{'abbreviation'} || '',
            logoUrl      => $row->{'logo_url'} || '',
            city         => $row->{'locality'} || '',
            country      => $row->{'country_cz'} || '',
        } unless $id2Inst{$identifier};

        $id2Inst{$identifier}->{names} = [] unless $id2Inst{$identifier}->{names};
        if ( !( grep { $_ eq $row->{'name'} } @{ $id2Inst{$identifier}->{names} } ) ) {
            push @{ $id2Inst{$identifier}->{names} }, $row->{'name'};
        }

        if ( $row->{'abbr_lang'} && $row->{'abbr_lang'} eq 'en' ) {
            $id2Inst{$identifier}->{mainName} = $row->{'name'};
        }
    }

    my @institutions = ( values %id2Inst );
    foreach my $inst (@institutions) {
        $inst->{mainName} = shift @{ $inst->{names} } if !$inst->{mainName};
    }
    @institutions = sort { $a->{mainName} cmp $b->{mainName} } @institutions;

    return wantarray ? @institutions : \@institutions;
}

=head2 C<getInstitutionCountriesData () : ArrayRef[HashRef[Str]]>

Returns list with all countries with at least one institution. Each entry
contains country id and country name.

=cut

sub getInstitutionCountriesData {
    my $self = shift;

    my @result = $self->simpleSelect( '
        SELECT  distinct country.id,
                country.name_cz name 
        FROM    institution inst
                LEFT JOIN address addr ON inst.location_address = addr.id
                LEFT JOIN country ON addr.country = country.id
        ORDER BY name'
    );

    return wantarray ? @result : \@result;
}

=head2 C<getAddress ( id : Int ) : HashRef[Str]>

Returns hash with information about the address specified by parameter.

=cut

sub getAddress {
    my $self = shift;
    my $id   = shift;

    my @data = $self->simpleSelect( '
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
        WHERE   address.id = ?', $id );

    if ( !@data || !$data[0] ) {
        return undef;
    }

    return $data[0];
}

=head2 C<getInstitutionInformation ( identifier : Str ) : HashRef[Item]>

Returns hash with information about one particular institution.

=cut

sub getInstitutionInformation {
    my $self       = shift;
    my $identifier = shift;

    my @data = $self->simpleSelect( '
        SELECT  inst.id,
                inst.abbreviation,
                inst.logo_url logoUrl,
                inst.location_address locationAddressId,
                inst.mailing_address mailingAddressId
        FROM    institution inst
        WHERE   inst.identifier = ?', $identifier );

    if ( !@data || !$data[0] ) {
        return undef;
    }

    my %result = %{ $data[0] };

    my $id         = $data[0]->{id};
    my @names      = $self->_getInstitutionNames($id);
    my $mainName   = '';
    my @otherNames = ();
    foreach my $nameRef (@names) {
        if ( $nameRef->{lang} && lc $nameRef->{lang} eq 'en' ) {
            $mainName = $nameRef->{name};
        }
        else {
            push @otherNames, $nameRef;
        }
    }
    if ( !$mainName ) {
        my $nameRef = shift @otherNames;
        $mainName = $nameRef->{name};
    }

    $result{name}            = $mainName;
    $result{otherNames}      = \@otherNames;
    $result{websites}        = $self->_getInstitutionWebsites($id);
    $result{factsheets}      = $self->_getInstitutionFactsheets($id);
    $result{contacts}        = $self->_getInstitutionContacts($id);
    $result{locationAddress} = $self->getAddress( $result{locationAddressId} ) if $result{locationAddressId};
    $result{mailingAddress}  = $self->getAddress( $result{mailingAddressId} ) if $result{mailingAddressId};
    $result{units}           = $self->_getInstitutionUnits($id);

    return \%result;
}

=head2 getInstitutionCities

Returns array of hashes with information about institutions home city and country.

=cut

sub getInstitutionCities {
    my $self = shift;

    my @institutions = $self->getInstitutionsListData();

    my @result = ();

    foreach my $inst (@institutions) {
        my $ident   = $inst->{identifier};
        my $name    = $inst->{mainName};
        my $city    = $inst->{city} || '';
        my $country = $inst->{country} || '';
        push @result,
          {
            address    => "$city $country",
            name       => $name,
            identifier => $ident
          };
    }

    return wantarray ? @result : \@result;
}

sub _getInstitutionNames {
    my $self = shift;
    my $id   = shift;

    my @result = $self->simpleSelect( '
        SELECT  inst.name,
                lang.abbreviation lang,
                lang.flag_url flagUrl
        FROM    institution_name inst
                LEFT JOIN language lang ON inst.language = lang.id
        WHERE   inst.institution = ?', $id );

    return wantarray ? @result : \@result;
}

sub _getInstitutionWebsites {
    my $self = shift;
    my $id   = shift;

    my @result = $self->simpleSelect( '
        SELECT  inst.url,
                lang.abbreviation lang,
                lang.flag_url flagUrl
        FROM    institution_website inst
                LEFT JOIN language lang ON inst.language = lang.id
        WHERE   inst.institution = ?', $id );

    return wantarray ? @result : \@result;
}

sub _getInstitutionFactsheets {
    my $self = shift;
    my $id   = shift;

    my $dbh = $self->dbh;

    my @result = $self->simpleSelect( '
        SELECT  inst.url,
                inst.name,
                lang.abbreviation lang,
                lang.flag_url flagUrl
        FROM    institution_factsheet inst
                LEFT JOIN language lang ON inst.language = lang.id
        WHERE   inst.institution = ?', $id );

    return wantarray ? @result : \@result;
}

sub _getInstitutionContacts {
    my $self = shift;
    my $id   = shift;

    my @data = $self->simpleSelect( '
        SELECT  contact
        FROM    institution_contact
        WHERE   institution = ?', $id );

    my @result = ();

    foreach my $row (@data) {
        my $contactId = $row->{contact} || next;
        my $contact   = $self->getContact($contactId);
        push @result, $contact if $contact;
    }

    return wantarray ? @result : \@result;
}

=head2 getContact

Returns information about one particular contact.

=cut

sub getContact {
    my $self = shift;
    my $id   = shift;

    my %contact = ();
    $contact{names}  = $self->_getContactNames($id);
    $contact{emails} = $self->_getContactEmails($id);
    $contact{phones} = $self->_getContactPhones($id);
    $contact{faxes}  = $self->_getContactFaxes($id);

    $contact{description} = $self->_getContactDescription($id);

    return \%contact;
}

sub _getContactNames {
    my $self = shift;
    my $id   = shift;

    my @result = $self->simpleSelect( '
        SELECT  con.name,
                lang.flag_url flagUrl
        FROM    contact_name con
                LEFT JOIN language lang ON con.language = lang.id
        WHERE   con.contact = ?', $id );

    return wantarray ? @result : \@result;
}

sub _getContactEmails {
    my $self = shift;
    my $id   = shift;

    my @result = $self->simpleSelect( '
        SELECT  con.email
        FROM    contact_email con
        WHERE   con.contact = ?', $id );

    return wantarray ? @result : \@result;
}

sub _getContactPhones {
    my $self = shift;
    my $id   = shift;

    my @result = $self->simpleSelect( '
        SELECT  con.phoneNumber
        FROM    contact_phone con
        WHERE   con.contact = ?', $id );

    return wantarray ? @result : \@result;
}

sub _getContactFaxes {
    my $self = shift;
    my $id   = shift;

    my @result = $self->simpleSelect( '
        SELECT  con.faxNumber
        FROM    contact_fax con
        WHERE   con.contact = ?', $id );

    return wantarray ? @result : \@result;
}

sub _getContactDescription {
    my $self = shift;
    my $id   = shift;

    my @result = $self->simpleSelect( '
        SELECT  con.text,
                lang.flag_url flagUrl
        FROM    contact_description con
                LEFT JOIN language lang ON con.language = lang.id
        WHERE   con.contact = ?', $id );

    return wantarray ? @result : \@result;
}

sub _getInstitutionUnits {
    my $self        = shift;
    my $institution = shift;

    my @units = $self->simpleSelect( '
        SELECT  id,
                code,
                abbreviation,
                logo_url logoUrl,
                location_address locationAddressId,
                mailing_address mailingAddressId
        FROM    unit
        WHERE   institution = ?', $institution );

    foreach my $unit (@units) {
        my @names    = $self->_getUnitNames( $unit->{id} );
        my $mainName = shift @names;

        $unit->{name}            = $mainName->{name};
        $unit->{otherNames}      = \@names;
        $unit->{locationAddress} = $self->getAddress( $unit->{locationAddressId} );
        $unit->{mailingAddress}  = $self->getAddress( $unit->{mailingAddressId} );
        $unit->{websites}        = $self->_getUnitWebsites( $unit->{id} );
        $unit->{factsheets}      = $self->_getUnitFactsheets( $unit->{id} );
        $unit->{contacts}        = $self->_getUnitContacts($unit->{id});
    }

    return wantarray ? @units : \@units;
}

sub _getUnitNames {
    my $self = shift;
    my $id   = shift;

    my @result = $self->simpleSelect( '
        SELECT  unit.name,
                lang.abbreviation lang,
                lang.flag_url flagUrl
        FROM    unit_name unit
                LEFT JOIN language lang ON unit.language = lang.id
        WHERE   unit.unit = ?', $id );

    my $mainName   = '';
    my @otherNames = ();

    foreach my $row (@result) {
        if ( $row->{lang} && lc $row->{lang} eq 'en' ) {
            $mainName = $row;
        }
        else {
            push @otherNames, $row;
        }
    }

    @result = @otherNames;
    unshift @result, $mainName if $mainName;

    return wantarray ? @result : \@result;
}

sub _getUnitWebsites {
    my $self = shift;
    my $id   = shift;

    my @result = $self->simpleSelect( '
        SELECT  unit.url,
                lang.abbreviation lang,
                lang.flag_url flagUrl
        FROM    unit_website unit
                LEFT JOIN language lang ON unit.language = lang.id
        WHERE   unit.unit = ?', $id );

    return wantarray ? @result : \@result;
}

sub _getUnitFactsheets {
    my $self = shift;
    my $id   = shift;

    my @result = $self->simpleSelect( '
        SELECT  unit.url,
                unit.name,
                lang.abbreviation lang,
                lang.flag_url flagUrl
        FROM    unit_factsheet unit
                LEFT JOIN language lang ON unit.language = lang.id
        WHERE   unit.unit = ?', $id );

    return wantarray ? @result : \@result;
}

sub _getUnitContacts {
    my $self = shift;
    my $id   = shift;

    my @data = $self->simpleSelect( '
        SELECT  contact
        FROM    unit_contact
        WHERE   unit = ?', $id );

    my @result = ();

    foreach my $row (@data) {
        my $contactId = $row->{contact} || next;
        my $contact   = $self->getContact($contactId);
        push @result, $contact if $contact;
    }

    return wantarray ? @result : \@result;
}

=head1 AUTHOR

Jan Konstant

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
