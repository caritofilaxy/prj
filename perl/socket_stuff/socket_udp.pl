#!/usr/bin/perl -d

use Socket;
use constant IPPROTO_RAW => 255;

$iaddr = inet_aton ('127.0.0.1');
$paddr = sockaddr_in (53, $iaddr); #80 - порт назначения

socket(SOCKET, PF_INET, SOCK_RAW, IPPROTO_RAW) or die "Can't open raw socket: $!\n";

$packet = undef;
$packet .= pack("C", 69);
$packet .= pack ("H2", '00');
$packet .= pack ("n", 28);
$packet .= pack ("n", 0);
$packet .= pack ("H4", '4000');
$packet .= pack ("C", 64);
$packet .= pack ("C", getprotobyname('udp'));
$packet .= pack ("n", 0);

$source_ip = '127.0.0.1';
$result_source_ip = undef;
for (split('\.', $source_ip)){   #разбиваем по точкам
	$result_source_ip .= pack ("C", $_)
}
$packet .= $result_source_ip;

$destination_ip = '127.0.0.1';
$result_destination_ip = undef;
for (split('\.', $destination_ip)){   #разбиваем по точкам
	$result_destination_ip .= pack ("C", $_)
}
$packet .= $result_destination_ip;

$packet .= pack ("n", 25); #порт источника
$packet .= pack ("n", 53); #порт назначения
$packet .= pack ("n", 8);
$packet .= pack ("H4", '0000');

send(SOCKET, $packet, 0, $paddr) or die "Can't send packet: $!\n";
