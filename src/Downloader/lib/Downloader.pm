package Downloader;

use Moose;
use Moose::Util::TypeConstraints;

use DBI;
use Entity::Institution;
use HTTP::Request;
use LWP::UserAgent;
use Manager::EntityManager;
use XML::LibXML;
use XML::LibXML::PrettyPrint;

use constant CATALOGUE_URL =>
  'https://registry.erasmuswithoutpaper.eu/catalogue-v1.xml';

use constant VERSION => '1.0.0';

=pod

=head1 DESCRIPTION

Modul slouzi ke stazeni a ulozeni XML katalogu instituci Erasmus Without Paper.

=cut

enum Status => [qw/ ok error warning /];

has 'status' => (
    is      => 'rw',
    isa     => 'Status',
    default => 'ok'
);

has 'statusLine' => (
    is  => 'rw',
    isa => 'Str'
);

=head1 METHODS

=head2 C<downloadCatalogue () : Str>

Stahne XML katalog z adresy C<catalogueUrl>.

=cut

sub downloadCatalogue {
    my $self = shift;

    return $self->downloadXML(CATALOGUE_URL);
}

=head2 C<downloadXML ( url : Str ) : Str>

Stahne XML katalog z adresy specifikovane parametrem.

=cut

sub downloadXML {
    my $self = shift;
    my $url  = shift;

    # TODO hodit ven do atributu
    my $agent = LWP::UserAgent->new(
        agent      => 'EWP_Catalogue_Downloader/' . VERSION,
        cookie_jar => {}
    );
    $agent->timeout(10);

    my $request = HTTP::Request->new( GET => $url );

    my $response = $agent->request($request);

    if ( !$response->is_success ) {
        $self->status('error');
        $self->statusLine( "Error: " . $response->status_line . " ($url)" );
        return;
    }

    my $content = $response->content;

    return $content;
}

=head2 C<parseCatalogueXML ( xml : Str ) : HashRef[HashRef[Str]]>

Na vstupu bere string s XML katalogem. Vraci hash id hei => hash url endpointu.

=cut

sub parseCatalogueXML {
    my $self = shift;
    my $xml  = shift;

    my $dom = XML::LibXML->load_xml( string => $xml );
    my $xpc = new XML::LibXML::XPathContext($dom);

    $xpc->registerNs( 'c',
'https://github.com/erasmus-without-paper/ewp-specs-api-registry/tree/stable-v1'
    );

    my @heiElements = $xpc->findnodes('//c:institutions/c:hei');

    my %result = ();

    foreach my $heiElement (@heiElements) {

        my $heiId = $heiElement->getAttribute('id');

        next if !$heiId;

        my %apis2namespaces = (
            'institutions' =>
'https://github.com/erasmus-without-paper/ewp-specs-api-institutions/blob/stable-v2/manifest-entry.xsd',
            'organizational-units' =>
'https://github.com/erasmus-without-paper/ewp-specs-api-ounits/blob/stable-v2/manifest-entry.xsd',
            'courses' =>
'https://github.com/erasmus-without-paper/ewp-specs-api-courses/blob/stable-v1/manifest-entry.xsd',
            'simple-course-replication' =>
'https://github.com/erasmus-without-paper/ewp-specs-api-course-replication/blob/stable-v1/manifest-entry.xsd'
        );

        my %endpoints = ();

        foreach my $apiName ( keys %apis2namespaces ) {
            my $endpoint = $self->_getEndpoint(
                xpc       => $xpc,
                heiId     => $heiId,
                name      => $apiName,
                namespace => $apis2namespaces{$apiName}
            );
            if ($endpoint) {
                $endpoints{$apiName} = $endpoint;
            }
        }

        $result{$heiId} = \%endpoints if keys %endpoints;
    }

    return \%result;
}

sub _getEndpoint {
    my $self   = shift;
    my %params = @_;

    my $xpc   = $params{xpc} || die 'Mandatory parameter "xpc" not inserted!';
    my $heiId = $params{heiId}
      || die 'Mandatory parameter "heiId" not inserted!';
    my $name = $params{name} || die 'Mandatory parameter "name" not inserted!';
    my $ns   = $params{namespace}
      || die 'Mandatory parameter "namespace" not inserted!';

    $xpc->registerNs( 'ns', $ns );

    my @instAPIs =
      $xpc->findnodes( '//c:hei-id[text()="'
          . $heiId
          . '"]/../../c:apis-implemented/ns:'
          . $name );

    return if !@instAPIs;

    # TODO volba verze
    my $instAPI = shift @instAPIs;

    # TODO ukladani nastaveni (napr. max-hei-ids)
    my $url = $xpc->findvalue( './ns:url[text()]', $instAPI );

    return $url;
}

=head2 C<parseInstitutionsXML ( xml : Str ) : Entity::Institution>

Na vstupu bere string s XML souborem s informacemi o instituci. Vraci objekt tridy Institution.

=cut

sub parseInstitutionsXML {
    my $self = shift;
    my $xml  = shift;

    my $instObject = Entity::Institution->new();

    my $dom = XML::LibXML->load_xml( string => $xml );
    my $xpc = new XML::LibXML::XPathContext($dom);

    #warn $dom->toString(1);

    $xpc->registerNs( 'in',
'https://github.com/erasmus-without-paper/ewp-specs-api-institutions/tree/stable-v2'
    );

    my $heiElement = ( $xpc->findnodes('//in:hei') )[0];

    my $identifier = $xpc->findvalue( './in:hei-id[text()]', $heiElement );
    if ($identifier) {
        $instObject->identifier($identifier);
    }

    my @otherIds = $xpc->findnodes( './in:other-id', $heiElement );
    foreach my $otherIdElem (@otherIds) {
        my $id   = $otherIdElem->textContent;
        my $type = $otherIdElem->getAttribute('type') || 'unknown';
        $instObject->setOtherIdentifier( $type, $id );
    }

    my @names = $xpc->findnodes( './in:name', $heiElement );
    foreach my $nameElem (@names) {
        my $name = $nameElem->textContent;
        my $lang = $nameElem->getAttribute('xml:lang') || 'unknown';
        $instObject->setName( $lang, $name );
    }

    my $abbreviation =
      $xpc->findvalue( './in:abbreviation[text()]', $heiElement );
    if ($abbreviation) {
        $instObject->abbreviation($abbreviation);
    }

    $xpc->registerNs( 'a',
'https://github.com/erasmus-without-paper/ewp-specs-types-address/tree/stable-v1'
    );
    my $streetAddressElem =
      ( $xpc->findnodes( './a:street-address', $heiElement ) )[0];
    if ($streetAddressElem) {
        my $addressObject = $self->_parseAddressXML(
            xpc            => $xpc,
            addressElement => $streetAddressElem
        );
        $instObject->locationAddress($addressObject) if $addressObject;
    }

    my $mailAddressElem =
      ( $xpc->findnodes( './a:mailing-address', $heiElement ) )[0];
    if ($mailAddressElem) {
        my $addressObject = $self->_parseAddressXML(
            xpc            => $xpc,
            addressElement => $mailAddressElem
        );
        $instObject->mailingAddress($addressObject) if $addressObject;
    }

    my @webs = $xpc->findnodes( './in:website-url', $heiElement );
    foreach my $webElem (@webs) {
        my $web  = $webElem->textContent;
        my $lang = $webElem->getAttribute('xml:lang') || 'unknown';
        $instObject->setWebsite( $web, $lang );
    }

    my $logoUrl = $xpc->findvalue( './in:logo-url[text()]', $heiElement );
    if ($logoUrl) {
        $instObject->logoUrl($logoUrl);
    }

    my @factsheets =
      $xpc->findnodes( './in:mobility-factsheet-url', $heiElement );
    foreach my $factsheetElem (@factsheets) {
        my $url  = $factsheetElem->textContent;
        my $lang = $factsheetElem->getAttribute('xml:lang') || 'unknown';
        $instObject->setFactsheet( $url, $lang );
    }

    $xpc->registerNs( 'c',
'https://github.com/erasmus-without-paper/ewp-specs-types-contact/tree/stable-v1'
    );
    my @contacts = $xpc->findnodes( './c:contact', $heiElement );
    foreach my $contactElement (@contacts) {
        my $contactObject = $self->_parseContactXML(
            xpc            => $xpc,
            contactElement => $contactElement
        );
        $instObject->addContact($contactObject) if $contactObject;
    }

    my $rootUnitId =
      $xpc->findvalue( './in:root-ounit-id[text()]', $heiElement );
    if ($rootUnitId) {
        $instObject->rootUnitId($rootUnitId);
    }

    my @unitIds = $xpc->findnodes( './in:ounit-id', $heiElement );
    foreach my $idElem (@unitIds) {
        my $id = $idElem->textContent;
        $instObject->addUnitId($id);
    }

    return $instObject;
}

sub _parseAddressXML {
    my $self   = shift;
    my %params = @_;

    my $xpc = $params{xpc} || die 'Mandatory parameter "xpc" not inserted!';
    my $addressElement = $params{addressElement}
      || die 'Mandatory parameter "addressElement" not inserted!';

    # TODO

    return undef;
}

sub _parseContactXML {
    my $self   = shift;
    my %params = @_;

    my $xpc = $params{xpc} || die 'Mandatory parameter "xpc" not inserted!';
    my $contactElement = $params{contactElement}
      || die 'Mandatory parameter "contactElement" not inserted!';

    # TODO

    return undef;
}

# TODO dokumentace
sub getInstitutionFromEndpoint {
    my $self   = shift;
    my %params = @_;

    my $endpoint = $params{ endpoint } || die 'Mandatory parameter "endpoint" not inserted!';
    my $heiId    = $params{ heiId }    || die 'Mandatory parameter "heiId" not inserted!';

    my $xml = $self->downloadXML(
        $endpoint . '?hei_id=' . $heiId 
    );

    if (!$xml) {
        print $self->statusLine . "\n";
        return undef;
    }

    my $institutionObject = $self->parseInstitutionsXML($xml);

    return $institutionObject;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
