#!/usr/bin/perl
#
use warnings;
use v5.022;

# in case we have do get name for sub which is unfinished yet (e.g. recursive anon sub)

my $countdown = sub {
	state $n = shift;
	return unless $n > -1;
	say $n--;
	__SUB__->();
};

$countdown->(5);

# this works also with named subs

sub countup {
	my $param = shift;
	state $init = 0;
	return if $init ge $param;
	say $init++;
	__SUB__->($param);
}
countup(5);
