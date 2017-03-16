#!/usr/bin/perl

use v5.022;

my @items = qw(integer float boolean);
my $format = "The items are:\n".("%10s\n" x @items);
printf $format, @items;
