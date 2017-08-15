#!/usr/bin/perl

use strict;
use warnings;


my @dnsadmin = qw(dig host bind);			#
my @tcpadmin = qw(tcpdump nmap wget curl);		#
my @sillyadmin = qw(ping firefox);			#
							#
my @all = (\@dnsadmin, \@tcpadmin, \@sillyadmin);	# usual reference to array
my $ref_all = \@all;					#
							#
my $wget = $ref_all->[1][2];				#
print $wget . "\n";					#


$ref_all = [					#
		[ qw(dig host bind) ],			#
		[ qw(tcpdump nmap wget curl) ],		# no bullshit with intermediate data
		[ 'ping', 'firefox' ]			#
		];					#

$wget = $ref_all->[1][2];				#
print $wget . "\n";					#
