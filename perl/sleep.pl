#!/usr/bin/perl

use strict;
use warnings;

STDOUT->autoflush(1);

my $d = 10;
while ($d-->0) {
	print $d;
	sleep 1;
        print chr(8);
	}
