package StudentPortal::View::HTML;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt2',
    render_die         => 1,
    TIMER              => 0,
    WRAPPER            => 'wrapper.tt2',
    ENCODING           => 'utf-8',
);

=head1 NAME

StudentPortal::View::HTML - TT View for StudentPortal

=head1 DESCRIPTION

TT View for StudentPortal.

=head1 SEE ALSO

L<StudentPortal>

=head1 AUTHOR

Jan Konstant

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
