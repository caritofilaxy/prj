#!/usr/bin/perl

use v5.022;
use warnings;


chdir('/home/aesin');
my @fwdots=<.* *xls>;

say for (@fwdots);

