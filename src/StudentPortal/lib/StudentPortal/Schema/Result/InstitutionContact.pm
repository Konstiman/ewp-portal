use utf8;
package StudentPortal::Schema::Result::InstitutionContact;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

StudentPortal::Schema::Result::InstitutionContact

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

=head1 TABLE: C<institution_contact>

=cut

__PACKAGE__->table("institution_contact");

=head1 ACCESSORS

=head2 institution

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 contact

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "institution",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "contact",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</institution>

=item * L</contact>

=back

=cut

__PACKAGE__->set_primary_key("institution", "contact");

=head1 RELATIONS

=head2 contact

Type: belongs_to

Related object: L<StudentPortal::Schema::Result::Contact>

=cut

__PACKAGE__->belongs_to(
  "contact",
  "StudentPortal::Schema::Result::Contact",
  { id => "contact" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

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


# Created by DBIx::Class::Schema::Loader v0.07048 @ 2019-05-15 10:23:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2SqV/WvocfZxx27nyXYpFQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
