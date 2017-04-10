#!/usr/bin/perl

use strict;
use warnings;
use File::Find;
my @dir = "/home/aesin/git/prj/perl";
sub print_bigger_than {
	my $minsize = shift;
	return sub { print "$File::Find::name\n" if -f and -s >= $minsize };
}

my $min_1024 = print_bigger_than(1024);
find($min_1024,@dir);
