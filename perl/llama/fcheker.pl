#!/usr/bin/perl

use v5.022;
use warnings;

foreach(@ARGV) {
	checker($_);
}


sub checker {
	my $out;
	my $file = shift;
	unless (-e $file) {say "No $file"; return };
	my $mode = 0777 & (stat($file))[2];
	$out .= "$file is readable\n" if $mode & 0400; 
	$out .= "$file is writable\n" if $mode & 0200;
	$out .= "$file is executable\n" if $mode & 0100;
	print $out;
}
	
