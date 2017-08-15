#!/usr/bin/perl

use strict;
use warnings;
use v5.24;

my $die_msg = "Usage: $0 create perl|c|asm name
       $0 delete name\n";
my $wrong_opt_n = "Wrong opt number";

my $argc = @ARGV;
die $wrong_opt_n unless (($argc == 2) or (argc == 3));

if (argc == 2) {
	my ($action,$name) = @ARGV;
	die "wrong action\n" unless ($action =~ /^delete$/);
	die "name undef\n" unless is_name($name);
	delete_
}

if (argc == 3) {
	my ($action,$lang,$name) = @ARGV;
	die "wrong action\n" unless ($action =~ /^delete$/) and ($lang =~/$(perl|c|asm)$/) and ($name);
	die "name undef\n" unless is_name($name);
}



sub is_name {
        my $dir = shift;
        opendir(my $dh, ".");
       # return grep { -d $_ && "/^$dir$/" } readdir($dh);
        my $got = grep { -d $_ && $_ =~ /^$dir$/ } readdir($dh);
        $got;
}

