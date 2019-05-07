package Manager::EntityManager;
 
use Moose;

use Entity::Manager;

has 'dbi' => (
    is  => 'ro',
    isa => 'Object'
);

# TODO

no Moose;
__PACKAGE__->meta->make_immutable;

1;
