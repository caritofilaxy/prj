#!/usr/bin/perl

use v5.022;
use warnings;

my $pattern = qr(high|low);

say $pattern;

my $d = 'a2c';
$d =~ s/(\d+)/$1+1/e;
say $d;


# qr/abc123def/mi eq qr(?mi:abc123def)

my $pirates = {
	john => qr/(?i:long)?silver/i;
	dog  => qr/black/i;
	
