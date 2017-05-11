#!/usr/bin/perl -w

#
# SweepMailboxes.pl
#
# The junk/virus mail deletion script for CommuniGate Pro.
# version 1.1 / Jan 21, 2005 
# version 1.2 / Dec 17, 2007 
#
# This script deletes mail whose raw text matches the specified pattern(s) from
# users' mailboxes. This may be useful when a virus had contaminated your
# accounts, or when you mailed to all@ address something by mistake.
#
# As a search pattern for a virus take a line of base64 code from the attachment
# area of the virus message text, there's a very high chance that such pattern
# will be unique for the virus and won't match legal attachments. Note that some
# viruses are polymorph so you will need to use several patterns from different
# instances of the virus message.
#
# By default the matching mail is deleted from all mailboxes in all accounts
# in all domains, including mailing list archives. Mail marked for deletion by
# users is also deleted. You may want to modify the script to process not all but
# only certain domains or accounts. Also, in order to improve performance, you
# may want to check INBOX mailboxes only.

# Use this script with extreme care becasue mail once deleted
# is not recoverable.
# 
# Please mail your comments and suggestions to <support@stalker.com>
#

use strict;
use CLI;  #get one from www.stalker.com/CGPerl


####  YOU SHOLD REDEFINE THESE VARIABLES !!!

my $CGServerAddress='10.0.0.1';  #IP or domain name;
my $Login='postmaster';
my $Password='pass';

my $InboxOnly=0; # change to 1 to scan INBOXes only 


# Note: The patterns are Perl's regular expressions, so all special 
# characters you check for such as +-()[]{}\.^$@| need to be prefixed with "\".

my @SearchPatterns=(
 '===== delete me !!! ===',
 '^X-SpamCatcher-Score: .* \[XXXXX.*$',
 '^ZGUuDQ0KJAAAAAAAAAB\+i6hSOurGATrqxgE66sYBQfbKATvqxgG59sgBLerGAdL1zAEA6sYBWPXV$', #W32/Gibe-F
 '^AAAA4AAAAA4fug4AtAnNIbgBTM0hVGhpcyBwcm9ncmFtIGNhbm5vdCBiZSBydW4gaW4gRE9TIG1v$',  #W32/Sobig.f@MM
 '^JAyL6IsEJAPFiUQkEIsdUORBAOtRizuLcwg77ndGi8YDQww7RCQQdzs7dCQIcwSJdCQIi8YD$',      #W32/SirCam@MM
);

#### end of the customizeable variables list


my $imap = new IO::Socket::INET(   PeerAddr => $CGServerAddress,
                                    PeerPort => 143
                                  ) 
   || die "*** Can't connect to CGPro via IMAP.\n";                                

$imap->autoflush(1);
my $responseLine = <$imap>;
#print "$responseLine\n";

print $imap "x LOGIN $Login $Password\015\012";
do {
  $responseLine = <$imap>;
}until($responseLine =~/^x /);
die "*** Can't login to CGPro IMAP: $responseLine.\n" unless($responseLine =~ /^x OK/);

my $cli = new CGP::CLI( { PeerAddr => $CGServerAddress,
                          PeerPort => 106,
                          login    => $Login,
                          password => $Password } )
   || die "*** Can't login to CGPro CLI: ".$CGP::ERR_STRING."\n";



#processAccount('user@company.com');
#processDomain('company.com');
processAllDomains();

print "Done\n";
$cli->Logout();
print $imap "x LOGOUT\015\012";
exit;


sub processAllDomains {
  my $DomainList = $cli->ListDomains()
               || die "*** Can't get the domain list: ".$cli->getErrMessage.", quitting";
  foreach(@$DomainList) {
    processDomain($_);
  }
}         

sub processDomain {
  my $domain=$_[0];
  print "Domain: $domain\n";
  my $accountList = $cli->ListAccounts($domain);
  unless($accountList) {
    print "*** Can't get accounts for $domain: ".$cli->getErrMessage."\n";
    return;
  }  
  foreach(keys %$accountList) {
    processAccount("$_\@$domain"); 
  }  
}

sub processAccount {
  my $account=$_[0];
  #print "Account: $account\n";

  if($InboxOnly) {
    processMailbox("$account/INBOX");
    return; 
  }
  
  my $mailboxesList=$cli->ListMailboxes(accountName=>$account);  
  unless($mailboxesList) {
    print "*** Can't list mailboxes for $account:".$cli->getErrMessage."\n";
    return;
  }
  foreach(keys %$mailboxesList) {
    my $data=@$mailboxesList{$_};
    if(ref $data eq 'HASH') {
      my $nMessages=@$data{'Messages'};
      if(defined $nMessages && $nMessages eq 0) {
        #print "skipping empty $account/$_\n";
        next;
      }
      processMailbox("$account/$_"); 
    }
  }  
}

sub processMailbox {  
  my $mailbox=$_[0];
  my $nMessages=0;
  my @delList;
  #print "Mailbox: $mailbox\n";
  
  print $imap "x SELECT \"~$mailbox\"\015\012";
  do {
    $responseLine = <$imap>;
    if($responseLine =~ /^\* (\d*) EXISTS/) {
      $nMessages=$1;
    }
  }until($responseLine =~/^x /);
  unless($responseLine =~ /^x OK/) {
    print "*** Can't select $mailbox: $responseLine.\n";
    return;
  }
  if($nMessages <= 0) {
    return;
  }

  for(my $xMsg=1;$xMsg<=$nMessages;$xMsg++) {
    if(checkMessage($xMsg)) {
      push(@delList,$xMsg);
    }
  }

  if(@delList >0) {
    print "Mailbox: $mailbox (". scalar(@delList)." messages to delete)\n";
    #print "deletion list=$delList\n";



    #print "deleting\n";
    print $imap "s STORE ".join(',',@delList)." +FLAGS (\\Deleted)\015\012";

    do {
      $responseLine = <$imap>;
    }until($responseLine =~/^s /);
    unless($responseLine =~ /^s OK/) {
      print "*** Can't store flags for $mailbox messages: $responseLine.\n";
    }


    print $imap "c CLOSE\015\012";
    do {
      $responseLine = <$imap>;
    }until($responseLine =~/^c /);
    unless($responseLine =~ /^c OK/) {
      print "*** Can't close $mailbox: $responseLine.\n";
    }
  }
  
}

sub checkMessage {
  my $msgID=$_[0];
  my $msgText;
  print $imap "f FETCH $msgID (RFC822.PEEK)\015\012";
  do {
    $responseLine = <$imap>;
    if($responseLine =~ /^\* .+ FETCH .+ {(\d+)}/) {
      my $msgSize=$1;
      while($msgSize>0) {
        $responseLine = <$imap>;
        $msgSize-=length($responseLine);
        local $/="\r\n";
        chomp($responseLine);
        $msgText .= $responseLine."\n";
      }
      $responseLine = <$imap>;
    }
  }until($responseLine =~/^f /);
  unless($responseLine =~ /^f OK/) {
    print "*** Can't fetch msg $msgID: $responseLine.\n";
  }

  foreach(@SearchPatterns) {
    my $pattern=$_;
    if($msgText =~ /$pattern/m) {
      return 1;
    }
  }
  0;  
}

__END__;
