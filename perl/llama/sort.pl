#!/usr/bin/perl

use v5.022;
use warnings;

#my @numbers = qw(24 53 65 23 67 12 97 46 84);
#my @sorted = sort { $a <=> $b } @numbers;

#print "@numbers\n";

my %sailors = (
	john => 'silver',
	billy => 'bones',
	willy => 'bones',
	dilly => 'bones',
	pew => 'blind',
	dog => 'black',
	alexander => 'smollet',
	david => 'livesey',
	jim => 'hawkins',
	squire => 'trelloney',
);

my @sailor_list = sort by_lname_and_fname keys %sailors;
print "@sailor_list\n";


sub by_lname_and_fname {
	$sailors{$a} cmp $sailors{$b}
	or
	$a cmp $b
}
