#!/usr/bin/perl

use v5.022;
use warnings;
use Data::Dump::Streamer;

my @luxs = qw(Diamonds Furs Caviars);

my $hash = {
	Gilligan 	=> 	sub { say 'Howdy Skipper!' },
	Skipper  	=> 	sub { say 'Gilligan!' },
	'Mr. Howell' 	=> 	sub { say 'Money Money Money!' },
	Ginger 		=> 	sub { say $luxs[rand @luxs] },
};

Dump $hash;
