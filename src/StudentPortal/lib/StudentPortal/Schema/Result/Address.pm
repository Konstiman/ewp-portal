use utf8;
package StudentPortal::Schema::Result::Address;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

StudentPortal::Schema::Result::Address

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<address>

=cut

__PACKAGE__->table("address");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 recipient

  data_type: 'varchar'
  is_nullable: 1
  size: 1000

=head2 addresslines

  data_type: 'varchar'
  is_nullable: 1
  size: 1000

=head2 buildingnumber

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 buildingname

  data_type: 'varchar'
  is_nullable: 1
  size: 1000

=head2 streetname

  data_type: 'varchar'
  is_nullable: 1
  size: 1000

=head2 unit

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 floor

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 pobox

  data_type: 'varchar'
  is_nullable: 1
  size: 1000

=head2 deliverypoint

  data_type: 'varchar'
  is_nullable: 1
  size: 1000

=head2 postalcode

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 locality

  data_type: 'varchar'
  is_nullable: 1
  size: 1000

=head2 region

  data_type: 'varchar'
  is_nullable: 1
  size: 1000

=head2 country

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "recipient",
  { data_type => "varchar", is_nullable => 1, size => 1000 },
  "addresslines",
  { data_type => "varchar", is_nullable => 1, size => 1000 },
  "buildingnumber",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "buildingname",
  { data_type => "varchar", is_nullable => 1, size => 1000 },
  "streetname",
  { data_type => "varchar", is_nullable => 1, size => 1000 },
  "unit",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "floor",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "pobox",
  { data_type => "varchar", is_nullable => 1, size => 1000 },
  "deliverypoint",
  { data_type => "varchar", is_nullable => 1, size => 1000 },
  "postalcode",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "locality",
  { data_type => "varchar", is_nullable => 1, size => 1000 },
  "region",
  { data_type => "varchar", is_nullable => 1, size => 1000 },
  "country",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 contact_location_addresses

Type: has_many

Related object: L<StudentPortal::Schema::Result::Contact>

=cut

__PACKAGE__->has_many(
  "contact_location_addresses",
  "StudentPortal::Schema::Result::Contact",
  { "foreign.location_address" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 contact_mailing_addresses

Type: has_many

Related object: L<StudentPortal::Schema::Result::Contact>

=cut

__PACKAGE__->has_many(
  "contact_mailing_addresses",
  "StudentPortal::Schema::Result::Contact",
  { "foreign.mailing_address" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 country

Type: belongs_to

Related object: L<StudentPortal::Schema::Result::Country>

=cut

__PACKAGE__->belongs_to(
  "country",
  "StudentPortal::Schema::Result::Country",
  { id => "country" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 institution_location_addresses

Type: has_many

Related object: L<StudentPortal::Schema::Result::Institution>

=cut

__PACKAGE__->has_many(
  "institution_location_addresses",
  "StudentPortal::Schema::Result::Institution",
  { "foreign.location_address" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 institution_mailing_addresses

Type: has_many

Related object: L<StudentPortal::Schema::Result::Institution>

=cut

__PACKAGE__->has_many(
  "institution_mailing_addresses",
  "StudentPortal::Schema::Result::Institution",
  { "foreign.mailing_address" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 unit_location_addresses

Type: has_many

Related object: L<StudentPortal::Schema::Result::Unit>

=cut

__PACKAGE__->has_many(
  "unit_location_addresses",
  "StudentPortal::Schema::Result::Unit",
  { "foreign.location_address" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 unit_mailing_addresses

Type: has_many

Related object: L<StudentPortal::Schema::Result::Unit>

=cut

__PACKAGE__->has_many(
  "unit_mailing_addresses",
  "StudentPortal::Schema::Result::Unit",
  { "foreign.mailing_address" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07048 @ 2019-05-15 10:23:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:UsjQUD+fgjA3czpxb8qSlA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
