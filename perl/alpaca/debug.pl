#!/usr/bin/perl

use strict;
use warnings;

my %total_bytes;
while(<>) {
	my ($src,$dst,$bytes) = split;
	$total_bytes{$src}{$dst} += $bytes;
}


