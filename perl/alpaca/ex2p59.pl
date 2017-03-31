#!/usr/bin/perl

use strict;
use warnings;



my @dnsadmin = qw(dig host bind);
my @tcpadmin = qw(tcpdump nmap wget curl);
my @sillyadmin = qw(ping firefox);

my %all = (
	john => \@dnsadmin,
	james => \@tcpadmin,
	jim => \@sillyadmin,
);

chk_req(\%all);


sub chk_req {
	my @netutils = qw(ping mtr dig host nmap ncat wget curl arp tc);
	my @missing = ();

	for my $entries (keys $%@_) {
		
	
