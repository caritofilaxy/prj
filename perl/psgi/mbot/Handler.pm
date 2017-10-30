package Handler;

use strict;
use warnings;

use Net::Ping;
use Socket;

sub check {
    my $text;
    my ($name,$ipaddr,$port) = @_;
    my $p = Net::Ping->new();
    $p->port_number($port);
    my ($srvname,undef,undef,undef) = getservbyport($port, "tcp");
    $text = "service <b>$srvname</b> at $ipaddr:$port is ";
    $text .= $p->ping($ipaddr) ? "alive" : "<b>dead</b>";
    $text .= "<br>";
    $p->close();
    return $text;
}

1;
