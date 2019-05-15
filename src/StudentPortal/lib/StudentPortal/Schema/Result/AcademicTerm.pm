use utf8;
package StudentPortal::Schema::Result::AcademicTerm;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

StudentPortal::Schema::Result::AcademicTerm

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

=head1 TABLE: C<academic_term>

=cut

__PACKAGE__->table("academic_term");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 yearidentifier

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 termidentifier

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 1000

=head2 start

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 end

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "yearidentifier",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "termidentifier",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 1000 },
  "start",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 0 },
  "end",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 academic_term_names

Type: has_many

Related object: L<StudentPortal::Schema::Result::AcademicTermName>

=cut

__PACKAGE__->has_many(
  "academic_term_names",
  "StudentPortal::Schema::Result::AcademicTermName",
  { "foreign.academic_term" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 opportunity_instances

Type: has_many

Related object: L<StudentPortal::Schema::Result::OpportunityInstance>

=cut

__PACKAGE__->has_many(
  "opportunity_instances",
  "StudentPortal::Schema::Result::OpportunityInstance",
  { "foreign.academic_term" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07048 @ 2019-05-15 10:23:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FYXLdkYBxGfKj0evJBTjOg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
