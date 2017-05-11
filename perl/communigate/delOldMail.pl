#!/usr/bin/perl -w
#
# The old mail deletion script for CommuniGate Pro.
#
# This script deletes all mail older than the number of days specified below
# in $keepForDays variable. The time is compared against messages' INTERNALDATE
# attribute which may be not the same as the date when the message was received,
# so don't get confused if after the deletion you see messages older than expected.
# 
# The mail is deleted from all mailboxes in all accounts in all domains,
# including mailing list archives. Mail marked for deletion by users is also
# deleted. You may want to modify this script to process not all but only certain 
# domains or accounts. Use this script with extreme care becasue mail once deleted
# is not recoverable.
# 
# Please mail your comments and suggestions to <support@communigate.com>
#
# updated 20-Nov-2008
# updated  4-Feb-2015

my $keepForDays = 30;

use CLI;

my $deadlineDate=getDeadlineDate();

print "\nWARNING!!!\n";
print "This script will delete messages received before $deadlineDate from all\n";
print "mailboxes in all acounts in all domains. Make sure you know what you're\n";
print "doing. It's not too late to hit Ctrl-C.\n\n";

print "CommuniGate Pro domain: ";       
my $Domain = <STDIN>;    
chomp $Domain;           


$CGServerAddress = $Domain;

my $Login = "Postmaster\@$Domain";

print "Postmaster's password: ";
my $Password = <STDIN>;
chomp $Password;


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




#processAccount('test@company.com');
#processAllDomains();
processMailbox('user@domain/mailbox'); # %%% change the obvious here

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
  my $mailboxesList=$cli->ListMailboxes(accountName=>$account);  
  unless($mailboxesList) {
    print "*** Can't list mailboxes for $account:".$cli->getErrMessage."\n";
    return;
  }
  foreach(keys %$mailboxesList) {
    my $data=@$mailboxesList{$_};
    if(ref $data eq 'ARRAY') {
      $data=@$data[0];
    }   
    if(ref $data eq 'HASH') {
      my $nMessages=@$data{'Messages'};
      if(defined $nMessages && $nMessages eq 0) {
         #print "skipping empty $account/$_\n";
        next;
      }
      my $class=@$data{'Class'};
      if(defined $class) {  # skip Contacts
        if($class eq 'IPF.Contact') {
          #print "skipping Contacts: $account/$_\n";
          next;
        }
      }
      processMailbox("$account/$_"); 

    }
  }  
}

sub processMailbox {  
  my $mailbox=$_[0];
  my $delList = "";
  #print "Mailbox: $mailbox\n";
  
  print $imap "x SELECT \"~$mailbox\"\015\012";
  do {
    $responseLine = <$imap>;
  }until($responseLine =~/^x /);
  unless($responseLine =~ /^x OK/) {
    print "*** Can't select $mailbox: $responseLine.\n";
    return;
  }
  print $imap "x SEARCH BEFORE $deadlineDate UNDELETED\015\012";
  my @msgList;
  
  do {
    $responseLine = <$imap>;
    if($responseLine =~ /^\* SEARCH (.+)/) {
#    print $responseLine;
      push(@msgList,split(/ /,$1));
    }
  }until($responseLine =~/^x /);

  if(@msgList) {
    print "Mailbox: $mailbox\n";
    @msgList=sort {$a <=> $b} @msgList;
    my $delList="";

    for(my $idx=0;$idx<scalar(@msgList);$idx++) {
      if($delList) { $delList.=','; }
      if($idx+2<scalar(@msgList) && $msgList[$idx]+1==$msgList[$idx+1] && $msgList[$idx]+2==$msgList[$idx+2]) {
        my $idx2=$idx+2;
        $idx2++ while($idx2+1<scalar(@msgList) && $msgList[$idx2]+1==$msgList[$idx2+1]);
        $delList.=$msgList[$idx].":".$msgList[$idx2];
        $idx=$idx2;
      } else {
        $delList.=$msgList[$idx];
      }
    }
    #print "deletion list=$delList\n";     

    #print "deleting\n";
    print $imap "s STORE $delList +FLAGS (\\Deleted)\015\012";
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

sub getDeadlineDate {
  my @mNames=qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
  my $deadlineTime=time()-$keepForDays*24*60*60;
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =  gmtime($deadlineTime);
  return $mday.'-'.$mNames[$mon].'-'.(1900+$year);
}
__END__
