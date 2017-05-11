#
# A script to fill a mailbox with messages for test purposes
#
# Please mail your comments and suggestions to <support@communigate.com>

use strict;
use IO::Socket;

####### you should redefine these variables

my $CGServerAddress = "127.0.0.1";   

my $IMAPLogin = "test";
my $IMAPPassword = "test";
my $IMAPMailbox = "INBOX";

my $messageSize=1; # in Kilobytes, approximately
my $nMessages=200000; # number of messages to insert

####### end of customizeable area


my $imap = new IO::Socket::INET(   PeerAddr => $CGServerAddress,
                                    PeerPort => 143
                                  ) 
   || die "*** Can't connect to CGPro via IMAP.\n";                                

$imap->autoflush(1);
my $responseLine = <$imap>;
#print "$responseLine\n";

print $imap "x LOGIN $IMAPLogin $IMAPPassword\015\012";
do {
  $responseLine = <$imap>;
}until($responseLine =~/^x /);
die "*** Can't login to CGPro IMAP: $responseLine.\n" unless($responseLine =~ /^x OK/);
process();

print "Done\n";
print $imap "x LOGOUT\015\012";
exit;

sub process {
  print $imap "x SELECT \"$IMAPMailbox\"\015\012";
  do {
    $responseLine = <$imap>;
  }until($responseLine =~/^x /);
  unless($responseLine =~ /^x OK/) {
    print "*** Can't select $IMAPMailbox: $responseLine.\n";
    return;
  }
  for(my $cnt=1;$cnt<=$nMessages;$cnt++) {
    appendMessage($cnt);
    print ".";
  }
  print "\n";
  print "$nMessages appended\n";
}

sub appendMessage {
  my ($counter)=@_;
  
my $msgData=<<EOT;
From: mailbox filling script
Subject: message #$counter
To: $IMAPLogin
Message-ID: <0000@000>


EOT
  $msgData =~ s/\n/\015\012/g;  
  
  my $destSize=$messageSize*1024;
  
  my $diff=$destSize-length($msgData);
  do {
    $msgData.=("x" x ($diff>80 ? 80 : $diff-4))."\015\012";
    $diff=$destSize-length($msgData);
  }while($diff>2);

  $msgData.="\015\012";
  my $sz=length($msgData);
  
  print $imap "x APPEND \"$IMAPMailbox\" {$sz}\015\012";
  $responseLine = <$imap>;
  unless($responseLine =~ /^+/) {
    die "Imap error: $responseLine";
  }
  print $imap "$msgData";
  print $imap "\015\012";
  do {
    $responseLine = <$imap>;
  }until($responseLine =~/^x /);
  unless($responseLine =~ /^x OK/) {
    die "Imap error: $responseLine";
  }


}

