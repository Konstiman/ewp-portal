#!/usr/bin/perl
use strict;
use warnings;

use lib 'lib/';

use Data::Dumper;
use Downloader;

use XML::LibXML;
use XML::LibXML::PrettyPrint;

my $downloader = Downloader->new();

my $xml = $downloader->downloadCatalogue();

print $xml;

=comment

my $dom = XML::LibXML->load_xml( string => $xml );
my $xpc = new XML::LibXML::XPathContext($dom);

$xpc->registerNs( 'c',
'https://github.com/erasmus-without-paper/ewp-specs-api-registry/tree/stable-v1'
);

my @heiNodes = $xpc->findnodes('//c:institutions/c:hei');

# TODO pouzivat pak objekty (instance Institution)
my @heiIds = ();

foreach my $hei (@heiNodes) {

    my $id = $hei->getAttribute('id');

    # TODO chyba v prefixu
    #my @nameNodes = $hei->findnodes( './c:name' );

    # TODO zpracovat jmena

    # TODO zpracovat other ids

    push @heiIds, $id;
}

$xpc->registerNs( 'in2',
'https://github.com/erasmus-without-paper/ewp-specs-api-institutions/blob/stable-v2/manifest-entry.xsd'
);

my %urls = ();

foreach my $heiId (@heiIds) {

    # TODO ostatni tri api
    my @instAPIs =
      $xpc->findnodes( '//c:hei-id[text()="'
          . $heiId
          . '"]/../../c:apis-implemented/in2:institutions' );

    next if !@instAPIs;

    # TODO volba verze
    my $instAPI = shift @instAPIs;

    # TODO ukladani nastaveni (napr. max-hei-ids)
    my $url = $xpc->findvalue( './in2:url[text()]', $instAPI );

    if ( $urls{$url} ) {
        push @{ $urls{$url} }, $heiId;
    }
    else {
        $urls{$url} = [$heiId];
    }
}

$agent->timeout(10);

foreach my $url ( keys %urls ) {

    my $heiId = shift @{ $urls{$url} };

    my $req = HTTP::Request->new( GET => $url . "?hei_id=$heiId" );

    my $resp = $agent->request($req);

    if ( $resp->is_success ) {

        my $document = XML::LibXML->load_xml( string => $resp->content );
        my $pp = XML::LibXML::PrettyPrint->new( indent_string => "    " );
        $pp->pretty_print($document);    # modified in-place
        print $document->toString;

        #print "OK!!! (status " . $resp->status_line . ") at $url\n";
    }
    else {
        #print STDERR "ERROR (status " . $resp->status_line . ") at $url\n";
    }
}

=cut
