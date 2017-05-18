#!/usr/bin/perl

use v5.022;
use warnings;

sub gcd($$) {
	my ($d1, $d2) = @_;
	my $r = $d1 % $d2;
	unless ($r == 0) {
		while ($r > 0) {
			$r = $d1 % $d2;
			return $d2 unless $r;
			$d1 = $d2;
			$d2 = $r;
		}
	} else {
		$d2;
	}
}

my $d1 = 27; my $d2 = 18;

say "GCD of $d1 and $d2 is ", gcd($d1,$d2);

