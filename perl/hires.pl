#!/usr/bin/perl
#
use strict;
use warnings;

use Time::HiRes qw(gettimeofday);
print "Press return...";
my $before = gettimeofday;
my $line = <STDIN>;
my $elapsed = gettimeofday() - $before;
print "You took ", $elapsed, " seconds\n";

