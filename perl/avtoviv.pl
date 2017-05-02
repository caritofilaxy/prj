#!/usr/bin/perl
#
use v5.22;
use Data::Dumper;

#my @array;
#$array[3]->{"English"}->[0] = "January";
#print Dumper(@array);

my $array->[3]->{"English"}->[0] = "January";
print Dumper($array);

say "#"x80;

my @listref;
$listref[1]->[2] = "Hello";
${$listref[1][1]}[1] = "Goodbye";
print Dumper(@listref);
