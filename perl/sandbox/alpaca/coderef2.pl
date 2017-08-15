#!/usr/bin/perl

use strict;
use warnings;

my $action = sub {
	my $param = shift;
	my %actions = (
		1 => "seeking for treasures",
		2 => "fighting with guards",
		3 => "sitting in pub",
	);
	return $actions{$param};
};

for (qw(silver bones pew)) {
	my $param = int(rand(3))+1;
	print "$_ is ", $action->($param), "\n";
	}
