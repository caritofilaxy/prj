#!/usr/bin/perl
#tcpclient.pl

use strict;
use warnings;
use IO::Socket::INET;

# flush after every write
$| = 1;

my ($socket,$client_socket);

# creating object interface of IO::Socket::INET modules which internally creates 
# socket, binds and connects to the TCP server running on the specific port.
$socket = IO::Socket::INET->new(
	PeerHost => '127.0.0.1',
	PeerPort => '5000',
	Proto => 'tcp',
) or die "ERROR in Socket Creation : $!\n";

print "TCP Connection Success.\n";

# read the socket data sent by server.
my $data = <$socket>;
# we can also read from socket through recv()  in IO::Socket::INET
# $socket->recv($data,1024);
print "Received from Server : $data\n";

# write on the socket to server.
$data = "DATA from Client";
print $socket "$data\n";
# we can also send the data through IO::Socket::INET module,
# $socket->send($data);

$socket->close();
