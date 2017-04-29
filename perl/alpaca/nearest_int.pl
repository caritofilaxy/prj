#!/usr/bin/perl
#
use v5.022;
use warnings;
use POSIX qw(ceil floor);

my $v = 5.5;
my $f = floor($v); my $c = ceil($v);
my $n = ($v-$f) < ($c-$v) ? $f : $c;

say $n;
