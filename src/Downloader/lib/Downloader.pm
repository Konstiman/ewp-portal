package Downloader;

use Moose;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

=pod

=head1 DESCRIPTION

Modul slouzi ke stazeni a ulozeni XML katalogu instituci Erasmus Without Paper.

=cut

use DBI;
use Entity::Address;
use Entity::Contact;
use Entity::Institution;
use Entity::LearningOpportunity;
use Entity::Unit;
use HTTP::Request;
use LWP::UserAgent;
use Manager::EntityManager;
use XML::LibXML;

use constant CATALOGUE_URL => 'https://registry.erasmuswithoutpaper.eu/catalogue-v1.xml';

use constant DEV_CATALOGUE_URL => 'https://dev-registry.erasmuswithoutpaper.eu/catalogue-v1.xml';

use constant DEVEL_MODE => 0;

use constant VERSION => '1.0.0';

enum Status => [qw/ ok error warning /];

=head1 ATTRIBUTES

=head2 C<status : Str>

Reprezentuje stav downloaderu. Pripustne jsou hodnoty 'ok', 'error' a 'warning'.

=cut

has 'status' => (
    is      => 'rw',
    isa     => 'Status',
    default => 'ok'
);

=head2 C<status : Str>

Textovy komentar stavu downloaderu.

=cut

has 'statusLine' => (
    is  => 'rw',
    isa => 'Str'
);

=head1 METHODS

=head2 C<downloadCatalogue () : Str>

Stahne XML katalog z adresy C<catalogueUrl>.

=cut

sub downloadCatalogue {
    my $self = shift;

    if (DEVEL_MODE) {
        warn "DOWNLOADING DEVEL CATALOGUE!!!";
        return $self->downloadXML(DEV_CATALOGUE_URL);
    }

    return $self->downloadXML(CATALOGUE_URL);
}

=head2 C<downloadXML ( url : Str ) : Str>

Stahne XML katalog z adresy specifikovane parametrem.

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

    $self->status('ok');
    $self->statusLine("Ok:    200 Data from endpoint downloaded successfully ($url)");

    my $content = $response->content;

    return $content;
}

=head2 C<parseCatalogueXML ( xml : Str ) : HashRef[HashRef[Str]]>

Na vstupu bere string s XML katalogem. Vraci hash id hei => hash url endpointu.

=cut

sub parseCatalogueXML {
    my $self = shift;
    my $xml  = shift;

    my $dom = XML::LibXML->load_xml( string => $xml );
    my $xpc = new XML::LibXML::XPathContext($dom);

    $xpc->registerNs( 'c', 'https://github.com/erasmus-without-paper/ewp-specs-api-registry/tree/stable-v1' );

    my @heiElements = $xpc->findnodes('//c:institutions/c:hei');

    my %result = ();

    foreach my $heiElement (@heiElements) {

        my $heiId = $heiElement->getAttribute('id');

        next if !$heiId;

        my %apis2namespaces = (
            'institutions'              => 'https://github.com/erasmus-without-paper/ewp-specs-api-institutions/blob/stable-v2/manifest-entry.xsd',
            'organizational-units'      => 'https://github.com/erasmus-without-paper/ewp-specs-api-ounits/blob/stable-v2/manifest-entry.xsd',
            'courses'                   => 'https://github.com/erasmus-without-paper/ewp-specs-api-courses/blob/stable-v1/manifest-entry.xsd',
            'simple-course-replication' => 'https://github.com/erasmus-without-paper/ewp-specs-api-course-replication/blob/stable-v1/manifest-entry.xsd'
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

    my $xpc   = $params{xpc}       || die 'Mandatory parameter "xpc" not inserted!';
    my $heiId = $params{heiId}     || die 'Mandatory parameter "heiId" not inserted!';
    my $name  = $params{name}      || die 'Mandatory parameter "name" not inserted!';
    my $ns    = $params{namespace} || die 'Mandatory parameter "namespace" not inserted!';

    $xpc->registerNs( 'ns', $ns );

    my @instAPIs = $xpc->findnodes( '//c:hei-id[text()="' . $heiId . '"]/../../c:apis-implemented/ns:' . $name );

    return if !@instAPIs;

    # TODO volba verze
    my $instAPI = shift @instAPIs;

    # TODO ukladani nastaveni (napr. max-hei-ids)
    my $url = $xpc->findvalue( './ns:url[text()]', $instAPI );

    return $url;
}

=head2 C<parseInstitutionsXML ( xml : Str ) : Entity::Institution>

Na vstupu bere string s XML souborem s informacemi o instituci. Vraci objekt tridy Institution.

=cut

sub parseInstitutionsXML {
    my $self = shift;
    my $xml  = shift;

    my $instObject = Entity::Institution->new();

    my $dom = XML::LibXML->load_xml( string => $xml );
    my $xpc = new XML::LibXML::XPathContext($dom);

    #warn $dom->toString(1);

    $xpc->registerNs( 'in', 'https://github.com/erasmus-without-paper/ewp-specs-api-institutions/tree/stable-v2' );

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

    my $abbreviation = $xpc->findvalue( './in:abbreviation[text()]', $heiElement );
    if ($abbreviation) {
        $instObject->abbreviation($abbreviation);
    }

    $xpc->registerNs( 'a', 'https://github.com/erasmus-without-paper/ewp-specs-types-address/tree/stable-v1' );
    my $streetAddressElem = ( $xpc->findnodes( './a:street-address', $heiElement ) )[0];
    if ($streetAddressElem) {
        my $addressObject = $self->_parseAddressXML( xpc => $xpc, addressElement => $streetAddressElem );
        $instObject->locationAddress($addressObject) if $addressObject;
    }

    my $mailAddressElem = ( $xpc->findnodes( './a:mailing-address', $heiElement ) )[0];
    if ($mailAddressElem) {
        my $addressObject = $self->_parseAddressXML( xpc => $xpc, addressElement => $mailAddressElem );
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

    my @factsheets = $xpc->findnodes( './in:mobility-factsheet-url', $heiElement );
    foreach my $factsheetElem (@factsheets) {
        my $url  = $factsheetElem->textContent;
        my $lang = $factsheetElem->getAttribute('xml:lang') || 'unknown';
        $instObject->setFactsheet( $url, $lang );
    }

    $xpc->registerNs( 'c', 'https://github.com/erasmus-without-paper/ewp-specs-types-contact/tree/stable-v1' );
    my @contacts = $xpc->findnodes( './c:contact', $heiElement );
    foreach my $contactElement (@contacts) {
        my $contactObject = $self->_parseContactXML( xpc => $xpc, contactElement => $contactElement );
        $instObject->addContact($contactObject) if $contactObject;
    }

    my $rootUnitId = $xpc->findvalue( './in:root-ounit-id[text()]', $heiElement );
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

    my $xpc            = $params{xpc}            || die 'Mandatory parameter "xpc" not inserted!';
    my $addressElement = $params{addressElement} || die 'Mandatory parameter "addressElement" not inserted!';

    my $addressObject = Entity::Address->new();

    my $recipient      = '';
    my @recipientNames = $xpc->findnodes( 'a:recipientName', $addressElement );
    foreach my $name (@recipientNames) {
        $recipient .= ( $recipient ? "\n" : '' ) . $name->textContent();
    }

    $addressObject->recipient($recipient) if $recipient;

    my $lines        = '';
    my @addressLines = $xpc->findnodes( 'a:addressLine', $addressElement );
    foreach my $line (@addressLines) {
        $lines .= ( $lines ? "\n" : '' ) . $line->textContent();
    }

    $addressObject->lines($lines) if $lines;

    my $buildingNumber = ( $xpc->findnodes( 'a:buildingNumber',    $addressElement ) )[0];
    my $buildingName   = ( $xpc->findnodes( 'a:buildingName',      $addressElement ) )[0];
    my $streetName     = ( $xpc->findnodes( 'a:streetName',        $addressElement ) )[0];
    my $unit           = ( $xpc->findnodes( 'a:unit',              $addressElement ) )[0];
    my $floor          = ( $xpc->findnodes( 'a:floor',             $addressElement ) )[0];
    my $pobox          = ( $xpc->findnodes( 'a:postOfficeBox',     $addressElement ) )[0];
    my $deliveryPoint  = ( $xpc->findnodes( 'a:deliveryPointCode', $addressElement ) )[0];
    my $postalCode     = ( $xpc->findnodes( 'a:postalCode',        $addressElement ) )[0];
    my $locality       = ( $xpc->findnodes( 'a:locality',          $addressElement ) )[0];
    my $region         = ( $xpc->findnodes( 'a:region',            $addressElement ) )[0];
    my $country        = ( $xpc->findnodes( 'a:country',           $addressElement ) )[0];

    $addressObject->buildingNumber( $buildingNumber->textContent() ) if $buildingNumber;
    $addressObject->buildingName( $buildingName->textContent() )     if $buildingName;
    $addressObject->streetName( $streetName->textContent() )         if $streetName;
    $addressObject->unit( $unit->textContent() )                     if $unit;
    $addressObject->floor( $floor->textContent() )                   if $floor;
    $addressObject->pobox( $pobox->textContent() )                   if $pobox;
    $addressObject->deliveryPoint( $deliveryPoint->textContent() )   if $deliveryPoint;
    $addressObject->postalCode( $postalCode->textContent() )         if $postalCode;
    $addressObject->locality( $locality->textContent() )             if $locality;
    $addressObject->region( $region->textContent() )                 if $region;
    $addressObject->country( $country->textContent() )               if $country;

    return $addressObject;
}

sub _parseContactXML {
    my $self   = shift;
    my %params = @_;

    my $xpc            = $params{xpc}            || die 'Mandatory parameter "xpc" not inserted!';
    my $contactElement = $params{contactElement} || die 'Mandatory parameter "contactElement" not inserted!';

    $xpc->registerNs( 'p', 'https://github.com/erasmus-without-paper/ewp-specs-types-phonenumber/tree/stable-v1' );

    my $contactObject = Entity::Contact->new();

    my @names = $xpc->findnodes( "c:contact-name", $contactElement );
    foreach my $name (@names) {
        my $lang = $name->getAttribute('xml:lang') || 'unknown';
        $contactObject->setName( $lang, $name->textContent() );
    }

    # TODO vsecky jmena
    # skipping given names & family names

    my $gender = ( $xpc->findnodes( 'c:gender', $contactElement ) )[0];
    if ($gender) {
        $contactObject->gender( $gender->textContent() );
    }

    my @phones = $xpc->findnodes( "p:phone-number", $contactElement );
    foreach my $phone (@phones) {
        $contactObject->addPhone( $phone->textContent() );
    }

    my @faxes = $xpc->findnodes( "p:fax-number", $contactElement );
    foreach my $fax (@faxes) {
        $contactObject->addFax( $fax->textContent() );
    }

    my @emails = $xpc->findnodes( "c:email", $contactElement );
    foreach my $email (@emails) {
        $contactObject->addEmail( $email->textContent() );
    }

    my $locationAddress = ( $xpc->findnodes( 'a:street-address', $contactElement ) )[0];
    if ($locationAddress) {
        my $addressObject = $self->_parseAddressXML( addressElement => $locationAddress, xpc => $xpc );
        $contactObject->setAddress( 'street-address', $addressObject ) if $addressObject;
    }
    my $mailingAddress = ( $xpc->findnodes( 'a:mailing-address', $contactElement ) )[0];
    if ($mailingAddress) {
        my $addressObject = $self->_parseAddressXML( addressElement => $mailingAddress, xpc => $xpc );
        $contactObject->setAddress( 'mailing-address', $mailingAddress ) if $addressObject;
    }

    my @descs = $xpc->findnodes( "c:role-description", $contactElement );
    foreach my $desc (@descs) {
        my $lang = $desc->getAttribute('xml:lang') || 'unknown';
        $contactObject->setDescription( $lang, $desc->textContent() );
    }

    return $contactObject;
}

=head2 C<getInstitutionFromEndpoint( endpoint : Str, heiId : Str ) : Entity::Institution>

Z url adresy stahne XML data a naparsuje je. Vraci objekt tridy Institution. 

=cut

sub getInstitutionFromEndpoint {
    my $self     = shift;
    my $endpoint = shift;
    my $heiId    = shift;

    my $xml = $self->downloadXML( $endpoint . '?hei_id=' . $heiId );

    if ( !$xml ) {
        return undef;
    }

    my $institutionObject = $self->parseInstitutionsXML($xml);

    return $institutionObject;
}

=head2 C<getUnitsFromEndpoint( endpoint : Str, institution : Entity::Institution ) : Entity::Unit>

Z url adresy stahne XML data a naparsuje je. Vraci pole objektu tridy Unit.

=cut

sub getUnitsFromEndpoint {
    my $self        = shift;
    my $endpoint    = shift;
    my $institution = shift;

    if ( !$institution->unitIds ) {
        return [];
    }

    my @result = ();

    foreach my $unitId ( @{ $institution->unitIds } ) {
        my $xml = $self->downloadXML( $endpoint . '?hei_id=' . $institution->identifier . '&ounit_id=' . $unitId );
        print $self->statusLine . "\n" if $self->statusLine;
        if ( !$xml ) {
            next;
        }

        my $unitObject = $self->parseUnitXML($xml);
        $unitObject->institution($institution);
        push @result, $unitObject if $unitObject;
    }

    return \@result;
}

=head2 C<parseUnitXML ( xml : Str ) : Entity::Unit>

Na vstupu bere string s XML souborem s informacemi o organizacni jednotce. Vraci objekt tridy Unit.

=cut

sub parseUnitXML {
    my $self = shift;
    my $xml  = shift;

    my $unitObject = Entity::Unit->new();

    my $dom = XML::LibXML->load_xml( string => $xml );
    my $xpc = new XML::LibXML::XPathContext($dom);

    $xpc->registerNs( 'ou', 'https://github.com/erasmus-without-paper/ewp-specs-api-ounits/tree/stable-v2' );

    my $unitElement = ( $xpc->findnodes('//ou:ounit') )[0];

    my $identifier = $xpc->findvalue( './ou:ounit-id[text()]', $unitElement );
    if ($identifier) {
        $unitObject->identifier($identifier);
    }

    my $code = $xpc->findvalue( './ou:ounit-code[text()]', $unitElement );
    if ($code) {
        $unitObject->code($code);
    }

    my @names = $xpc->findnodes( './ou:name', $unitElement );
    foreach my $nameElem (@names) {
        my $name = $nameElem->textContent;
        my $lang = $nameElem->getAttribute('xml:lang') || 'unknown';
        $unitObject->setName( $lang, $name );
    }

    my $abbreviation = $xpc->findvalue( './ou:abbreviation[text()]', $unitElement );
    if ($abbreviation) {
        $unitObject->abbreviation($abbreviation);
    }

    my $parentIdentifier = $xpc->findvalue( './ou:parent-ounit-id[text()]', $unitElement );
    if ($parentIdentifier) {
        $unitObject->parentIdentifier($parentIdentifier);
    }

    $xpc->registerNs( 'a', 'https://github.com/erasmus-without-paper/ewp-specs-types-address/tree/stable-v1' );
    my $streetAddressElem = ( $xpc->findnodes( './a:street-address', $unitElement ) )[0];
    if ($streetAddressElem) {
        my $addressObject = $self->_parseAddressXML( xpc => $xpc, addressElement => $streetAddressElem );
        $unitObject->locationAddress($addressObject) if $addressObject;
    }

    my $mailAddressElem = ( $xpc->findnodes( './a:mailing-address', $unitElement ) )[0];
    if ($mailAddressElem) {
        my $addressObject = $self->_parseAddressXML( xpc => $xpc, addressElement => $mailAddressElem );
        $unitObject->mailingAddress($addressObject) if $addressObject;
    }

    my @webs = $xpc->findnodes( './ou:website-url', $unitElement );
    foreach my $webElem (@webs) {
        my $web  = $webElem->textContent;
        my $lang = $webElem->getAttribute('xml:lang') || 'unknown';
        $unitObject->setWebsite( $web, $lang );
    }

    my $logoUrl = $xpc->findvalue( './ou:logo-url[text()]', $unitElement );
    if ($logoUrl) {
        $unitObject->logoUrl($logoUrl);
    }

    my @factsheets = $xpc->findnodes( './ou:mobility-factsheet-url', $unitElement );
    foreach my $factsheetElem (@factsheets) {
        my $url  = $factsheetElem->textContent;
        my $lang = $factsheetElem->getAttribute('xml:lang') || 'unknown';
        $unitObject->setFactsheet( $url, $lang );
    }

    $xpc->registerNs( 'c', 'https://github.com/erasmus-without-paper/ewp-specs-types-contact/tree/stable-v1' );
    my @contacts = $xpc->findnodes( './c:contact', $unitElement );
    foreach my $contactElement (@contacts) {
        my $contactObject = $self->_parseContactXML( xpc => $xpc, contactElement => $contactElement );
        $unitObject->addContact($contactObject) if $contactObject;
    }

    return $unitObject;
}

=head2 C<getOpportunityIdsFromEndpoint ( endpoint : Str, heiId : Str ) : ArrayRef[Str]>

Stahne a rozparsuje seznam id studijnich prilezitosti dane HEI z daneho endpointu.

=cut

sub getOpportunityIdsFromEndpoint {
    my $self     = shift;
    my $endpoint = shift;
    my $heiId    = shift;

    my $xml = $self->downloadXML( $endpoint . '?hei_id=' . $heiId );

    if ( !$xml ) {
        return [];
    }

    my $result = $self->parseCourseReplicationXML($xml);

    return $result;
}

=head2 C<parseCourseReplicationXML ( xml : Str ) : ArrayRef[Str]>

Rozparsuje seznam id studijnich prilezitosti dane HEI z daneho endpointu.

=cut

sub parseCourseReplicationXML {
    my $self = shift;
    my $xml  = shift;

    my @result = ();

    my $dom = XML::LibXML->load_xml( string => $xml );
    my $xpc = new XML::LibXML::XPathContext($dom);

    $xpc->registerNs( 'cr', 'https://github.com/erasmus-without-paper/ewp-specs-api-course-replication/tree/stable-v1' );

    my $responseElement = ( $xpc->findnodes('//cr:course-replication-response') )[0];

    my @idElements = $xpc->findnodes( 'cr:los-id', $responseElement );

    foreach my $element (@idElements) {
        push @result, $element->textContent();
    }

    return \@result;
}

=head2 C<getOpportunitiesFromEndpoint ( endpoint : Str, heiId : Str, courseIdsRef : ArrayRef[Str] ) : ArrayRef[Str]>

Stahne a rozparsuje seznam studijnich prilezitosti dane HEI z daneho endpointu.

=cut

sub getOpportunitiesFromEndpoint {
    my $self         = shift;
    my $endpoint     = shift;
    my $heiId        = shift;
    my $courseIdsRef = shift;

    my @result = ();

    foreach my $losId (@$courseIdsRef) {
        my $xml = $self->downloadXML( $endpoint . "?hei_id=$heiId&los_id=$losId" );

        if ( !$xml ) {
            next;
        }

        my $opportunityObject = $self->parseCourseXML($xml);
    }

    return \@result;
}

=head2 C<parseCourseXML ( xml : Str ) : Entity::LearningOpportunity>

Rozparsuje xml se studijni prilezitosti. Vraci objekt tridy LearningOpportunity.

=cut

sub parseCourseXML {
    my $self = shift;
    my $xml  = shift;

    my $opportunity = Entity::LearningOpportunity->new();

    # TODO

    return $opportunity;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
