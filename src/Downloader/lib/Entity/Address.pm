package Entity::Address;
 
use Moose;

has 'id' => (
	is => 'rw',
    isa => 'Int'
);

has 'recipient' => (
    is => 'rw',
    isa => 'Str'
);

has 'lines' => (
    is => 'rw',
    isa => 'Str'
);

has 'buildingNumber' => (
    is => 'rw',
    isa => 'Str'
);

has 'buildingName' => (
    is => 'rw',
    isa => 'Str'
);

has 'streetName' => (
    is => 'rw',
    isa => 'Str'
);

has 'unit' => (
    is => 'rw',
    isa => 'Str'
);

has 'floor' => (
    is => 'rw',
    isa => 'Str'
);

has 'pobox' => (
    is => 'rw',
    isa => 'Str'
);

has 'deliveryPoint' => (
    is => 'rw',
    isa => 'Str'
);

has 'postalCode' => (
    is => 'rw',
    isa => 'Str'
);

has 'locality' => (
    is => 'rw',
    isa => 'Str'
);

has 'region' => (
    is => 'rw',
    isa => 'Str'
);

has 'country' => (
    is => 'rw',
    isa => 'Str'
);

no Moose;
__PACKAGE__->meta->make_immutable;

1;
