package Handler;

use strict;
use warnings;

use Net::Ping;
use Socket;

sub srv_avail_table {
	my (%targets) = @_;
	my $text = "<table border>";
	$text .= "<tr><th>host</th><th>service</th><th>status</th></tr>";
    my $p = Net::Ping->new();
	for my $host (keys %targets) {
		for my $port (@{$targets{$host}}) {
			$p->port_number($port);
			my ($srv,undef,undef,undef) = getservbyport($port,"tcp");
	    	$text .= "<tr><th>$host</th><th>$srv</th><th>";
    		$text .= $p->ping($host) ? "alive" : "<b>dead</b>";
    		$text .= "</th><tr>";
		}
	}
	$p->close();
	$text .= "</table>";
	return $text;
}
		
1;
