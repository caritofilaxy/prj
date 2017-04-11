#!/usr/bin/perl 

use strict;
use warnings;
use IO::Pipe;

my $pipe = IO::Pipe->new;
$pipe->reader( "fortune" );
while(<$pipe>) {
	print "$.: $_";
}
