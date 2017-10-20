#!/usr/bin/perl
#
use strict;
use warnings;
use Socket;

my ($remote, $port, $iaddr, $paddr, $proto);
$remote  = shift || "localhost";
$port    = shift || 80;  # random port
if ($port =~ /\D/) { $port = getservbyname($port, "tcp") }
die "No port" unless $port;
$iaddr   = inet_aton($remote)       || die "no host: $remote";
$paddr   = sockaddr_in($port, $iaddr);
$proto   = getprotobyname("tcp");
socket(SOCK, PF_INET, SOCK_STREAM, $proto)  || die "socket: $!";
connect(SOCK, $paddr)               || die "connect: $!";
close (SOCK)                        || die "close: $!";
exit(0);
