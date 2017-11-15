#!/usr/bin/env perl

use strict;
use warnings;
use v5.22;
use File::Compare;

unless (compare($ARGV[0], $ARGV[1]) == 0) {
	say "Files are different";
}

# also compare($fh1, $fh2)
#
