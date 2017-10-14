#!/usr/bin/perl

use strict;
use warnings;
use IO::Socket::INET;

$| = 1;

my ($socket,$client_socket);
my ($peer_address,$peer_port,$data);

$socket = IO::Socket::INET->new(
	LocalAddr => '127.0.0.1',
	LocalPort => '5000',
	Proto => 'tcp',
	Listen => 5,
	Reuse => 1,
) or die "Cant create socket: $!\n";

print "server waiting for client connection on port 5000\n";

for (;$client_socket = $socket->accept();) {
	# waiting for new client connection.
	# $client_socket = $socket->accept();

	# get the host and port number of newly connected client.
	$peer_address = $client_socket->peerhost();
	$peer_port = $client_socket->peerport();

	print "Accepted New Client Connection From : $peer_address, $peer_port\n ";

	# write operation on the newly accepted client.
	$data = "DATA from Server";
	print $client_socket "$data\n";
	# we can also send the data through IO::Socket::INET module,
	# $client_socket->send($data);

	# read operation on the newly accepted client
	$data = <$client_socket>;
	# we can also read from socket through recv()  in IO::Socket::INET
	# $client_socket->recv($data,1024);
	print "Received from Client : $data\n";
}

$socket->close();
