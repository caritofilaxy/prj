#!/usr/bin/perl

use Net::RawIP;
 
$n = Net::RawIP->new({
                      ip  => {
                              saddr => 'localhost',
                              daddr => 'localhost',
                             },
                     
                      tcp => {
                              source => 13933,
                              dest   => 80,
                              psh    => 1,
                              syn    => 1,
                             },
                     });
$n->send;
$n->ethnew("eth0");
$n->ethset(source => 'localhost', dest =>'localhost');    
$n->ethsend;
$p = $n->pcapinit("lo", "dst port 80", 1500, 30);
$f = dump_open($p, "/my/home/log");
loop($p, 10, \&dump, $f);
