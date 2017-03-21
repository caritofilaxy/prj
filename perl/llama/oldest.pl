#!/usr/bin/perl

use v5.022;
use warnings;

my %files_mtime;

foreach (@ARGV) {
	$files_mtime{$_} = -M $_;
}

foreach (keys %files_mtime) {
	say "$_: $files_mtime{$_}:";
}
