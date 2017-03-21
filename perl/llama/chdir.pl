#!/usr/bin/perl

use v5.022;
use warnings;

my $curdir;
chomp(my $userdir = <STDIN>);


if ($userdir =~ /^\s+$/) {
	$curdir = $ENV{HOME};
	chdir($curdir) || die "Cant chdir to $curdir: $!";
	my @files = <$curdir/* $curdir/.*>;
	say "@files";
	} else {
	$curdir = $userdir;
	my @files = <$curdir/* $curdir/.*>;
	say "@files";
}

