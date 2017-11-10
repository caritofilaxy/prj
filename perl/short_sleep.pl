#!/usr/bin/perl

use strict;
use warnings;
use Time::HiRes qw(sleep);

$| = 1;


#my $tts = 0.75;
#print "Start\n";
#select(undef,undef,undef,$tts);
#print "Stop\n";
#print "Start\n";
#sleep($tts); # from Time::HiRes
#print "Stop\n";



open(my $fh, "<", $0);
my $text;
$text .= $_ while(<$fh>);
my @chars = split(//, $text);
for my $char (@chars) {
	my $time = substr((rand(25)/100),0,4);
	sleep($time);
	print $char;
}

