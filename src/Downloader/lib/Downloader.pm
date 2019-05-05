package Downloader;

use Moose;

use HTTP::Request;
use LWP::UserAgent;

use constant CATALOGUE_URL =>
  'https://registry.erasmuswithoutpaper.eu/catalogue-v1.xml';

use constant VERSION => '1.0.0';

=pod

=head1 DESCRIPTION

Modul slouzi ke stazeni a ulozeni XML katalogu instituci Erasmus Without Paper.

=head1 METHODS

=head2 C<downloadCatalogue () : Str>

Stahne XML katalog z adresy C<catalogueUrl>.

=cut

sub downloadCatalogue {
    my $self = shift;

    my $agent = LWP::UserAgent->new(
        agent      => 'EWP_Catalogue_Downloader/' . VERSION,
        cookie_jar => {}
    );
    my $request = HTTP::Request->new( GET => CATALOGUE_URL );

    my $response = $agent->request( $request );

    if ( !$response->is_success ) {
        die 'Catalogue download failed: ' . $response->status_line;
    }

    my $content = $response->content;

    return $content;
}

no Moose;
__PACKAGE__->meta->make_immutable;
