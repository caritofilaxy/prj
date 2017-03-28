#!/usr/bin/perl

use v5.022;
use warnings;
use autodie;

open(my $fh, "<", "perlvar.txt");

my @lines = <$fh>;

#chomp(my $pattern = <STDIN>);
#
#while($pattern) {
#	my @match = eval { grep { /$pattern/ } @lines; };
#	print "Bad pattern: @!\n" if @!;
#	my $match_count = @match;
#	print "Matched $match_count lines\n";
#	print "@match";
#	chomp($pattern = <STDIN>);
#}

my $pattern;
for (chomp($pattern = <STDIN>); $pattern; ) {
	my @match = eval { grep { /$pattern/ } @lines; };
	print "Bad pattern: @!\n" if @!;
	my $match_count = @match;
	print "Matched $match_count lines\n";
	print "@match";
	chomp($pattern = <STDIN>);
}
