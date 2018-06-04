#!/usr/bin/perl

use Time::Local;

my $file = $ARGV[0];
my $date = $ARGV[1];

($year,$mon,$day) = split("_", $ARGV[1]);
$mon--;


my $time = timelocal(0,0,0,$day,$mon,$year);

utime($time,$time,$file);
