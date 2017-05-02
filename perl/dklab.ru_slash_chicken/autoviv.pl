#!/usr/bin/perl

use Data::Dumper;

$A[2]{a}[4]{b} = 100;
print '$A[10]{a}[20]{b}', "\n";

print Dumper(@A);
