#!/usr/bin/perl

use v5.022;

#my @items = qw(integer float boolean);
#my $format = "The items are:\n".("%10s\n" x @items);
#printf $format, @items;
#

my @words = ();
my $offset = 0;

print "123456789012345678901234567890\n";

$offset = (<STDIN>);

while(<STDIN>) {
	chomp;
	push @words, $_;
	}
my $fmt = ("%$offset\n" x @words);

printf $fmt, @words;
