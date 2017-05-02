#!/usr/bin/perl
#
#
use v5.24;


my $string =<<"END";
Please be informed that you are fired.
Thank you for time. Be well.
END

say "1" if ($string =~ /inform.+well/s); # "s" also matches newline;

my $v1 = "It is a good day today";
my $out = ($v1 =~ s/good/great/r); # $v1 remains the same, $out changed
say "$out\t\t$v1";
