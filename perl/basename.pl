#!/usr/bin/perl

use v5.022;
use File::Basename qw /basename/;
#use File::Basename ();

my $name = "/usr/local/bin/perl";

my $basename = basename $name;
my $dirname = File::Basename::dirname $name;

say $basename;
say $dirname

