use utf8;
package StudentPortal::Schema::Result::Credit;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

StudentPortal::Schema::Result::Credit

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

=head1 TABLE: C<credit>

=cut

__PACKAGE__->table("credit");

=head1 ACCESSORS

=head2 opportunity_instance

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 scheme

  data_type: 'varchar'
  is_nullable: 0
  size: 1000

=head2 level

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 value

  data_type: 'decimal'
  is_nullable: 0
  size: [10,2]

=cut

__PACKAGE__->add_columns(
  "opportunity_instance",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "scheme",
  { data_type => "varchar", is_nullable => 0, size => 1000 },
  "level",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "value",
  { data_type => "decimal", is_nullable => 0, size => [10, 2] },
);

=head1 RELATIONS

=head2 opportunity_instance

Type: belongs_to

Related object: L<StudentPortal::Schema::Result::OpportunityInstance>

=cut

__PACKAGE__->belongs_to(
  "opportunity_instance",
  "StudentPortal::Schema::Result::OpportunityInstance",
  { id => "opportunity_instance" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07048 @ 2019-05-15 10:23:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QDK4VxANluyv9Fyye4WqmQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
