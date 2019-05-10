package Entity::Address;
 
use Moose;
use namespace::autoclean;

=head1 DESCRIPTION

Entita reprezentujici adresu v siti EWP.

=cut

=head1 ATTRIBUTES

=head2 C<id : Int>

Id adresy, pod kterym je ulozena v databazi.

=cut

has 'id' => (
	is => 'rw',
    isa => 'Int'
);

=head2 C<recipient : Str>

Textova identifikace adresata.

=cut

has 'recipient' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<lines : Str>

Textova reprezentace radku adresy.

=cut

has 'lines' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<buildingNumber : Str>

Cislo domu.

=cut

has 'buildingNumber' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<buildingName : Str>

Jmeno domu.

=cut

has 'buildingName' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<streetName : Str>

Nazev ulice.

=cut

has 'streetName' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<unit : Str>

Cislo jednotky (kancelare/bytu).

=cut

has 'unit' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<floor : Str>

Cislo podlazi.

=cut

has 'floor' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<pobox : Str>

Textova identifikace poboxu.

=cut

has 'pobox' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<deliveryPoint : Str>

Textova identifikace mista pro doruceni.

=cut

has 'deliveryPoint' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<postalCode : Str>

Postovni smerovaci cislo.

=cut

has 'postalCode' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<locality : Str>

Typicky mesto nebo obec.

=cut

has 'locality' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<region : Str>

Typicky kraj nebo jiny vyssi spravni celek.

=cut

has 'region' => (
    is => 'rw',
    isa => 'Str'
);

=head2 C<country : Str>

Kod zeme podle ISO 3166-1 alpha-2.

=cut

has 'country' => (
    is => 'rw',
    isa => 'Str'
);

no Moose;
__PACKAGE__->meta->make_immutable;

1;
