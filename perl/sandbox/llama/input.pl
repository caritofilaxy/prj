#!/usr/bin/perl

use v5.022;
use warnings;

my %whoinfo;

foreach(`who`) {
	my ($name,$tty,$date) = /(\S+)\s+(\S+)\s+(\N+)/;
	$whoinfo{$tty} .= "$name at $date";
	}
while(my ($k,$v) = each %whoinfo) {
	print "$k =>> $v\n";
	}
