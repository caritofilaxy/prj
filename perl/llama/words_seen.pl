#!/usr/bin/perl

use v5.022;

my %wlist;

while(<STDIN>) {
	$wlist{$_} = 
