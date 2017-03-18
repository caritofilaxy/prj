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

# labels with backrefs
$string = "I saw   Dr Watson    and Mrs		Watson yesterday.";
if ($string =~ m#(?<last_name>\w+)\s+(?:and|or)\s+\w+\s+\g{last_name}#) {
	say "Last name: $+{last_name}";
}

# automatic match
$string = "there are 1923 little demons";
#if ($string =~ /\w+(\d+)\w+/) {
#	say "Before parentheses: $`";
#	say "In parentheses: $&";
#	say "After parentheses: $'";
if ($string =~ /\w+(\d+)\w+/p) {
	say "Before parentheses: ${^PREMATCH}";
	say "In parentheses: ${^MATCH}";
	say "After parentheses: ${^POSTMATCH}";
}
