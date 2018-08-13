#!/usr/bin/perl

use strict;
use warnings;

sub ret_arr_or_sca {
	my @list = qw/ H He C O /;
	return @list if (wantarray());
	my $scalar = "Mendeleev rocks" if (defined wantarray() );
}

my $single = ret_arr_or_sca();
my @plural = ret_arr_or_sca();

print "Returned scalar: $single\n";
print "Returned list: @plural\n";
