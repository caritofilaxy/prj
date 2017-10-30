#!/usr/bin/perl

use strict;
use warnings;

use Time::HiRes qw(gettimeofday tv_interval);

my $t0;

$t0 = [gettimeofday];

for (;;) {
    my $delta = tv_interval ( $t0, [gettimeofday] );
    if ($delta > 0.5) {
        print "message $delta\n";
        $t0 = [gettimeofday];
    }
}

    

