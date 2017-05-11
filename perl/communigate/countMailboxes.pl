#!/usr/bin/perl -w
#
# countMailboxes.pl
#
# This script prints out the  total number of accounts and mailboxes
#
# Please mail your comments and suggestions to <support@communigate.com>

use strict;
use CLI;  #get one from www.communigate.com/CGPerl/


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

my ($nAccounts,$nMailboxes)=(0,0);

#processDomain("company.com");
processAllDomains();

print "Accounts total: $nAccounts\n";
print "Mailboxes total: $nMailboxes\n";
print "Mailboxes per account: ".$nMailboxes/$nAccounts."\n";

print ".\n";
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
  #print "Domain: $domain\n";
  my $accountList = $cli->ListAccounts($domain);
  unless($accountList) {
    print "*** Can't get accounts for $domain: ".$cli->getErrMessage."\n";
    return;
  }  
  foreach(keys %$accountList) {
    processAccount("$_\@$domain"); 
    $nAccounts++;
  }  
 
}

sub processAccount {
  my $account=$_[0];
#  print "Account: $account\n";

  
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
      $nMailboxes++;
    }
  }  
}

__END__

