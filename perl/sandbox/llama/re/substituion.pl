#!/usr/bin/perl

use v5.022;

# nondestruction 
my $orig = "I will not make any deals with you";
my $copy = $orig =~ s/(with)/$1out/r;
say "$copy\n$orig";
