#!/usr/bin/perl

$ENV{DEBUG} = undef;

foreach (sort keys %ENV) {
	printf("%-30s: %20.100s\n", $_, $ENV{$_} // "(undefined value)");
}
