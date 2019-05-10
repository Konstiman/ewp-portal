package Entity::Unit;
 
use Moose;
use namespace::autoclean;

=head1 DESCRIPTION

Entita reprezentujici organizacni jednotku instituce v siti EWP.

=cut

=head1 ATTRIBUTES

=head2 C<id : Int>

Id organizacni jednotky, pod kterym je ulozena v databazi.

=cut

has 'id' => (
	is => 'rw',
    isa => 'Int'
);

=head2 C<identifier : Str>

Identifikator organizacni jednotky, pod kterym je jednotka identifikovatelna
v ramci sve instituce.

=cut

has 'identifier' => (
	is => 'rw',
    isa => 'Str'
);

=head2 C<institution : Entity::Institution>

Objekt instituce, pod kterou jednotka spada.

=cut

has 'institution' => (
	is => 'rw',
    isa => 'Object'
);

=head2 C<root : Bool>

True, pokud je jednotka korenovou jednotkou v hierarchickem systemu.

=cut

has 'root' => (
    is => 'rw',
    isa => 'Bool'
);

=head2 C<names : HashRef[Str]>

Hash jmen jednotky v ruznych jazycich.

    { 'en' => 'Faculty of Informatics' }

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

=head2 C<code : Str>

Lidsky citelny kod jednotky, ktery ji jednoznacne urcuje v ramci sve instituce.

=cut

has 'code' => (
	is => 'rw',
    isa => 'Str'
);

=head2 C<abbreviation : Str>

Zkratka nazvu jednotky.

=cut

has 'abbreviation' => (
	is => 'rw',
    isa => 'Str'
);

=head2 C<logoUrl : Str>

Odkaz na logo jednotky.

=cut

has 'logoUrl' => (
	is => 'rw',
    isa => 'Str'
);

=head2 C<websites : HashRef[Str]>

Hash webu jednotky v ruznych jazycich.

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

Hash url factsheetu jednotky v ruznych jazycich.

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

Dorucovaci adresa jednotky.

=cut

has 'mailingAddress' => (
	is => 'rw',
    isa => 'Object'
);

=head2 C<locationAddress : Entity::Address>

Mistni adresa jednotky.

=cut

has 'locationAddress' => (
	is => 'rw',
    isa => 'Object'
);

=head2 C<parentIdentifier : Str>

Identifikator nadrazene jednotky.

=cut

has 'parentIdentifier' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<contacts : ArrayRef[Entity::Contact]>

Seznam kontaktu jednotky.

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

no Moose;
__PACKAGE__->meta->make_immutable;

1;
