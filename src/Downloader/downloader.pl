#!/usr/bin/perl
use strict;
use warnings;

use lib './lib/';

use Data::Dumper;
use Downloader;

my $downloader = Downloader->new();

my $xml = $downloader->downloadCatalogue();

if ( !$xml ) {
    die 'Catalogue download failed'
      . ( $downloader->statusLine() ? ': ' . $downloader->statusLine() : '.' );
}

my $heis2endpoints = $downloader->parseCatalogueXML($xml);

my ( $statsSkipped, $statsDownloaded, $statsSaved, $statsUnsaved ) = ( 0, 0, 0, 0 );

my $dsn = "DBI:mysql:database=ewpportal;host=localhost;port=3306";
my $dbh = DBI->connect( $dsn, 'ewpportal', 'ewpportal' );

my $manager = Manager::EntityManager->new( dbh => $dbh );

foreach my $heiId ( keys %$heis2endpoints ) {
    my $endpoints = $heis2endpoints->{$heiId};

    my $institutionId = '';

    if ( $endpoints->{'institutions'} ) {

        my $institutionObject = $downloader->getInstitutionFromEndpoint( 
            endpoint => $endpoints->{'institutions'},
            heiId    => $heiId
        );

        if ( $institutionObject ) {
            warn Dumper $institutionObject;
            ++$statsDownloaded;
            if ( $manager->saveInstitution( $institutionObject ) ) {
                ++$statsSaved;
                $institutionId = $manager->getLastInsertedId();
            }
            else {
                ++$statsUnsaved;
            }
        }
        else {
            ++$statsSkipped;
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
