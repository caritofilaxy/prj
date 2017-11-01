package Objecttt;

use strict;
use warnings;

use Carp;
sub read_only {
	croak "cant change value in read-only attribute " . (caller 1)[3]
		if @_ > 1;
}

# constructor;
sub new {
	my ($class) = @_;
	my $self = bless {_color=>$_[1]}, $class;
	return $self;
}

# accessor
sub get_color { &read_only; $_[0]->{_color} };

# mutator
sub set_color { 
	my ($self, $color) = @_;
	$self->{_color} = $color if $color;
}

1;
