#!/usr/bin/perl

use v5.022;
use warnings;

my $divident;
my $divisor;
my $quotient;

$divident = 5;
$divisor = 0;

#$quotient = $divident / $divisor; # error
#print $quotient;

#$quotient = eval { $divident / $divisor; } # undef
#print $quotient;

# defined-or technique
$quotient = eval { $divident / $divisor; } // "NaN"; # if not defined then NaN
print "I couldnt devide by \$divisor: $@" if $@;

my @avgs = (44/3, eval { $divident/$divisor }, 53/7);
say "@avgs";
