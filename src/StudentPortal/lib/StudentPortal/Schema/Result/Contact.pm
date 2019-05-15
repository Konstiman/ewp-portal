use utf8;
package StudentPortal::Schema::Result::Contact;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

StudentPortal::Schema::Result::Contact

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

=head1 TABLE: C<contact>

=cut

__PACKAGE__->table("contact");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 gender

  data_type: 'integer'
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
  "gender",
  { data_type => "integer", is_nullable => 1 },
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

=head2 contact_descriptions

Type: has_many

Related object: L<StudentPortal::Schema::Result::ContactDescription>

=cut

__PACKAGE__->has_many(
  "contact_descriptions",
  "StudentPortal::Schema::Result::ContactDescription",
  { "foreign.contact" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 contact_emails

Type: has_many

Related object: L<StudentPortal::Schema::Result::ContactEmail>

=cut

__PACKAGE__->has_many(
  "contact_emails",
  "StudentPortal::Schema::Result::ContactEmail",
  { "foreign.contact" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 contact_faxes

Type: has_many

Related object: L<StudentPortal::Schema::Result::ContactFax>

=cut

__PACKAGE__->has_many(
  "contact_faxes",
  "StudentPortal::Schema::Result::ContactFax",
  { "foreign.contact" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 contact_names

Type: has_many

Related object: L<StudentPortal::Schema::Result::ContactName>

=cut

__PACKAGE__->has_many(
  "contact_names",
  "StudentPortal::Schema::Result::ContactName",
  { "foreign.contact" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 contact_phones

Type: has_many

Related object: L<StudentPortal::Schema::Result::ContactPhone>

=cut

__PACKAGE__->has_many(
  "contact_phones",
  "StudentPortal::Schema::Result::ContactPhone",
  { "foreign.contact" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 institution_contacts

Type: has_many

Related object: L<StudentPortal::Schema::Result::InstitutionContact>

=cut

__PACKAGE__->has_many(
  "institution_contacts",
  "StudentPortal::Schema::Result::InstitutionContact",
  { "foreign.contact" => "self.id" },
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

=head2 unit_contacts

Type: has_many

Related object: L<StudentPortal::Schema::Result::UnitContact>

=cut

__PACKAGE__->has_many(
  "unit_contacts",
  "StudentPortal::Schema::Result::UnitContact",
  { "foreign.contact" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 institutions

Type: many_to_many

Composing rels: L</institution_contacts> -> institution

=cut

__PACKAGE__->many_to_many("institutions", "institution_contacts", "institution");

=head2 units

Type: many_to_many

Composing rels: L</unit_contacts> -> unit

=cut

__PACKAGE__->many_to_many("units", "unit_contacts", "unit");


# Created by DBIx::Class::Schema::Loader v0.07048 @ 2019-05-15 10:23:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:eMHARWQMmrmuBcjEBwgjEA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
