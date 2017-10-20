#!/usr/bin/perl
 
use strict;
use warnings;
use Socket;
 
main();
  
sub main 
{
   # my $sock;
   # # when IPPROTO_RAW is used IP_HDRINCL is not needed
   # my $IPROTO_RAW = 255;
   # socket($sock , AF_INET, SOCK_RAW, $IPROTO_RAW) 
   #     or die $!;
   #  
    my ($packet) = pack('H80', '450000284b2d4000190618a17f0000017f0000015ba0005000003490000000005002007c20b8002c');

     print $packet;
     
        #send($sock , $packet , 0)
}
 
