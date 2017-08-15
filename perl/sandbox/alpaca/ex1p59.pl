#!/usr/bin/perl

use strict;
use warnings;

my @gen = qw(eax ebx ecx edx);
my @ind = qw(esi edi);
my @ptr = qw(ebp esp);
my @all = (\@ptr, \@ind, \@gen);
my $all_ref = \@all;

my $ebx = $all_ref->[2][1];
my $ecx = $all_ref->[2]->[2];
my $edx = ${$all_ref->[2]}[3];
print $ebx . "\n";
print $ecx . "\n";
print $edx . "\n";

$ebx = ${$all[2]}[1];
print $ebx . "\n";
