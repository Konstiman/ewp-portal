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

my $heis2endpoints = $downloader->parseCatalogueXML($xml);

my ( $statsSkipped, $statsDownloaded ) = ( 0, 0 );

foreach my $heiId ( keys %$heis2endpoints ) {
    my $endpoints = $heis2endpoints->{$heiId};

    if ( $endpoints->{'institutions'} ) {
        my $xml = $downloader->downloadXML(
            $endpoints->{'institutions'} . '?hei_id=' . $heiId );
        if ($xml) {
            ++$statsDownloaded;
        }
        else {
        # pokud nejsou ani zakladni informace o univerzite, nema cenu pokracovat
            ++$statsSkipped;
            print $downloader->statusLine() . "\n";
            next;
        }
		my $institutionObject = $downloader->parseInstitutionsXML($xml);
		# TODO ulozit objekt pomoci manazera
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
