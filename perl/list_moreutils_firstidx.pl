#!/usr/bin/perl

use strict;
use warnings;
use List::MoreUtils qw(firstidx);

my @names = qw(jan feb mar apr may jun jul aug sep oct nov dec);
print firstidx { $_ eq "mar" } @names;

