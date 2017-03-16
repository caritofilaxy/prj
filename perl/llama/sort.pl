#!/usr/bin/perl
#
chomp(@lines = <STDIN>);

@lines = sort @lines;
print "@lines\n";
print"$_\n" for @lines;
