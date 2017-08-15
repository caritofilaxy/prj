#!/usr/bin/perl

use v5.022;

while(<>) {
	chomp;
	say "$_\$" if /.*\s+\z/;
	}
