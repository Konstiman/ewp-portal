package Entity::Institution;
 
use Moose;

has 'id' => (
	is => 'rw',
    isa => 'Int'
);

no Moose;
__PACKAGE__->meta->make_immutable;

1;
