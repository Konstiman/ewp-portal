use utf8;
package StudentPortal::Schema::Result::LearningOpportunity;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

StudentPortal::Schema::Result::LearningOpportunity

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

=head1 TABLE: C<learning_opportunity>

=cut

__PACKAGE__->table("learning_opportunity");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 unit

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 identifier

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 code

  data_type: 'varchar'
  is_nullable: 1
  size: 1000

=head2 type

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 subject_area

  data_type: 'varchar'
  is_nullable: 1
  size: 1000

=head2 isced_code

  data_type: 'varchar'
  is_nullable: 1
  size: 1000

=head2 eqf_level

  data_type: 'integer'
  is_nullable: 1

=head2 parent

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "unit",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "identifier",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "code",
  { data_type => "varchar", is_nullable => 1, size => 1000 },
  "type",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "subject_area",
  { data_type => "varchar", is_nullable => 1, size => 1000 },
  "isced_code",
  { data_type => "varchar", is_nullable => 1, size => 1000 },
  "eqf_level",
  { data_type => "integer", is_nullable => 1 },
  "parent",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 learning_opportunities

Type: has_many

Related object: L<StudentPortal::Schema::Result::LearningOpportunity>

=cut

__PACKAGE__->has_many(
  "learning_opportunities",
  "StudentPortal::Schema::Result::LearningOpportunity",
  { "foreign.parent" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 opportunity_descriptions

Type: has_many

Related object: L<StudentPortal::Schema::Result::OpportunityDescription>

=cut

__PACKAGE__->has_many(
  "opportunity_descriptions",
  "StudentPortal::Schema::Result::OpportunityDescription",
  { "foreign.learning_opportunity" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 opportunity_instances

Type: has_many

Related object: L<StudentPortal::Schema::Result::OpportunityInstance>

=cut

__PACKAGE__->has_many(
  "opportunity_instances",
  "StudentPortal::Schema::Result::OpportunityInstance",
  { "foreign.learning_opportunity" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 opportunity_titles

Type: has_many

Related object: L<StudentPortal::Schema::Result::OpportunityTitle>

=cut

__PACKAGE__->has_many(
  "opportunity_titles",
  "StudentPortal::Schema::Result::OpportunityTitle",
  { "foreign.learning_opportunity" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 opportunity_websites

Type: has_many

Related object: L<StudentPortal::Schema::Result::OpportunityWebsite>

=cut

__PACKAGE__->has_many(
  "opportunity_websites",
  "StudentPortal::Schema::Result::OpportunityWebsite",
  { "foreign.learning_opportunity" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 parent

Type: belongs_to

Related object: L<StudentPortal::Schema::Result::LearningOpportunity>

=cut

__PACKAGE__->belongs_to(
  "parent",
  "StudentPortal::Schema::Result::LearningOpportunity",
  { id => "parent" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 type

Type: belongs_to

Related object: L<StudentPortal::Schema::Result::OpportunityType>

=cut

__PACKAGE__->belongs_to(
  "type",
  "StudentPortal::Schema::Result::OpportunityType",
  { id => "type" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 unit

Type: belongs_to

Related object: L<StudentPortal::Schema::Result::Unit>

=cut

__PACKAGE__->belongs_to(
  "unit",
  "StudentPortal::Schema::Result::Unit",
  { id => "unit" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07048 @ 2019-05-15 10:23:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:a3Hyo0475f8DQsMrMMo6EA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
