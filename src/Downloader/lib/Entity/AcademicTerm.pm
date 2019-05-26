package Entity::AcademicTerm;
 
use Moose;
use namespace::autoclean;
use Moose::Util::TypeConstraints;

=pod

=head1 DESCRIPTION

Entita reprezentujici akademicke obdobi v siti EWP.

=cut

=head1 ATTRIBUTES

=head2 C<identifier : Str>

Identifikator akademickeho roku.

=cut

has 'identifier' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<ewpIdentifier : Str>

Identifikator akademickeho roku v ramci EWP.

=cut

has 'identifier' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<names : HashRef[Str]>

Hash jmen v ruznych jazycich.

    { 'en' => 'sample text' }

=cut

has 'names' => (
    is => 'rw',
    isa => 'HashRef[Str]',
    traits => ['Hash'],
    default => sub { {} },
    handles => {
        setName => 'set'
    }
);

=head2 C<start : Str>

Zacatek obdobi.

=cut

has 'start' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<end : Str>

Konec obdobi.

=cut

has 'end' => (
    is => 'rw',
    isa => 'Str'
);

no Moose;
__PACKAGE__->meta->make_immutable;

1;
