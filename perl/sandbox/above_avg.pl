#!/usr/bin/perl
#
use v5.022;

my @list = qw(1 4 7 12 19);
my @av1 = above_avg(@list);
say "@av1";

say "Enter some numbers on separate lines: ";
@av1 = above_avg(<STDIN>);
say "@av1";


sub above_avg {
	my @nums = @_;
	my @av = ();
	my $sum = 0;
	my $av;
	foreach (@nums) {
		$sum += $_
	}
	
	$av = $sum/($#nums+1);
	say "$av";
	
	foreach (@nums) {
		if ($_ > $av) {
			push @av, $_;
		}
	}

	@av;
}

