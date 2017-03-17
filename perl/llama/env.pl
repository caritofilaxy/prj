#!/usr/bin/perl



foreach (sort keys %ENV) {
	printf("%-30s: %20.100s\n", $_, $ENV{$_});
}
