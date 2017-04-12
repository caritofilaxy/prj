#!/usr/bin/perl

use v5.022;
use warnings;

my $pattern = qr(high|low);

say $pattern;

my $d = 'a2c';
$d =~ s/(\d+)/$1+1/e;
say $d;


# qr/abc123def/mi eq qr(?mi:abc123def)

#my $pirates = {
#	john => qr/(?i:long)?silver/i;
#	dog  => qr/black/i;
	
my $string = 'The quick brown fox jumps over lazy dog';
if ($string =~ /quick/) {
	my $pos0 = $-[0];
	my $pos1 = $+[0];
	say $string;
	say "$pos0\t$pos1";
}

	
if ($string =~ /brown\s(\w+?)\sjumps\s(\w+?)\slazy/) {
	my $match0 = substr($string, $-[1], $+[1] - $-[1]); # $1;
	say $match0;
	my $match1 = $2; # substr($string, $-[2], $+[2] - $-[2]);
	say $match1;
}
