#!/usr/bin/perl

use v5.022;
use warnings;

#my @nmbrs = qw(12 23 65 87 34 98 54 78 9 32 5 82 99 64 83 16 73 28);
my @nmbrs = (1..3000);
@nmbrs = reverse @nmbrs;

for (my $m=0; $m<=$#nmbrs; $m++) {
	for (my $n=$m+1; $n<=$#nmbrs; $n++) {
		if ($nmbrs[$m] > $nmbrs[$n]) { 
			($nmbrs[$m],$nmbrs[$n]) = ($nmbrs[$n],$nmbrs[$m]); 
		}
			
	}
}

say "@nmbrs";
