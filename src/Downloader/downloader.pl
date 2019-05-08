#!/usr/bin/perl
use strict;
use warnings;

use lib './lib/';

use Data::Dumper;
use Downloader;

my $downloader = Downloader->new();

my $xml = $downloader->downloadCatalogue();

if ( !$xml ) {
    die 'Catalogue download failed' . ( $downloader->statusLine() ? ': ' . $downloader->statusLine() : '.' );
}

my $heis2endpoints = $downloader->parseCatalogueXML($xml);

my ( $statsSkipped, $statsDownloaded, $statsSaved, $statsUnsaved ) = ( 0, 0, 0, 0 );

my $dsn = "DBI:mysql:database=ewpportal;host=localhost;port=3306";
my $dbh = DBI->connect( $dsn, 'ewpportal', 'ewpportal' );

my $manager = Manager::EntityManager->new( dbh => $dbh );

$manager->clearDatabase();

foreach my $heiId ( keys %$heis2endpoints ) {

    #next if $heiId ne 'uw.edu.pl';

    my $endpoints = $heis2endpoints->{$heiId};

    my $institutionObject = undef;

    if ( $endpoints->{'institutions'} ) {

        $institutionObject = $downloader->getInstitutionFromEndpoint( $endpoints->{'institutions'}, $heiId );

        if ($institutionObject) {
            ++$statsDownloaded;
            if ( $manager->saveInstitution($institutionObject) ) {
                ++$statsSaved;
            }

            # TODO
            #warn Dumper $institutionObject;
        }
        print $downloader->statusLine . "\n" if $downloader->statusLine;
    }
    else {
        # pokud neni institutions api, nema cenu pokracovat dal
        # TODO ale prece jenom vyzkouset
        next;
    }

    if ( $endpoints->{'organizational-units'} ) {
        # TODO stazeni org. units
    }

    if ( $endpoints->{'simple-course-replication'} ) {
        # TODO priprava pro courses
    }

    if ( $endpoints->{'courses'} ) {
        # TODO stazeni courses
    }
}

$dbh->disconnect();

$statsSkipped = scalar( keys %{ $heis2endpoints } ) - $statsDownloaded;
$statsUnsaved = $statsDownloaded - $statsSaved;

print "
downloaded: $statsDownloaded
skipped:    $statsSkipped

saved:      $statsSaved
unsaved:    $statsUnsaved
";
