#!/usr/bin/perl

use strict;
use warnings;

my $all = "**all machines**";
my %total_bytes;

while(<>) {
	next if /^#/;
	my ($src,$dst,$bytes) = split;
	$total_bytes{$src}{$dst} += $bytes;
	$total_bytes{$src}{$all} += $bytes;
	}

my @sources = sort { $total_bytes{$b}{$all} <=> $total_bytes{$a}{$all} } keys %total_bytes;

for my $src (@sources) {
	my @dst = sort { $total_bytes{$src}{$b} <=> $total_bytes{$src}{$a} } keys %{ $total_bytes{$src} };
	print "$src: $total_bytes{$src}{$all} bytes sent\n";
	for my $dst (@dst) {
		next if $dst eq $all;
		print "$src => $dst: $total_bytes{$src}{$dst} bytes\n";
	}
	print "\n";
}
