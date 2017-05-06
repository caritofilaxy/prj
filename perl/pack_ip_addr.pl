#!/usr/bin/perl
#
$ip = '127.0.0.1';

for (split('\.', $ip)) {
	$res .= pack("C", $_);
	}

print $res;
