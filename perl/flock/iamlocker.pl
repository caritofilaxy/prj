#!/usr/bin/perl

use v5.022;
use warnings;
use Fcntl qw(LOCK_EX);

my $file = "dummy.txt";

die "cannot open $file: $!" unless open(my $fh, ">", $file);
die "cannot lock $file: $!" unless flock($fh,LOCK_EX);

1 while (sleep 1);
