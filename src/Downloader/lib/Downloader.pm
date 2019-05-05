package Downloader;
 
use strict;
use warnings;
 
sub new {
	my $class  = shift;
	my %params = @_;
	
    my $self = bless { 
		id => ( $params{ id } || undef ),
		indentifier => $params{ identifier },
		# TODO nazvy a identifikatory
    }, $class;
	
	return $self;
}

# TODO gettery a settery
 
1;