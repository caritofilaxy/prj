#!/usr/bin/perl

use strict;
use warnings;
use Business::ISBN;

# 9780596102067
#
my $isbn13 = Business::ISBN->new('9780596102067');
#my $group = $isbn13->group_code;
#print "$group\n";
print "Godidze\n" if ($isbn13->is_valid);
