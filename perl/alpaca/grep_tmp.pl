#!/usr/bin/perl

use strict;
use warnings;


my @netutils = qw(ping mtr dig host tcpdump nmap ncat wget curl arp tc);
my @tcpadmin = qw(tcpdump nmap wget curl);

print "All utils: @netutils\n";
print "Used utils: @tcpadmin\n";
print "Missing utils: ";

for my $tcputil (@netutils) {
	unless ( grep { $tcputil eq $_ } @tcpadmin ) {
		print "$tcputil ";
	}
}
print "\n";

printf("%s: %s\n", "Netutils", @netutils);

