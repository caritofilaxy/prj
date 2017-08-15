#!/usr/bin/perl

use strict;
use warnings;
use v5.24;

my ($target_dir) = @ARGV;

sub name_exist {
	my $dir = shift;
	chomp($dir);
	opendir(my $dh, ".");
       # return grep { -d $_ && "/^$dir$/" } readdir($dh);
       	my $got = grep { -d $_ && $_ =~ /^$dir$/ } readdir($dh);
	$got;
}

name_exist($target_dir);
