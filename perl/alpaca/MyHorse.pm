package MyHorse;

use 5.006;
use strict;
use warnings;

our $VERSION = '0.01';

#sub speak {
#	print "Horse goes neigh!\n";
#}

sub sound { 'neigh' }

sub speak {
	my $class = shift;
	print "a $class goes ", $class->sound , "!\n";
}

