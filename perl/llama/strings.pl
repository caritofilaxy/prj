#!/usr/bin/perl

use v5.022;
use warnings;

my $string = "I will not make any deals with you";
#	      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
#	      0123456789012345678901234567890123
my $where = index($string, "a");
say $where;

my $last_slash = rindex("/etc/passwd", "/");
#			 ^^^^^
#			 01234

say $last_slash;


my $will = substr($string, 20, 14);
say $will;

my $from_to_end = substr($string,20);
say $from_to_end; 

my $from_end_of_string = substr($string, -14);
say $from_end_of_string;

# substr + index
my $right = substr($string, index($string, "deals"));
say $right;

# replace part of string in place
substr($string, 0,1) = "Nobody";
say $string;

substr($string, -20) =~ s/a/@/g;
say $string;

# at that moment $string = "Nobody will not make @ny de@ls with you";
my $previous_value = substr($string, 7, 4, "shall");
say $previous_value;
say $string;

###################	
$string = "I will not make any deals with you, manny";
my $sub = "ma";

my @encs;

for (my $pos = -1; ; ) {
	$pos = index($string,$sub,$pos+1);
	last if $pos == -1;
	push @encs, $pos;
}

say "@encs";
