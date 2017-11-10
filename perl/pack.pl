#!/usr/bin/perl

use strict;
use warnings;

my $data;
my $part;

$data = 'this_is_a_good_day_today';

# get 3 bytes string, set 2 bytes to null, get twice of 6 bytes and the rest
my ($lead, $s1, $s2, $trail) = unpack("A4 x2 A6 A6 A*", $data);
print "$lead | $s1 | $s2 | $trail\n";

# separate by 5 chars
my @fivers = unpack("A5" x (length($data)/5), $data);
print "$_ | " for @fivers;
print "\n";

# string 2 array of chars
my @char_array = unpack("A1" x (length($data)), $data);
print "$_:" for @char_array;
print "\n";

$data = "to be or not to be";
$part = unpack("x6 A6", $data); # skip 6 grab 6
print $part, "\n";

my ($b, $c) = unpack("x6 A2 X5 A2", $data); # forward 6, get 2, backward 5, get 6
print "$b $c\n";

my @ascii_chars = unpack("C*", $data);
print $_, " " for @ascii_chars; # chr($_) to convert to char
print "\n";
$data = pack("C*", @ascii_chars);
print $data, "\n";

