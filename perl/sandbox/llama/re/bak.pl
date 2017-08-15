#!/usr/bin/perl
# Copyright (C) 20xx by BooBoo


use v5.022;

my $date = `date`;

$^I = '.out';

while (<>) {
	s/^Author:.*/Author: Randal L. Schwartz/;
	s/^Phone:.*\n//;
	s/^Date:.*/Date: $date/;
	print;
}
