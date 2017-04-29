#!/usr/bin/perl

use v5.022;
use warnings;

my $extract = vec("have a nice day", 3, 8);
printf("got dec ascii [%s] which is char [%s]\n", $extract, chr($extract));


# vec is lvalue
my $bit_string = "Have a nice day";
vec($bit_string, 13, 8) = ord('i');
vec($bit_string, 14, 8) = ord('e');
say $bit_string;

# difference between lowercase and uppercase is in ascii table is 32
# 32 = 2**5 so we need to change 5th bit to switch between lowercase and upper
# e.g we can make first char lowercased. bits of every byte counts from right
# to left as little-endian arch.

my $bit_string = "perl";

# p		e		r		l
# 01110000	01100101	01110010	01101100
# P		E		R		L
# 01010000	01000101	01010010	01001100
	
# 76543210	54321098	32109876	10987654
# <-------	<-------	<-------	<-------
vec($bit_string, 5, 1) = 0;
say $bit_string;
vec($bit_string, 13, 1) = 0;
say $bit_string;
vec($bit_string, 21, 1) = 0;
say $bit_string;
vec($bit_string, 29, 1) = 0;
say $bit_string;
