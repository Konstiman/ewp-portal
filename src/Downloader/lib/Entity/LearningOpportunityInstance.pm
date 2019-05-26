package Entity::LearningOpportunityInstance;
 
use Moose;
use namespace::autoclean;
use Moose::Util::TypeConstraints;

=pod

=head1 DESCRIPTION

Entita reprezentujici instanci studijni prilezitosti v siti EWP.

=cut

=head1 ATTRIBUTES

=head2 C<id : Int>

Id instance studijni prilezitosti, pod kterym je ulozena v databazi.

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

=head2 C<start : Str>

Zacatek instance.

=cut

has 'start' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<end : Str>

Konec instance.

=cut

has 'end' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<engHours : Num>

Odhad hodinove narocnosti.

=cut

has 'engHours' => (
    is => 'rw',
    isa => 'Num'
);

=head2 C<language : Str>

Jazyk instance.

=cut

has 'language' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<academicTerm : Entity::AcademicTerm>

Objekt akademickeho obdobi.

=cut

has 'academicTerm' => (
    is => 'rw',
    isa => 'Object'
);

=head2 C<resultDistribution : Entity::ResultDistribution>

Objekt s vysledky studijni prilezitosti.

=cut

has 'resultDistribution' => (
	is => 'rw',
    isa => 'Object'
);

=head2 C<credits : ArrayRef[HashRef[Str]]>

Informace o ziskatelnych kreditech.

=cut

has 'credits' => (
	is => 'rw',
    isa => 'ArrayRef[HashRef[Str]]',
    traits => ['Array'],
    default => sub { [ ] },
    handles => {
        addCredit => 'push'
    }
);

no Moose;
__PACKAGE__->meta->make_immutable;

1;
