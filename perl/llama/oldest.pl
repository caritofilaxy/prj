#!/usr/bin/perl

use v5.022;
use warnings;

my %files_mtime;

foreach (@ARGV) {
	$ARGV{$_} = -M $_;
}

foreach (keys %files_mtime) {
	say "$files_mtime{$_}: $_";
}

