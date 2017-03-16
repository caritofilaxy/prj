#!/usr/bin/perl

use v5.022;

#while(defined(my $line = <STDIN>)) {
#	print "I saw $line"
#}

#while(<STDIN>) {
#	print "I saw $_";
#}

# usage: ./stdin [file2process]
while(<>) {
	print "$ARGV: $_";
}
