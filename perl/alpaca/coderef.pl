#!/usr/bin/perl

use strict;
use warnings;

sub skipper_greets {
	my $who = shift;
	print "Hey there, $who!\n";
}

sub gilligan_greets {
	my $who = shift;
	if ($who eq "Skipper") {
		print "Sir, yes, sir, $who!\n";
	} else {
		print "Hi, $who.\n";
	}
}

sub professor_greets {
	my $who = shift;
	print "Bzzz.. click.. click.. You are $who\n";
}

my $ginger = sub {				# anon subroutine
	my $who = shift;			 
	print "Well hello, $who\n";		
};						

my $greets = {					# anon hash
	"Skipper" => \&skipper_greets,
	"Gilligan" => \&gilligan_greets,
	"Professor" => \&professor_greets,
	"Ginger" => $ginger,
};

my @bar;
for my $person (keys %$greets) {
	print "\n";
	print "$person walks into the bar.\n";

	for my $person_in_bar (@bar) {
		print "$person: "; $greets->{$person}->($person_in_bar); 		# use second arrow
		print "$person_in_bar: "; $greets->{$person_in_bar}($person); 		# omit second arrow
	}
	push @bar, $person;
}
