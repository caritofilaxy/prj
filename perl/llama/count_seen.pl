#!/usr/bin/perl

use v5.022;

my %wlist;

#while(<STDIN>) {
#	chomp;
#	$wlist{$_} += 1;
#}

while(<STDIN>) {
	chomp;
	my @a1 = split '\s+';
	for (@a1) { $wlist{$_} += 1 if /^\w+$/; }
}



while (my ($k, $v) = each %wlist) {
	print "$k: $v\n";
} 
