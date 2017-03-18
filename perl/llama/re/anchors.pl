#!/usr/bin/perl
#
use strict;
use warnings;

$_ = 'Sherlock Holmes
Irene Adler
Dr Watson
professor Moriarti';

print "Match string $1\n" if /(\ASherlock)/;
print "Match string $1\n" if /(Moriarti\z)/;
print "Match string $1\n" if /(Adler$)/m;
print "Match string $1\n" if /(^Dr)/m;

