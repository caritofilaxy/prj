#!/usr/bin/perl

use v5.22;

my $person="cat";

my $say_hello_to = sub ($) {
	say "Hello, $_[0]";
};

$say_hello_to->($person) if defined($person);
