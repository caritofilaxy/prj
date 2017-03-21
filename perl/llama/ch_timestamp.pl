#!/usr/bin/perl

use v5.022;
use warnings;

my $file = "2.txt";
my $now = time;
my $ago = $now - 24*60*60;

utime $now, $ago, $file;
