#!/usr/bin/perl

use v5.022;
use warnings;

my $argc = @ARGV;

die "gcd int int" unless $argc == 2;

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

say "GCD of $ARGV[0] and $ARGV[1] is ", gcd($ARGV[0],$ARGV[1]);

