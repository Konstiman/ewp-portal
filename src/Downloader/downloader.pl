#!/usr/bin/perl
use strict;
use warnings;

use lib 'lib/';

use Data::Dumper;
use Downloader;

my $downloader = Downloader->new();

my $xml = $downloader->downloadCatalogue();

if ( !$xml ) {
    die 'Catalogue download failed'
      . ( $downloader->statusLine() ? ': ' . $downloader->statusLine() : '.' );
}

my $heis2endpoints = $downloader->parseCatalogueXML( $xml );

my ( $statsSkipped, $statsDownloaded ) = ( 0, 0 );

foreach my $heiId (keys %$heis2endpoints) {
	my $endpoints = $heis2endpoints->{ $heiId };

	if ( $endpoints->{ 'institutions' } ) {
		my $xml = $downloader->downloadXML( $endpoints->{ 'institutions' } . '?hei_id=' . $heiId );
		if ( $xml ) {
			++$statsDownloaded;
			print "\n$xml\n\n";
		}
		else {
			# pokud nejsou ani zakladni informace o univerzite, nema cenu pokracovat
			++$statsSkipped;
			print $downloader->statusLine() . "\n";
			next;
		}
	}
	else {
		# pokud nejsou ani zakladni informace o univerzite, nema cenu pokracovat
		++$statsSkipped;
		next;
	}
}

print "
downloaded: $statsDownloaded
skipped:    $statsSkipped
";

=comment

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
