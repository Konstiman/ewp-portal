package Entity::LearningOpportunity;
 
use Moose;
use namespace::autoclean;

=pod

=head1 DESCRIPTION

Entita reprezentujici studijni prilezitost v siti EWP.

=cut

=head1 ATTRIBUTES

=head2 C<id : Int>

Id kontaktu, pod kterym je ulozen v databazi.

=cut

has 'id' => (
	is => 'rw',
    isa => 'Int'
);

# TODO

no Moose;
__PACKAGE__->meta->make_immutable;

1;
