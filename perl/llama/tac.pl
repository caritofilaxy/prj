#!/usr/bin/perl
#
use v5.022;

my @lines = ();

while(<>) {
	push @lines, $_;
}

print reverse @lines;
