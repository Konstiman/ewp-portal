package Entity::LearningOpportunity;
 
use Moose;
use namespace::autoclean;
use Moose::Util::TypeConstraints;

=pod

=head1 DESCRIPTION

Entita reprezentujici studijni prilezitost v siti EWP.

=cut

=head1 ATTRIBUTES

=head2 C<id : Int>

Id studijni prilezitosti, pod kterym je ulozena v databazi.

=cut

has 'id' => (
	is => 'rw',
    isa => 'Int'
);

=head2 C<identifier : Str>

Identifikator studijni prilezitosti v ramci EWP.

=cut

has 'identifier' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<code : Str>

Lidsky citelny kod studijni prilezitosti v ramci EWP.

=cut

has 'code' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<unitIdentifier : Str>

Kod organizacni jednotky, pod kterou studijni prilezitost spada.

=cut

has 'unitIdentifier' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<subjectArea : Str>

Erasmus subject area kod kurzu.

=cut

has 'subjectArea' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<iscedCode : Str>



=cut

has 'iscedCode' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<eqfLevel : Str>



=cut

has 'eqfLevel' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<titles : Str>

Hash nazvu v ruznych jazycich.

    { 'en' => 'Programming in C++' }

=cut

has 'titles' => (
    is => 'rw',
    isa => 'HashRef[Str]',
    traits => ['Hash'],
    default => sub { {} },
    handles => {
        setTitle => 'set'
    }
);

=head2 C<websites : Str>

Hash webu v ruznych jazycich.

    { 'https://muni.cz/' => 'cz' }

=cut

has 'websites' => (
    is => 'rw',
    isa => 'HashRef[Str]',
    traits => ['Hash'],
    default => sub { {} },
    handles => {
        setWebsite => 'set'
    }
);

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

=head2 C<instances : ArrayRef[Entity::LearningOpportunityInstance]>

Instance studijni prilezitosti.

=cut

has 'instances' => (
	is => 'rw',
    isa => 'ArrayRef[Object]',
    traits => ['Array'],
    default => sub { [ ] },
    handles => {
        addInstance => 'push'
    }
);

enum OpportunityType => [ 'Degree Programme', qw( Module Course Class ) ];

=head2 C<type : OpportunityType>

Typ studijni prilezitosti.

=cut

has 'type' => (
	is => 'rw',
    isa => 'OpportunityType'
);

=head2 C<childIds : ArrayRef[Str]>

Pole identifikatoru podrizenych studijnich prilezitosti.

=cut

has 'childIds' => (
	is => 'rw',
    isa => 'ArrayRef[Str]',
    traits => ['Array'],
    default => sub { [ ] },
    handles => {
        addChildId => 'push'
    }
);


no Moose;
__PACKAGE__->meta->make_immutable;

1;
