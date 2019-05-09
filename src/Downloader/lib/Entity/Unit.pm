package Entity::Unit;
 
use Moose;
use namespace::autoclean;

=head1 DESCRIPTION

Entita reprezentujici organizacni jednotku instituce v siti EWP.

=cut

has 'id' => (
	is => 'rw',
    isa => 'Int'
);

has 'identifier' => (
	is => 'rw',
    isa => 'Str'
);

has 'institution' => (
	is => 'rw',
    isa => 'Object'
);

has 'root' => (
    is => 'rw',
    isa => 'Bool'
);

has 'names' => (
	is => 'rw',
    isa => 'HashRef[Str]',
    traits => ['Hash'],
    default => sub { { } },
    handles => {
        setName => 'set'
    }
);

has 'code' => (
	is => 'rw',
    isa => 'Str'
);

has 'abbreviation' => (
	is => 'rw',
    isa => 'Str'
);

has 'logoUrl' => (
	is => 'rw',
    isa => 'Str'
);

has 'websites' => (
	is => 'rw',
    isa => 'HashRef[Str]',
    traits => ['Hash'],
    default => sub { { } },
    handles => {
        setWebsite => 'set'
    }
);

has 'factsheets' => (
	is => 'rw',
    isa => 'HashRef[Str]',
    traits => ['Hash'],
    default => sub { { } },
    handles => {
        setFactsheet => 'set'
    }
);

has 'mailingAddress' => (
	is => 'rw',
    isa => 'Object'
);

has 'locationAddress' => (
	is => 'rw',
    isa => 'Object'
);

has 'parentIdentifier' => (
    is => 'rw',
    isa => 'Str'
);

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
