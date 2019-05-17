package StudentPortal::Controller::Root;
use Moose;
use namespace::autoclean;

use Data::Dumper;

BEGIN { extends 'Catalyst::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=encoding utf-8

=head1 NAME

StudentPortal::Controller::Root - Root Controller for StudentPortal

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash(template => 'mainPage.tt2')
}

=head2 list

The institution list page (/list)

=cut

sub list :Local :Args(0) {
    my ( $self, $c ) = @_;

    my $parameters = $c->request->parameters;
    my %filter = ();
    if ( $parameters->{ 'countryFilter' } && $parameters->{ 'countryFilter' } =~ /^\d+$/ ) {
        $filter{ country } = $parameters->{ 'countryFilter' };
        $c->stash(filteredCountry => $parameters->{ 'countryFilter' });
    }

    my @institutions = $c->model('DBIModel')->getInstitutionsListData(\%filter);
    $c->stash(institutions => \@institutions);

    my @countries = $c->model('DBIModel')->getInstitutionCountriesData();
    $c->stash(countries => \@countries);

    $c->stash(template => 'list.tt2')
}

=head2 institution

The particular institution page (/institution/:identifier)

=cut

sub institution :Local :Args(1) {
    my ( $self, $c, $identifier ) = @_;

    my $institution = $c->model('DBIModel')->getInstitutionData($identifier);

    $c->stash(institution => $institution);

    $c->stash(template => 'institution.tt2')
}

=head2 map

The map page (/map)

=cut

sub map :Local :Args(0) {
    my ( $self, $c ) = @_;

    my @institutionCities = $c->model('DBIModel')->getInstitutionCities();

    $c->stash(places => \@institutionCities);

    $c->stash(template => 'map.tt2')
}

=head2 search

The search page (/search)

=cut

sub search :Local :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash(template => 'search.tt2')
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->stash(template => '404.tt2');
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Jan Konstant,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
