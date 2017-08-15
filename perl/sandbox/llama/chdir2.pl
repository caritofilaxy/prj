#!/usr/bin/perl

use v5.022;
use warnings;

my $curdir;
my @files;
chomp(my $userdir = <STDIN>);


if ($userdir =~ /^\s+$/) {
	$curdir = $ENV{HOME};
	opendir(my $dh, $curdir) || die "Cant open $curdir: $!";
	foreach (readdir $dh) { next if /^\./; push @files, $_ };
	say "@files";
	} else {
	$curdir = $userdir;
	opendir(my $dh, $curdir) || die "Cant open $curdir: $!";
	for (readdir $dh) { next if /^\./; push @files,$_ };
	say "@files";
}

