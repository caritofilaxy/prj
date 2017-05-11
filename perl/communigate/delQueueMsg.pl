#!/usr/bin/perl -w
#
# Deletes a message from Queue by ID.
# Usage: ./delQueueMsg.pl messageID
#
#
# Please mail your comments and suggestions to <support@stalker.com>


use strict;
use CLI; #get one from www.stalker.com/CGPerl/
######  You should redefine some of these values !!!

my $CGProServerAddress =  '127.0.0.1';  
my $CGProLogin = 'postmaster';
my $CGProPassword = 'pass';
#### end of the customizeable variables list

die "Usage: ./delQueueMsg.pl messageID\n" if(@ARGV<1);

my $messageID=$ARGV[0];

print "messageID: $messageID\n";


  my $cli = new CGP::CLI( { PeerAddr => $CGProServerAddress,
                            PeerPort => 106,
                            login    => $CGProLogin,
                            password => $CGProPassword } );
  unless($cli) {
    print "* $CGProLogin can't login to CGPro via CLI: ".$CGP::ERR_STRING."\n";
    exit(0);
  }

unless($cli->RejectQueueMessage($messageID,'NONDN')) {
    print "Error: ".$cli->getErrMessage."\n";
}

$cli->Logout();


__END__

