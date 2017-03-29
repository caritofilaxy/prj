#!/usr/bin/perl

use strict;
use warnings;

my @files = <*>;

@files =  grep { -s $_ < 200 }  @files;
@files = map { "____".$_."\n"; } @files;
print for @files;

