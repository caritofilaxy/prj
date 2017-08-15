#!/usr/bin/perl
#
use v5.022;

greet("Larry");
greet("Guido");
greet("Dmitry");
greet("All porters");


sub greet {
	state @persons;
	my $newcomer = shift;

	if (!@persons) {
		say "Hello $newcomer! You are first here";
		push @persons, $newcomer
	} else {
		say "Hello $newcomer! @persons are already here";
		push @persons, $newcomer
	}
}
