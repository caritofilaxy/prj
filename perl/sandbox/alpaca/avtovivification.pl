#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $who;
my %utils;

die "Usage: $0 <file>" unless @ARGV;

while(<>) {
	if (/^(\S+)/) {
		$who = $1;
##		$utils{$who} = [ ] unless exists $utils{$who};
	} elsif (/^\s+(\S+)/) {
		die "no key yet" unless defined $who;
		push @{$utils{$who}}, $1;
	} else {
		die "You are giving me bullshit";
	}
}

foreach my $k (keys %utils) {
	print "$k: ", join(' ',@{$utils{$k}});
	print "\n";
}

my $no_thing;		# undef
# $no_thing = [ ]; 	# inserted through avtoviv;
@$no_thing = qw(cat sed awk);
print $no_thing->[1] . "\n";

my $top;
$top->[1]->[2] = "deep";
print Dumper($top);
