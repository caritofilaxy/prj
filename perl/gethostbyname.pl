#!/usr/bin/perl

use feature 'say';
my ( $name,   $aliases,  $addrtype,  $length,  @addrs ) = gethostbyname('mail.ru');

say "$name\n$aliases\n$addrtype\n$length\n";
for (@addrs) {
	say join('.',unpack('W4', $_));
	}

