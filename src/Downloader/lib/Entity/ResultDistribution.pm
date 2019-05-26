package Entity::ResultDistribution;
 
use Moose;
use namespace::autoclean;
use Moose::Util::TypeConstraints;

=pod

=head1 NAME

Entity::ResultDistribution

=head1 DESCRIPTION

Entita reprezentujici vysledky studijni prilezitosti v siti EWP.

=cut

=head1 ATTRIBUTES

=head2 C<description : HashRef[Str]>

Hash popisu v ruznych jazycich.

    { 'en' => 'sample text' }

=cut

has 'description' => (
    is => 'rw',
    isa => 'HashRef[Str]',
    traits => ['Hash'],
    default => sub { {} },
    handles => {
        setDescription => 'set'
    }
);

=head2 C<gradingScheme : HashRef[HashRef[Str]]>

Hash s informacemi o schematu znamkovani.

=cut

has 'gradingScheme' => (
    is => 'rw',
    isa => 'HashRef[HashRef[Str]]',
    traits => ['Hash'],
    default => sub { {} },
    handles => {
        setGradingScheme => 'set'
    }
);

=head2 C<resultDistribution : ArrayRef[HashRef[Str]]>

Hash s informacemi o rozlozeni znamek.

=cut

has 'resultDistribution' => (
    is => 'rw',
    isa => 'ArrayRef[HashRef[Str]]',
    traits => ['Array'],
    default => sub { [] },
    handles => {
        addResultDistribution => 'push'
    }
);

no Moose;
__PACKAGE__->meta->make_immutable;

=head1 AUTHOR

Jan Konstant

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
