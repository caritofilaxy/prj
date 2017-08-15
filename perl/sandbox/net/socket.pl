#!/usr/bin/perl

use v5.24;
use warnings;
use autodie;
use Socket;

my $rhost = "localhost";
my $rport = 2345;

socket(my $socket, PF_INET, SOCK_STREAM, getprotobyname("tcp"));
my $addr = inet_aton($rhost);
my $paddr=sockaddr_in($rport, $addr);

connect($socket,$paddr);
$socket->autoflush(1);

say $socket "Knock knock";
my $reply =<$socket> =~ s/\R\z//r;

say "Reply: $reply";
