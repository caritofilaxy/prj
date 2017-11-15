#!/usr/bin/perl


# Closures are often used in callback routines. In graphical and other event-based programming, 
# you associate code with a keypress, mouse click, window expose event, etc. The code will be called much later,
# probably from an entirely different scope. Variables mentioned in the closure must be available when 
# it's finally called. To work properly, such variables must be lexicals, not globals. Another use 
# for closures is function generators, that is, functions that create and return brand-new functions. 

use strict;
use warnings;

sub timestamp {
	my $start_time = time();
	sub { return time() - $start_time }
}

my $early = timestamp();
sleep 10;
my $later = timestamp();
sleep 5;

printf "%d seconds from early\n", $early->();
printf "%d seconds from later\n", $later->(); 
