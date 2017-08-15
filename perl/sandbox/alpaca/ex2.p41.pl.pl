#!/usr/bin/perl

use strict;
use warnings;

chomp (my $pattern = <STDIN>);
while ($pattern !~ /^$/) {
	chdir("/etc");
	my @files = eval { grep { /$pattern/ } glob '*' };
	print "Alarm: $@\n" if $@;
	print "$_\n" for @files;
	chomp($pattern = <STDIN>);
}
