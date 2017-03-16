#!/usr/bin/perl
#
use v5.022;

my @list = qw(1 3 5 7 9);
my $tot = total(@list);
say "The total of @list is $tot";

say total(1..1000);

say "Enter some numbers on separate lines: ";
$tot = total(<STDIN>);
say "The total of those numbers is $tot";


sub total {
	my $sum = 0;
	foreach (@_) {
		$sum += $_
	}
	$sum
}

