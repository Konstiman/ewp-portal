package Entity::Contact;
 
use Moose;
use namespace::autoclean;

=pod

=head1 DESCRIPTION

Entita reprezentujici kontakt v siti EWP.

=cut

=head1 ATTRIBUTES

=head2 C<id : Int>

Id kontaktu, pod kterym je ulozen v databazi.

=cut

has 'id' => (
	is => 'rw',
    isa => 'Int'
);

=head2 C<names : HashRef[Str]>

Hash pojmenovani kontaktu v ruznych jazycich.

    { 'en' => 'Jan Novak' }

=cut

has 'names' => (
    is => 'rw',
    isa => 'HashRef[Str]',
    traits => ['Hash'],
    default => sub { {} },
    handles => {
        setName => 'set'
    }
);

# TODO given names and family names

=head2 C<gender : Int>

ISO/IEC 5218 kod pohlavi.

=cut

has 'gender' => (
    is => 'rw',
    isa => 'Int'
);

=head2 C<mailingAddress : Entity::Address>

Dorucovaci adresa kontaktu.

=cut

has 'mailingAddress' => (
	is => 'rw',
    isa => 'Object'
);

=head2 C<locationAddress : Entity::Address>

Mistni adresa kontaktu.

=cut

has 'locationAddress' => (
	is => 'rw',
    isa => 'Object'
);

=head2 C<emails : ArrayRef[Str]>

Pole emailu.

=cut

has 'emails' => (
    is => 'rw',
    isa => 'ArrayRef[Str]',
    traits => ['Array'],
    default => sub { [ ] },
    handles => {
        addEmail => 'push'
    }
);

=head2 C<phones : ArrayRef[Str]>

Pole telefonnich cisel.

=cut

has 'phones' => (
    is => 'rw',
    isa => 'ArrayRef[Str]',
    traits => ['Array'],
    default => sub { [ ] },
    handles => {
        addPhone => 'push'
    }
);

=head2 C<faxes : ArrayRef[Str]>

Pole faxovych cisel.

=cut

has 'faxes' => (
    is => 'rw',
    isa => 'ArrayRef[Str]',
    traits => ['Array'],
    default => sub { [ ] },
    handles => {
        addFax => 'push'
    }
);

=head2 C<description : HashRef[Str]>

Hash popisu role kontaktu v ruznych jazycich.

    { 'en' => 'system administrator' }

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

no Moose;
__PACKAGE__->meta->make_immutable;

1;
