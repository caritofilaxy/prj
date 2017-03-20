#!/usr/bin/perl
#
use v5.022;

my $what = 'fred|barney';
my $string = 'fredfredbarneyfred';

if ($string =~ /$what x 3/) {
	print "Match!\n";
	}
