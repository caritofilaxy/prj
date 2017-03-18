#!/usr/bin/perl

use v5.022;

my $string = "It began in 1902 and continued in 1904...";
say "$1 $2" if $string =~ /(\d+)\D+(\d+)/;

$string = "Sherlock and Watson decided to have a lunch. I will have chiken-made steak, said Holmes. Watson ordered duck-made burger";

#if($string =~ /(chicken|duck)-made (steak|burger)/) {
if($string =~ /(?:chicken|duck)-made (steak|burger)/) { # discards first match capture
	say "$1";
}

# named capture
$string = "I saw    Holmes    and	Watson yesterday.";
if ($string =~ m{(?<cap1>\w+)\s+(?:and|or)\s+(?<cap2>\w+)}) {
	say "Objects: 1. $+{cap1}, 2. $+{cap2}";
}
