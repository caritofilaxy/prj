#!/usr/bin/perl

use v5.022;

my @arr=();

while(<STDIN>) {
#	chomp;
	push @arr, $_;
}

say "@arr";
