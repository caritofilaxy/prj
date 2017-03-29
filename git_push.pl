#!/usr/bin/perl

use strict;
use warnings;
use Net::Ping;
use Git::Repository;

my $host = "github.com";


# checking if github available
my $p = Net::Ping->new("tcp");
$p->port_number("443");
die "https://".$host." is not responding. Exiting...\n" unless ($p->ping($host));

#my $r = 
