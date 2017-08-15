#!/usr/bin/perl

use v5.022;

while(<>) {
	chomp;
	if (/(\w+a)(.{0,5})/) {
	#	say "Matched: |$`($&)$'|";
		say "\'\$1\' contains \'$1\' and $2";
	} else {
		say "No match: |$_|";
	}
}
