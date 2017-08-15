#!/usr/bin/perl

use v5.022;

my $i;
my $init;

foreach my $num (1..50) {
	$i = 0;
	$init = $num;
	while ($num != 1 ) {
		if ($num % 2 == 0) {
			$num /= 2;
			$i++;
			
		} else {
			$num = $num*3+1;
			$i++;
		}

	}
	print "$init requires $i iterations\n";
}
