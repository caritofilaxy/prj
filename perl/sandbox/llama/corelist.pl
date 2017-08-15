#!/usr/bin/perl
#
use v5.022;
use Module::CoreList;

my %mod_list = %{ $Module::CoreList::version{5.022} };

while (my ($k, $v) = each %mod_list) {
	say "$k: $v";
	}
