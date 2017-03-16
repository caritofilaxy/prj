#!/usr/bin/perl

use v5.022;

running_sum(3,8);
running_sum(14..16);
running_sum(32);


sub running_sum {
	state $sum;
	state @numbers;

	foreach (@_) {
		push @numbers, $_;
		$sum += $_;
	}
	
	say "The sum of (@numbers) is now $sum"
}
