use utf8;
package StudentPortal::Schema::Result::OpportunityType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

StudentPortal::Schema::Result::OpportunityType

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

=head1 TABLE: C<opportunity_type>

=cut

__PACKAGE__->table("opportunity_type");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name_en

  data_type: 'varchar'
  is_nullable: 0
  size: 500

=head2 name_cz

  data_type: 'varchar'
  is_nullable: 1
  size: 500

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name_en",
  { data_type => "varchar", is_nullable => 0, size => 500 },
  "name_cz",
  { data_type => "varchar", is_nullable => 1, size => 500 },
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
  { "foreign.type" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07048 @ 2019-05-15 10:23:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:81uC4IS1BZYxp/qNSBCdpw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
