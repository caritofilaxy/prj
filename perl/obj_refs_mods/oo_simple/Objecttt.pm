package Objecttt;

use strict;
use warnings;

sub new {
	my ($class) = @_;
	my $self = bless {_color=>$_[1]}, $class;
	return $self;
}

sub get_color { $_[0]->{_color} };

1;
