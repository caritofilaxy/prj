#!/usr/bin/perl

use v5.022;
use warnings;
use autodie;
use Try::Tiny;

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
my @match;
my $match_count;
for (chomp($pattern = <STDIN>); $pattern; ) {
	@match = try { grep { /$pattern/ } @lines; }
		 catch { say "Error: $_" };
	$match_count = @match;
	print "Matched $match_count lines\n";
	print "@match";
	chomp($pattern = <STDIN>);
}
