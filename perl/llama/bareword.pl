#!/usr/bin/perl

use v5.022;

my %chars = (
	john => 'silver',
	alexander => 'smollet',
	david => 'livesey',
	jim => 'hawkins',
	);

while (my ($k, $v) = each %chars) {
	print "$k - $v\n";
}

$chars{black} = 'dog';
while (my ($k, $v) = each %chars) {
	print "$k - $v\n";
}
