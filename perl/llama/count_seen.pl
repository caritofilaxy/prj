#!/usr/bin/perl

use v5.022;

my %wlist;

while(<STDIN>) {
	chomp;
	$wlist{$_} += 1;
}

while (my ($k, $v) = each %wlist) {
	print "$k: $v\n";
} 
