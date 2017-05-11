#!/usr/bin/perl -w
#
# createMailboxes.pl
# This script creates special mailboxes (Calendar, Contacts, Notes, Tasks, Junk) in all accounts. 
#
#
# Please mail your comments and suggestions to <support@communigate.com>

use strict;
use CLI;  #get one from www.communigate.com/CGPerl/


####  YOU SHOLD REDEFINE THESE VARIABLES !!!

my $CGServerAddress='127.0.0.1';  #IP or domain name;
my $Login='postmaster';
my $Password='pass';

my %newMailboxes=(
  'Calendar' => { class=>'IPF.Appointment', suffix=>'.mdir' },
  'Contacts' => { class=>'IPF.Contact', suffix=>'.mbox' },
  'Notes' => { class=>'IPF.StickyNote'  },
  'Tasks' => { class=>'IPF.Task'  },
  'Junk'=> {   },
);

# note: suffix can be either .mbox or .mdir (or none for the default mailbox type)

my $logFile='createMailboxes.log';

#### end of the customizeable variables list


my ($nAccounts,$nMailboxes)=(0,0);
my $cli = new CGP::CLI( { PeerAddr => $CGServerAddress,
                          PeerPort => 106,
                          login    => $Login,
                          password => $Password } )
   || die "*** Can't login to CGPro CLI: ".$CGP::ERR_STRING."\n";


#processAccount("user\@company.com");
processDomain("company.com");
#processAllDomains();

$cli->Logout();

print "$nAccounts accounts processed, $nMailboxes new mailboxes created.\n";
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
  myLog("* Domain: $domain");
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
  myLog("** Account: $account");

  
  my $mailboxesList=$cli->ListMailboxes(accountName=>$account);  
  unless($mailboxesList) {
    print "*** Can't list mailboxes for $account:".$cli->getErrMessage."\n";
    return;
  }
  foreach(keys %newMailboxes) {
    my $mailbox=$_;
    unless($mailboxesList->{$mailbox}) {
      my $mailbox2=$mailbox;
      $mailbox2.=$newMailboxes{$mailbox}->{suffix} if($newMailboxes{$mailbox}->{suffix});
      myLog("Creating mailbox $account/$mailbox2");
      unless($cli->CreateMailbox($account,$mailbox2)) {
        myLog("Error: can't create '~$account/$mailbox2' mailbox: ".$cli->getErrMessage);
        return "can't create '$mailbox2' mailbox: ".$cli->getErrMessage;
      }
      $nMailboxes++;
      if($newMailboxes{$mailbox}->{class}) {
        myLog("setting $account/$mailbox class=".$newMailboxes{$mailbox}->{class});
        unless($cli->SetMailboxClass($account,$mailbox,$newMailboxes{$mailbox}->{class})) {
          myLog("Error: can't set mailbox class for '~$account/$mailbox' mailbox: ".$cli->getErrMessage);
          return "can't set mailbox class:".$cli->getErrMessage;
        }
      }  
      
    }
  }
  $nAccounts++;
}

sub myLog {

  my ($data)=@_;
  $data =~ s/[\015\012]//g;
  unless( open(LOG,">>$logFile") ) {
    print "* can't append to $logFile: $!\n";
    return;
  }
 print LOG "$data\n";
 close(LOG);
}


__END__

