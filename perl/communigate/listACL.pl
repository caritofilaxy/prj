#!/usr/bin/perl -w
#
# listACL.pl.pl
#
# version 1.0 Sun, 12 Oct 2008
#
# Please mail your comments and suggestions to <support@communigate.com>
#

use strict;
use CLI;  #get one from www.stalker.com/CGPerl


####  YOU SHOLD REDEFINE THESE VARIABLES !!!

my $CGServerAddress='127.0.0.1';  #IP or domain name;
my $Login='postmaster';
my $Password='pass';

#### end of the customizeable variables list


my $cli = new CGP::CLI( { PeerAddr => $CGServerAddress,
                          PeerPort => 106,
                          login    => $Login,
                          password => $Password } )
   || die "*** Can't login to CGPro CLI: ".$CGP::ERR_STRING."\n";


# un-comment one of the below 3 lines

#processAccount('user@company.com');
#processDomain('company.com');
processAllDomains();

$cli->Logout();


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
  print "  Account: $account\n";
  my $mailboxesList=$cli->ListMailboxes(accountName=>$account);  
  unless($mailboxesList) {
    print "*** Can't list mailboxes for $account:".$cli->getErrMessage."\n";
    return;
  }

  foreach(sort keys %$mailboxesList) {
    my $data=@$mailboxesList{$_};
    my $mailbox=$_;
    my @acl;
    if(ref $data eq 'ARRAY') {
      $data=@$data[0];
    }   
    if(ref $data eq 'HASH') {
      my $mailbox=$_;
      my $ACLs=@$data{'Access'};
      if($ACLs) {
        #print "    Mailbox: $mailbox\n";
        foreach(keys %$ACLs) {
          push(@acl,"$_ = $ACLs->{$_}");
        }
      }  
    }
    if(@acl) {
      print "    Mailbox '$mailbox' ACL:\n";
      print "      $_\n" foreach(@acl); 
    }
  }  

  my $Subscription= $cli->GetAccountSubscription($account);
  unless($Subscription) {
    print "*** Can't get subscription for $account:".$cli->getErrMessage."\n";
    return;
  }
  my @subscr;
  foreach(@$Subscription) {
    push(@subscr,$_) if(/^~/);
  }
  if(@subscr) {
    print "    Subscription:\n";
    print "      $_\n" foreach(@subscr); 
  }
  
  my $aliasesList=$cli->GetMailboxAliases($account);
  if($aliasesList) {
    my @aliases;
    foreach(keys %$aliasesList) {
      push(@aliases,"$_ = $aliasesList->{$_}") if($aliasesList->{$_}=~/^~/);
    }  
    if(@aliases) {
      print "    Foreign aliases:\n";
      print "      $_\n" foreach(@aliases); 
    }
  }


}



__END__;
