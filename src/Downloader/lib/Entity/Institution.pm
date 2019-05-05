package Entity::Institution;
 
use Moose;

has 'id' => (
	is => 'rw',
    isa => 'Int'
);

has 'identifier' => (
	is => 'rw',
    isa => 'Str'
);

has 'otherIdentifiers' => (
	is => 'rw',
    isa => 'HashRef[Str]',
    traits => ['Hash'],
    default => sub { { } },
    handles => {
        setOtherIdentifier => 'set'
    }
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
    # TODO objekt
    isa => 'Str'
);

has 'locationAddress' => (
	is => 'rw',
    # TODO objekt
    isa => 'Str'
);

has 'contacts' => (
	is => 'rw',
    # TODO pole objektu
    isa => 'ArrayRef[Str]',
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
