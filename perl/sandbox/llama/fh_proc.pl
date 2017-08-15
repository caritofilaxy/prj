#!/usr/bin/perl

use v5.022;
use warnings;

open(my $fh, '|-','mailx -s "alert" admin@softland.ru' ) || die "cant pipe to mail: $!";
my $text = `perldoc -t -f uc`;
print $fh $text;
close($fh);
die "mail: non-zero exit of $?" if $?;

say "end";
