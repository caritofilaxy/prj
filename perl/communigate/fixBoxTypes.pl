#!/usr/bin/perl -w
#
# fixBoxTypes.pl
#
# Fixes mailbox types for special mailboxes such as Contacts, Calendar and Notes for
# the case if they were created without Class attribute or lost one
# 
# Please mail your comments and suggestions to <support@communigate.com>

use strict;
use CLI;  #get one from www.stalker.com/CGPerl


####  YOU SHOLD REDEFINE THESE VARIABLES !!!

my $CGServerAddress='127.0.0.1';  #IP or domain name;
my $Login='postmaster';
my $Password='pass';


my %fixBoxesList=(
  Contacts => 'IPF.Contact',
  Calendar => 'IPF.Appointment',
  Notes => 'IPF.StickyNote',
);
#### end of the customizeable variables list


my $cli = new CGP::CLI( { PeerAddr => $CGServerAddress,
                          PeerPort => 106,
                          login    => $Login,
                          password => $Password } )
   || die "*** Can't login to CGPro CLI: ".$CGP::ERR_STRING."\n";


# un-comment one of the below 4 lines

#processAccount('user@company.com');
#processDomain('company.com');
processAllDomains();

print "Done\n";
$cli->Logout();
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
  my $mboxTypeSwitch=0;
  print "Account: $account\n";

  my $mailboxesList=$cli->ListMailboxes(accountName=>$account);  
  unless($mailboxesList) {
    print "*** Can't list mailboxes for $account:".$cli->getErrMessage."\n";
    return;
  }
  
  foreach(sort keys %$mailboxesList) {
    my $data=@$mailboxesList{$_};
    if(ref $data eq 'ARRAY') {
      $data=@$data[0];
    }   
    if(ref $data eq 'HASH') {
      my $mailbox=$_;
      if(exists($fixBoxesList{$mailbox})) {
        my $oldClass=@$data{'Class'};
        if(!$oldClass) {
          my $newClass=$fixBoxesList{$mailbox};
          unless($cli->SetMailboxClass($account,$mailbox,$newClass)) {
            print "*** Can't set $newClass class to $mailbox#$account:".$cli->getErrMessage."\n";
          } else {
            print "updating $mailbox#$account to $newClass\n";
          }
        }  
      }
    }  
  }  
  

}




__END__;
