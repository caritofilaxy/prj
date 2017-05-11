#!/usr/bin/perl -w
#
#  A sample script for sending instant message using XIMSS protocol
#
#  Usage example:
#  ./sendIM.pl user@domain.com "Hi there!"
#

use strict;
use Socket;

#### you need to redefine these values

my $CGServerAddress='127.0.0.1';  #IP or domain name of your CommuniGate server
my $login='user@domain.com'; # your account name 
my $password='pass';         # your password
my $port = 11024;
my $debug=0;
#### end of the customizeable variables list


unless(@ARGV == 2) {
  print 'Usage: ./sendIM.pl user@domain.tld "message text"'."\n";
  exit(1);
}
my $destinationURI=$ARGV[0]; # to whom you send 
my $messageText=$ARGV[1]; 



XIMSS_Connect($CGServerAddress,$port);

sendCommand( qq{<login id="A01" authData="$login" password="$password"/>} );
readResponse();
sendCommand( qq{<sendIM id="A02" peer="$destinationURI">$messageText</sendIM>} );
readResponse();
sendCommand( qq{<bye id="A03"/>} );
readResponse();

XIMSS_Disconnect();
exit(0);



#### subroutines ####################################

sub XIMSS_Connect {
  my ($address,$port)=@_;
  $port=11024 unless($port);
  
  my $iaddr   = inet_aton($address);
  unless($iaddr) {
    die "no host: $address";
  }  
  my $paddr   = sockaddr_in($port, $iaddr);

  my $proto   = getprotobyname('tcp');
  unless(socket(SOCK, PF_INET, SOCK_STREAM, $proto)) {
    die "socket error: $!";
  }  
  unless(connect(SOCK, $paddr)) {
    die "connect error: $!";
  }
  undef;
}

sub XIMSS_Disconnect {
  close (SOCK) || die "close: $!";
}

sub sendCommand {
  my ($command)=@_;
  print "s: $command\n" if($debug);
  send(SOCK,$command ."\0",0);
}

sub readResponse {
  while(my $line = readLine()) {
    print "r: $line\n" if($debug);
    if($line =~ /error/ ) { 
      print "e: $line\n";
      die; # no disconnect at error
    }
    if($line =~ /^<response id=/ ) { 
      return;
    }
  }
}

sub readLine {
  my $ln='';
  for(;;) {
    my $ch;
    recv(SOCK,$ch,1,0);
    last if($ch eq "\0");
    $ln.=$ch;
  }
  return $ln;
}

