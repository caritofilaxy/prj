#!/usr/bin/perl

use v5.022;
use warnings;

my $curdir = $ENV{PWD};

chdir('/');
open(my $out, '', "$curdir/ls.out");
print $out system("ls -la");
