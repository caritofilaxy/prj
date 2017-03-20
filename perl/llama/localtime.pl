#!/usr/bin/perl

use v5.022;
use warnings;

#my $timestamp = 1180630098;
my $timestamp = 1490012018;
my $date = localtime $timestamp;
my($sec, $min, $hour, $day, $mon, $year, $wday, $yday, $isdst) = localtime $timestamp;

say $date;

if ($ARGV[0]) {
	my ($atime, $mtime, $ctime) = (stat($ARGV[0]))[8,9,10];
	$atime = localtime $atime;
	$mtime = localtime $mtime;
	$ctime = localtime $ctime;
	say "$atime\n$mtime\n$ctime";
}


