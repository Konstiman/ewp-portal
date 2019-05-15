use utf8;
package StudentPortal::Schema::Result::AcademicTermName;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

StudentPortal::Schema::Result::AcademicTermName

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

=head1 TABLE: C<academic_term_name>

=cut

__PACKAGE__->table("academic_term_name");

=head1 ACCESSORS

=head2 academic_term

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 1000

=head2 language

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "academic_term",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 1000 },
  "language",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 RELATIONS

=head2 academic_term

Type: belongs_to

Related object: L<StudentPortal::Schema::Result::AcademicTerm>

=cut

__PACKAGE__->belongs_to(
  "academic_term",
  "StudentPortal::Schema::Result::AcademicTerm",
  { id => "academic_term" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 language

Type: belongs_to

Related object: L<StudentPortal::Schema::Result::Language>

=cut

__PACKAGE__->belongs_to(
  "language",
  "StudentPortal::Schema::Result::Language",
  { id => "language" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07048 @ 2019-05-15 10:23:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:yyJQa+fVlQSaeCtRPgEnXQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
