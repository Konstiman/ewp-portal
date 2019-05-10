package Entity::Institution;
 
use Moose;
use namespace::autoclean;

=head1 DESCRIPTION

Entita reprezentujici instituci (HEI) v siti EWP.

=cut

=head1 ATTRIBUTES

=head2 C<id : Int>

Id instituce, pod kterym je ulozena v databazi.

=cut

has 'id' => (
	is => 'rw',
    isa => 'Int'
);

=head2 C<identifier : Str>

Identifikator instituce, pod kterym je HEI identifikovatelna v EWP (napr. 'uw.edu.pl').

=cut

has 'identifier' => (
	is => 'rw',
    isa => 'Str'
);

=head2 C<otherIdentifiers : HashRef[Str]>

Hash ostatnich identifikatoru, pod kterymi je HEI identifikovatelna mimo EWP.

    { 'erasmus' => 'PL WARSZAW01' }

=cut

has 'otherIdentifiers' => (
	is => 'rw',
    isa => 'HashRef[Str]',
    traits => ['Hash'],
    default => sub { { } },
    handles => {
        setOtherIdentifier => 'set'
    }
);

=head2 C<names : HashRef[Str]>

Hash jmen instituce v ruznych jazycich.

    { 'en' => 'University of Warsaw' }

=cut

has 'names' => (
	is => 'rw',
    isa => 'HashRef[Str]',
    traits => ['Hash'],
    default => sub { { } },
    handles => {
        setName => 'set'
    }
);

=head2 C<abbreviation : Str>

Zkratka nazvu instituce.

=cut

has 'abbreviation' => (
	is => 'rw',
    isa => 'Str'
);

=head2 C<logoUrl : Str>

Odkaz na logo instituce.

=cut

has 'logoUrl' => (
	is => 'rw',
    isa => 'Str'
);

=head2 C<websites : HashRef[Str]>

Hash webu instituce v ruznych jazycich.

    { 'http://uw.edu.pl/' => 'pl' }

=cut

has 'websites' => (
	is => 'rw',
    isa => 'HashRef[Str]',
    traits => ['Hash'],
    default => sub { { } },
    handles => {
        setWebsite => 'set'
    }
);

=head2 C<factsheets : HashRef[Str]>

Hash url factsheetu instituce v ruznych jazycich.

    { 'https://uw.edu.pl/docs/factsheet.pdf' => 'en' }

=cut

has 'factsheets' => (
	is => 'rw',
    isa => 'HashRef[Str]',
    traits => ['Hash'],
    default => sub { { } },
    handles => {
        setFactsheet => 'set'
    }
);

=head2 C<mailingAddress : Entity::Address>

Dorucovaci adresa instituce.

=cut

has 'mailingAddress' => (
	is => 'rw',
    isa => 'Object'
);

=head2 C<locationAddress : Entity::Address>

Mistni adresa instituce.

=cut

has 'locationAddress' => (
	is => 'rw',
    isa => 'Object'
);

=head2 C<contacts : ArrayRef[Entity::Contact]>

Seznam kontaktu instituce.

=cut

has 'contacts' => (
	is => 'rw',
    isa => 'ArrayRef[Object]',
    traits => ['Array'],
    default => sub { [ ] },
    handles => {
        addContact => 'push'
    }
);

has 'rootUnitId' => (
    is => 'rw',
    isa => 'Str'
);

has 'unitIds' => (
	is => 'rw',
    isa => 'ArrayRef[Str]',
    traits => ['Array'],
    default => sub { [ ] },
    handles => {
        addUnitId => 'push'
    }
);

no Moose;
__PACKAGE__->meta->make_immutable;

1;
