#!/usr/bin/perl

use v5.022;
use warnings;

my $int_count = 0;
sub my_int_handler { $int_count++ }
$SIG{'INT'} = 'my_int_handler';
#...;

open(my $fh,'<','/usr/share/dict/words');
while (<$fh>) {
	print "Found $1\n" if /(aa)/;
	if ($int_count) {
	# interrupt was seen!
	print "[processing interrupted...]\n";
	last;
	}
}
