#!/usr/bin/perl

use v5.022;
use strict;
use warnings;

{
	my $count;
	sub add_one { $count++ };
	sub at_now { return $count };
}

add_one();
add_one();
add_one();
print "I have ", at_now(), " coconuts\n";

###########################################

{
	my $countdown = 10;
	sub minus_one { $countdown-- };
	sub remain { return $countdown };
}

minus_one();
minus_one();
minus_one();
print "we're down to ", remain(), " coconuts\n";

###########################################

# shoud have use > v5.010;
sub countdown {
	state $cd = 10;
	$cd--;
	print $cd, "\n";
}

countdown();
countdown();
countdown();
countdown();


