#!/usr/bin/perl
use strict;
use warnings;

use lib 'lib/';

use Data::Dumper;
use DBI;
use Downloader;

my $downloader = Downloader->new();

my $xml = $downloader->downloadCatalogue();

if ( !$xml ) {
    die 'Catalogue download failed'
      . ( $downloader->statusLine() ? ': ' . $downloader->statusLine() : '.' );
}

my $heis2endpoints = $downloader->parseCatalogueXML($xml);

my ( $statsSkipped, $statsDownloaded ) = ( 0, 0 );

# TODO hodit nekam pryc
my $dsn = "DBI:mysql:database=ewpportal;host=localhost;port=3306";
my $dbh = DBI->connect($dsn, 'ewpportal', 'ewpportal');

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
		warn Dumper $institutionObject;
        $dbh->do(
            'INSERT INTO institution (identifier, abbreviation, logo_url) VALUES (?,?,?)',
            undef,
            $institutionObject->identifier,
            $institutionObject->abbreviation,
            $institutionObject->logoUrl,
            # TODO address
            # TODO address
        ) or die "execution failed:" . $dbh->errstr();
        my $id = $dbh->{mysql_insertid};
        warn "id: $id";
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
