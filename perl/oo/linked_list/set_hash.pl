#!/usr/bin/perl

use Element;
use Data::Dumper;
use strict;
use warnings;

my %root;

open(my $db, "<", "elements.db");
while(<$db>) {
	next if /^#/;
	my ($name,$symbol,$ram,$an,$p) = split(",", $_);
	$root{$name} = [ $name, $symbol, $ram, $an, $p ];
}

print Dumper(%root);
