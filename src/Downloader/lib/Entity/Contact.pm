package Entity::Address;
 
use Moose;

has 'id' => (
	is => 'rw',
    isa => 'Int'
);

has 'names' => (
    is => 'rw',
    isa => 'ArrayRef[Str]',
    traits => ['Array'],
    default => sub { [ ] },
    handles => {
        addName => 'push'
    }
);

# TODO given names and family names

has => 'gender' => (
    is => 'rw',
    isa => 'Int'
);

has 'mailingAddress' => (
	is => 'rw',
    isa => 'Object'
);

has 'locationAddress' => (
	is => 'rw',
    isa => 'Object'
);

has 'emails' => (
    is => 'rw',
    isa => 'ArrayRef[Str]',
    traits => ['Array'],
    default => sub { [ ] },
    handles => {
        addEmail => 'push'
    }
);

has 'phones' => (
    is => 'rw',
    isa => 'ArrayRef[Str]',
    traits => ['Array'],
    default => sub { [ ] },
    handles => {
        addPhone => 'push'
    }
);

has 'faxes' => (
    is => 'rw',
    isa => 'ArrayRef[Str]',
    traits => ['Array'],
    default => sub { [ ] },
    handles => {
        addFax => 'push'
    }
);

has 'description' => (
    is => 'rw',
    isa => 'HashRef[Str]',
    traits => ['Hash'],
    default => sub { {} },
    handles => {
        setDescription => 'set'
    }
);

no Moose;
__PACKAGE__->meta->make_immutable;

1;
