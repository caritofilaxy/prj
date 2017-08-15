#!/usr/bin/perl

use v5.022;
use warnings;

#my ($year, $month, $day) = (localtime)[5,4,3];
#$year += 1900;
#$month++;

foreach my $file (<*>) {
	my ($atime, $mtime) = map {
		my ($year, $month, $day) = (localtime)[5,4,3];
		$year += 1900; $month++;
		sprintf '%4d-%02d-%02d', $year, $month, $day;
	} (stat $file)[8,9];

	printf("%-20s %10s %10s\n", $file, $atime, $mtime);
}
