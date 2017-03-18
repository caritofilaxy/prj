#!/usr/bin/perl

use v5.022;

# Match capitalized
#while(<STDIN>) {
#	print if /[A-Z][a-z]+/;
#	}

# Match if line has 2 same chars next to each other
#while(<STDIN>) {
#	print if /(.)\1/;
#	}

# match if line mentions both words
while(<STDIN>) {
	print if /holmes.+watson|watson.+holmes/
	}

