#!/usr/bin/perl

use strict;
use warnings;
use v5.24;

my $die_msg = "Usage: $0 create perl|c|asm name\n       $0 delete name\n";
my $wrong_opt_n = "Wrong opt number";

my $argc = @ARGV;
die $wrong_opt_n unless (($argc == 2) or (argc == 3));

if (argc == 2) {
	my ($action,$lang) = @ARGV;
	die "wrong action\n" unless ($action =~ /^delete$/);
	die "wrong name\n" unless is_name();
}

say "here";


sub is_name {
	opendir(my $dh, ".");
	my $ret = grep { -d $_ &&  /^$name$/ } readdir($dh);
	return $ret ? 1 : 0;
}
	
