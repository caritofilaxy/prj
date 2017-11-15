#!/usr/bin/perl

use strict;
use warnings;

{ 
	my $count = 1;
	sub incounter { ++$count; sub { return (caller(1))[3]} };
	sub decounter { --$count };
}

#sub this_func {
#    my ($package, $file, $line, $subr, $has_args) = (caller(1))[0,1,2,3,4];
#    print "Package: $package, File: $file, Line: $line, Subr: $subr, HasArgs: $has_args\n";
#}

my $subr = incounter();
print "Subr: $subr\n";
