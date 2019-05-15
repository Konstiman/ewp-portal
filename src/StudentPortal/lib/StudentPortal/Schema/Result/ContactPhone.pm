use utf8;
package StudentPortal::Schema::Result::ContactPhone;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

StudentPortal::Schema::Result::ContactPhone

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

=head1 TABLE: C<contact_phone>

=cut

__PACKAGE__->table("contact_phone");

=head1 ACCESSORS

=head2 contact

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 phonenumber

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=cut

__PACKAGE__->add_columns(
  "contact",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "phonenumber",
  { data_type => "varchar", is_nullable => 1, size => 100 },
);

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


# Created by DBIx::Class::Schema::Loader v0.07048 @ 2019-05-15 10:23:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:69LfOS993jJVrEwRlUuc6Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
