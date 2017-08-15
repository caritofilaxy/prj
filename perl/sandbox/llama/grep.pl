#!/usr/bin/perl

use v5.022;
use warnings;
use autodie;

open(my $fh,'<','words_seen.pl');

my @lines = grep { /while/ } <$fh> ;
print "@lines";
