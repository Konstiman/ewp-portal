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
my $dbh = DBI->connect( $dsn, 'ewpportal', 'ewpportal', { mysql_enable_utf8 => 1 } );

my $manager = Manager::EntityManager->new( dbh => $dbh );

$manager->clearDatabase();

foreach my $heiId ( keys %$heis2endpoints ) {
    my $endpoints = $heis2endpoints->{$heiId};

    my $institutionObject = undef;

    if ( $endpoints->{'institutions'} ) {

        $institutionObject = $downloader->getInstitutionFromEndpoint( $endpoints->{'institutions'}, $heiId );

        if ($institutionObject) {
            ++$statsDownloaded;
            if ( $manager->saveInstitution($institutionObject) ) {
                ++$statsSaved;
            }
        }
        print $downloader->statusLine . "\n" if $downloader->statusLine;
    }

    if (!$institutionObject) {
        # pokud neni institutions api, nema cenu pokracovat dal
        next;
    }

    if ( $endpoints->{'organizational-units'} ) {
        my @unitObjects = @{ $downloader->getUnitsFromEndpoint( $endpoints->{'organizational-units'}, $institutionObject ) };
        foreach my $unit (@unitObjects) {
            $manager->saveUnit($unit);
        }
    }

    if ( $endpoints->{'simple-course-replication'} && $endpoints->{'courses'} ) {
        my @loIds = @{ $downloader->getOpportunityIdsFromEndpoint( $endpoints->{'simple-course-replication'}, $heiId ) };
        print $downloader->statusLine . "\n" if $downloader->statusLine;
        if ( @loIds ) {
            my @loObjects = @{ $downloader->getOpportunitiesFromEndpoint( $endpoints->{'courses'}, $heiId, \@loIds ) };
            foreach my $loObject (@loObjects) {
                $manager->saveOpportunity($loObject);
            }
        }
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
