#!/usr/bin/perl

use v5.022;
use warnings;

#system('date');

defined(my $pid = fork) || die "cant fork: $!";
unless ($pid) {
	exec 'date';
	die "cant exec date: $!";
}
waitpid($pid,0);
