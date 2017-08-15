#!/usr/bin/perl

use v5.022;
use warnings;

my $number = -12132397234345.6789;
$number = sprintf("%.2f", $number);
# next statement puts comma but it will be like 123456,123.90 if there is a lot of digits so we need cycle
#$number =~ s#^(-?\d+)(\d\d\d)#$1,$2#;
1 while $number =~ s#^(-?\d+)(\d\d\d)#$1,$2#;
$number =~ s#^(-?)#$1\$#;
say $number;
