use utf8;
package StudentPortal::Schema::Result::OpportunityInstance;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

StudentPortal::Schema::Result::OpportunityInstance

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

=head1 TABLE: C<opportunity_instance>

=cut

__PACKAGE__->table("opportunity_instance");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 identifier

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 learning_opportunity

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 start

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 end

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 academic_term

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 language

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 engagement_hours

  data_type: 'decimal'
  is_nullable: 1
  size: [10,2]

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "identifier",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "learning_opportunity",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "start",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 0 },
  "end",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 0 },
  "academic_term",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "language",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "engagement_hours",
  { data_type => "decimal", is_nullable => 1, size => [10, 2] },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 academic_term

Type: belongs_to

Related object: L<StudentPortal::Schema::Result::AcademicTerm>

=cut

__PACKAGE__->belongs_to(
  "academic_term",
  "StudentPortal::Schema::Result::AcademicTerm",
  { id => "academic_term" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 credits

Type: has_many

Related object: L<StudentPortal::Schema::Result::Credit>

=cut

__PACKAGE__->has_many(
  "credits",
  "StudentPortal::Schema::Result::Credit",
  { "foreign.opportunity_instance" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 grading_schemes

Type: has_many

Related object: L<StudentPortal::Schema::Result::GradingScheme>

=cut

__PACKAGE__->has_many(
  "grading_schemes",
  "StudentPortal::Schema::Result::GradingScheme",
  { "foreign.opportunity_instance" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 language

Type: belongs_to

Related object: L<StudentPortal::Schema::Result::Language>

=cut

__PACKAGE__->belongs_to(
  "language",
  "StudentPortal::Schema::Result::Language",
  { id => "language" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 learning_opportunity

Type: belongs_to

Related object: L<StudentPortal::Schema::Result::LearningOpportunity>

=cut

__PACKAGE__->belongs_to(
  "learning_opportunity",
  "StudentPortal::Schema::Result::LearningOpportunity",
  { id => "learning_opportunity" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 result_distribution_categories

Type: has_many

Related object: L<StudentPortal::Schema::Result::ResultDistributionCategory>

=cut

__PACKAGE__->has_many(
  "result_distribution_categories",
  "StudentPortal::Schema::Result::ResultDistributionCategory",
  { "foreign.opportunity_instance" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 result_distribution_descriptions

Type: has_many

Related object: L<StudentPortal::Schema::Result::ResultDistributionDescription>

=cut

__PACKAGE__->has_many(
  "result_distribution_descriptions",
  "StudentPortal::Schema::Result::ResultDistributionDescription",
  { "foreign.opportunity_instance" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07048 @ 2019-05-15 10:23:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Cw/t8b4C7JWZDcvtOmP84A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
