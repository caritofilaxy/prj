#!/usr/bin/perl

use strict;
use warnings;
use Socket;
use Net::Ping;

my %targets = (
        sl_site => [ qw(http smtp pop3 imap) ],
        dkl => [ qw(smtp pop3 https) ],
        dkl_bb => [ qw(smtp pop3 https) ],
);

print "<table border>";
my $p = Net::Ping->new();
for my $host (keys %targets) {
	for my $svc (@{$targets{$key}}) {
		print "<tr><th>$host</th><th>$port</th><th>
		$p->port_number(get
	}
}
