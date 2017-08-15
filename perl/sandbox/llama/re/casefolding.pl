#!/usr/bin/perl

# (\u, \U) (\l, \L) \E

use v5.022;

my $name = "shErLoCk hOLmEs";
say $name;
$name =~ s/(\w+)\s(\w+)/\u\L$1\E \u\L$2\E/;
say $name;
