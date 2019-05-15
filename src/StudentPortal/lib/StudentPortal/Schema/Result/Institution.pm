use utf8;
package StudentPortal::Schema::Result::Institution;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

StudentPortal::Schema::Result::Institution

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

=head1 TABLE: C<institution>

=cut

__PACKAGE__->table("institution");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 identifier

  data_type: 'varchar'
  is_nullable: 0
  size: 64

=head2 abbreviation

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 logo_url

  data_type: 'varchar'
  is_nullable: 1
  size: 1000

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
  "abbreviation",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "logo_url",
  { data_type => "varchar", is_nullable => 1, size => 1000 },
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

=head1 UNIQUE CONSTRAINTS

=head2 C<identifier>

=over 4

=item * L</identifier>

=back

=cut

__PACKAGE__->add_unique_constraint("identifier", ["identifier"]);

=head1 RELATIONS

=head2 institution_contacts

Type: has_many

Related object: L<StudentPortal::Schema::Result::InstitutionContact>

=cut

__PACKAGE__->has_many(
  "institution_contacts",
  "StudentPortal::Schema::Result::InstitutionContact",
  { "foreign.institution" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 institution_factsheets

Type: has_many

Related object: L<StudentPortal::Schema::Result::InstitutionFactsheet>

=cut

__PACKAGE__->has_many(
  "institution_factsheets",
  "StudentPortal::Schema::Result::InstitutionFactsheet",
  { "foreign.institution" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 institution_names

Type: has_many

Related object: L<StudentPortal::Schema::Result::InstitutionName>

=cut

__PACKAGE__->has_many(
  "institution_names",
  "StudentPortal::Schema::Result::InstitutionName",
  { "foreign.institution" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 institution_other_ids

Type: has_many

Related object: L<StudentPortal::Schema::Result::InstitutionOtherId>

=cut

__PACKAGE__->has_many(
  "institution_other_ids",
  "StudentPortal::Schema::Result::InstitutionOtherId",
  { "foreign.institution" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 institution_websites

Type: has_many

Related object: L<StudentPortal::Schema::Result::InstitutionWebsite>

=cut

__PACKAGE__->has_many(
  "institution_websites",
  "StudentPortal::Schema::Result::InstitutionWebsite",
  { "foreign.institution" => "self.id" },
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

=head2 units

Type: has_many

Related object: L<StudentPortal::Schema::Result::Unit>

=cut

__PACKAGE__->has_many(
  "units",
  "StudentPortal::Schema::Result::Unit",
  { "foreign.institution" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 contacts

Type: many_to_many

Composing rels: L</institution_contacts> -> contact

=cut

__PACKAGE__->many_to_many("contacts", "institution_contacts", "contact");


# Created by DBIx::Class::Schema::Loader v0.07048 @ 2019-05-15 10:23:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WxppURZmdZwc0R82/A248w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
