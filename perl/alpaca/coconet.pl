#!/usr/bin/perl

use strict;
use warnings;

my $traffic;
my $traffic_src;

while(<>) {
	my ($src,$dst,$bytes) = split;
	$traffic_src->{$src} += $bytes;
	$traffic->{$src}->{$dst} +=$bytes;
	}

my $sorted_vals = [ sort by_value_src keys %$traffic_src ];
for my $k_src (@$sorted_vals) {
	printf("%-30s: %-30d\n", $k_src, $traffic_src->{$k_src});
}

for my $k_src (sort keys %$traffic) {
#	printf("%-30s: %-30d\n", $k_src, $traffic_src->{$k_src});
	for my $k_dst (sort keys $traffic->{$k_src}) {
		printf("%-30s => %-30s: %-30d\n", $k_src, $k_dst, $traffic->{$k_src}->{$k_dst});
	}
}

sub by_value_src {
	$traffic_src->{$b} <=> $traffic_src->{$a};
	}
