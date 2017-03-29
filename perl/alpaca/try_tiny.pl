#!/usr/bin/perl

use strict;
use warnings;
use Try::Tiny;

my $quotient = try { 5/0 } catch { "NaN" };
print $quotient."\n";
