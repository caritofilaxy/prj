#!/usr/bin/perl

use v5.022;
use warnings;

my $fh = `date`;

for ($fh) {
	when (/Mon|Tue|Wed|Thu|Fri/) { say "Go work"; };
	when (/Sat|Sun/) { say "Go play"; };
	}
