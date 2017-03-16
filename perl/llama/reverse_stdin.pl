#!/usr/bin/perl
#
chomp(@lines = <STDIN>);

@lines = reverse @lines;
print"$_\n" for @lines;
