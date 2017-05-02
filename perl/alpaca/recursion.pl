#!/usr/bin/perl
#
use v5.022;
use warnings;

sub fck {
	my $n = shift;
	if ($n <= 1) {
		return 1;
	} else {
		return $n * fck($n-1);
	}
}

my $res = fck(5);
say $res;

my fib {
		$last += $next2last;
		print "$last ";
		$count++;
	}
