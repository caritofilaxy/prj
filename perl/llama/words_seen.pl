#!/usr/bin/perl

use v5.022;

my %wlist;

while(<STDIN>) {
	$wlist{$_} += 1;
	}

while (my ($k, $v) = each %wlist) {
	say "$k: $v";
	}
