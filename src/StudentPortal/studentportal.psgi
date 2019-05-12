use strict;
use warnings;

use StudentPortal;

my $app = StudentPortal->apply_default_middlewares(StudentPortal->psgi_app);
$app;

