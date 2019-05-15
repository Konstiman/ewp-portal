use utf8;
package StudentPortal::Schema::Result::Unit;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

StudentPortal::Schema::Result::Unit

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

=head1 TABLE: C<unit>

=cut

__PACKAGE__->table("unit");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 identifier

  data_type: 'varchar'
  is_nullable: 0
  size: 64

=head2 institution

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 root

  data_type: 'integer'
  is_nullable: 1

=head2 code

  data_type: 'varchar'
  is_nullable: 1
  size: 1000

=head2 abbreviation

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 logo_url

  data_type: 'varchar'
  is_nullable: 1
  size: 1000

=head2 parent

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 location_address

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 mailing_address

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "identifier",
  { data_type => "varchar", is_nullable => 0, size => 64 },
  "institution",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "root",
  { data_type => "integer", is_nullable => 1 },
  "code",
  { data_type => "varchar", is_nullable => 1, size => 1000 },
  "abbreviation",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "logo_url",
  { data_type => "varchar", is_nullable => 1, size => 1000 },
  "parent",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "location_address",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "mailing_address",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 institution

Type: belongs_to

Related object: L<StudentPortal::Schema::Result::Institution>

=cut

__PACKAGE__->belongs_to(
  "institution",
  "StudentPortal::Schema::Result::Institution",
  { id => "institution" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 learning_opportunities

Type: has_many

Related object: L<StudentPortal::Schema::Result::LearningOpportunity>

=cut

__PACKAGE__->has_many(
  "learning_opportunities",
  "StudentPortal::Schema::Result::LearningOpportunity",
  { "foreign.unit" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 location_address

Type: belongs_to

Related object: L<StudentPortal::Schema::Result::Address>

=cut

__PACKAGE__->belongs_to(
  "location_address",
  "StudentPortal::Schema::Result::Address",
  { id => "location_address" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 mailing_address

Type: belongs_to

Related object: L<StudentPortal::Schema::Result::Address>

=cut

__PACKAGE__->belongs_to(
  "mailing_address",
  "StudentPortal::Schema::Result::Address",
  { id => "mailing_address" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 parent

Type: belongs_to

Related object: L<StudentPortal::Schema::Result::Unit>

=cut

__PACKAGE__->belongs_to(
  "parent",
  "StudentPortal::Schema::Result::Unit",
  { id => "parent" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 unit_contacts

Type: has_many

Related object: L<StudentPortal::Schema::Result::UnitContact>

=cut

__PACKAGE__->has_many(
  "unit_contacts",
  "StudentPortal::Schema::Result::UnitContact",
  { "foreign.unit" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 unit_factsheets

Type: has_many

Related object: L<StudentPortal::Schema::Result::UnitFactsheet>

=cut

__PACKAGE__->has_many(
  "unit_factsheets",
  "StudentPortal::Schema::Result::UnitFactsheet",
  { "foreign.unit" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 unit_names

Type: has_many

Related object: L<StudentPortal::Schema::Result::UnitName>

=cut

__PACKAGE__->has_many(
  "unit_names",
  "StudentPortal::Schema::Result::UnitName",
  { "foreign.unit" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 unit_websites

Type: has_many

Related object: L<StudentPortal::Schema::Result::UnitWebsite>

=cut

__PACKAGE__->has_many(
  "unit_websites",
  "StudentPortal::Schema::Result::UnitWebsite",
  { "foreign.unit" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 units

Type: has_many

Related object: L<StudentPortal::Schema::Result::Unit>

=cut

__PACKAGE__->has_many(
  "units",
  "StudentPortal::Schema::Result::Unit",
  { "foreign.parent" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 contacts

Type: many_to_many

Composing rels: L</unit_contacts> -> contact

=cut

__PACKAGE__->many_to_many("contacts", "unit_contacts", "contact");


# Created by DBIx::Class::Schema::Loader v0.07048 @ 2019-05-15 10:23:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:lLZo7E830980h/RF/TW7sA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
