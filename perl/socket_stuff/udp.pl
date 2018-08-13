#!/usr/bin/env perl

use 5.016;
use warnings;

use Socket;

my $iaddr = inet_aton("localhost");
my $paddr = sockaddr_in(12345, $iaddr);
my $proto = getprotobyname("udp");

socket(my $s, PF_INET, SOCK_DGRAM, $proto);
connect($s, $paddr);
