use utf8;
package StudentPortal::Schema::Result::Language;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

StudentPortal::Schema::Result::Language

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

=head1 TABLE: C<language>

=cut

__PACKAGE__->table("language");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 abbreviation

  data_type: 'varchar'
  is_nullable: 0
  size: 10

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 flag_url

  data_type: 'varchar'
  is_nullable: 1
  size: 1000

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "abbreviation",
  { data_type => "varchar", is_nullable => 0, size => 10 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "flag_url",
  { data_type => "varchar", is_nullable => 1, size => 1000 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<abbreviation>

=over 4

=item * L</abbreviation>

=back

=cut

__PACKAGE__->add_unique_constraint("abbreviation", ["abbreviation"]);

=head1 RELATIONS

=head2 academic_term_names

Type: has_many

Related object: L<StudentPortal::Schema::Result::AcademicTermName>

=cut

__PACKAGE__->has_many(
  "academic_term_names",
  "StudentPortal::Schema::Result::AcademicTermName",
  { "foreign.language" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 contact_descriptions

Type: has_many

Related object: L<StudentPortal::Schema::Result::ContactDescription>

=cut

__PACKAGE__->has_many(
  "contact_descriptions",
  "StudentPortal::Schema::Result::ContactDescription",
  { "foreign.language" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 contact_names

Type: has_many

Related object: L<StudentPortal::Schema::Result::ContactName>

=cut

__PACKAGE__->has_many(
  "contact_names",
  "StudentPortal::Schema::Result::ContactName",
  { "foreign.language" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 grading_schemes

Type: has_many

Related object: L<StudentPortal::Schema::Result::GradingScheme>

=cut

__PACKAGE__->has_many(
  "grading_schemes",
  "StudentPortal::Schema::Result::GradingScheme",
  { "foreign.language" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 institution_factsheets

Type: has_many

Related object: L<StudentPortal::Schema::Result::InstitutionFactsheet>

=cut

__PACKAGE__->has_many(
  "institution_factsheets",
  "StudentPortal::Schema::Result::InstitutionFactsheet",
  { "foreign.language" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 institution_names

Type: has_many

Related object: L<StudentPortal::Schema::Result::InstitutionName>

=cut

__PACKAGE__->has_many(
  "institution_names",
  "StudentPortal::Schema::Result::InstitutionName",
  { "foreign.language" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 institution_websites

Type: has_many

Related object: L<StudentPortal::Schema::Result::InstitutionWebsite>

=cut

__PACKAGE__->has_many(
  "institution_websites",
  "StudentPortal::Schema::Result::InstitutionWebsite",
  { "foreign.language" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 opportunity_descriptions

Type: has_many

Related object: L<StudentPortal::Schema::Result::OpportunityDescription>

=cut

__PACKAGE__->has_many(
  "opportunity_descriptions",
  "StudentPortal::Schema::Result::OpportunityDescription",
  { "foreign.language" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 opportunity_instances

Type: has_many

Related object: L<StudentPortal::Schema::Result::OpportunityInstance>

=cut

__PACKAGE__->has_many(
  "opportunity_instances",
  "StudentPortal::Schema::Result::OpportunityInstance",
  { "foreign.language" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 opportunity_titles

Type: has_many

Related object: L<StudentPortal::Schema::Result::OpportunityTitle>

=cut

__PACKAGE__->has_many(
  "opportunity_titles",
  "StudentPortal::Schema::Result::OpportunityTitle",
  { "foreign.language" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 opportunity_websites

Type: has_many

Related object: L<StudentPortal::Schema::Result::OpportunityWebsite>

=cut

__PACKAGE__->has_many(
  "opportunity_websites",
  "StudentPortal::Schema::Result::OpportunityWebsite",
  { "foreign.language" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 result_distribution_descriptions

Type: has_many

Related object: L<StudentPortal::Schema::Result::ResultDistributionDescription>

=cut

__PACKAGE__->has_many(
  "result_distribution_descriptions",
  "StudentPortal::Schema::Result::ResultDistributionDescription",
  { "foreign.language" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 unit_factsheets

Type: has_many

Related object: L<StudentPortal::Schema::Result::UnitFactsheet>

=cut

__PACKAGE__->has_many(
  "unit_factsheets",
  "StudentPortal::Schema::Result::UnitFactsheet",
  { "foreign.language" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 unit_names

Type: has_many

Related object: L<StudentPortal::Schema::Result::UnitName>

=cut

__PACKAGE__->has_many(
  "unit_names",
  "StudentPortal::Schema::Result::UnitName",
  { "foreign.language" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 unit_websites

Type: has_many

Related object: L<StudentPortal::Schema::Result::UnitWebsite>

=cut

__PACKAGE__->has_many(
  "unit_websites",
  "StudentPortal::Schema::Result::UnitWebsite",
  { "foreign.language" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07048 @ 2019-05-15 10:23:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zCLGJklSroh4uAJgazUcSA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
