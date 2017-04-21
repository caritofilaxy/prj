#!/usr/bin/perl

use strict;
use warnings;

###############################################
print "## scalar reference ##\n";
my $string = 'i just hacked localhost';
my $ref = \$string;
print "[", $ref, "]", " points to \'", ${$ref}, "\'\n\n";		# ${ $ref } is to dereferece scalar

###############################################
print "## array reference ##\n";
my $array = [qw(tcp udp icmp)];
print 'Use @{$array} to dereference array',"\n";
print 'values in @{$array} are: ';
print "$_ " for @{$array}; print "\n";				# @{ $array } - deref array

print 'To get n-th element in array use $array->[n]', "\n";
print '$array->[1] is ', $array->[1], "\n\n";			# slice of dereferenced array.

###############################################
print "## hash reference ##\n";
my $netsvc = {
	ssh => 22,
	smtp => 25,
	http => 80,
	pgsql => 5432,
};

print 'Use %{$netsvc} to dereference hash', "\n";
print "Services are: ";
print "$_ " for keys %{$netsvc};			
print "\n";

print 'To get value from hash ref use $hash->{key}', "\n";
print 'Port of http service $netsvc->{http} is ', $netsvc->{http}, "\n\n";

###############################################
print "## sub reference ##\n";

my $lowercaser = sub {
	my $arg = shift;
	lc($arg);
};

print $lowercaser->("HeLLo"), "\n";
	
