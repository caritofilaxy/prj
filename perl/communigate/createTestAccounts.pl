#!/usr/bin/perl -w
#
# createTestAccounts.pl
# Creates (or deletes) a number of accounts in a test domain.  
# 
# Please mail your comments and suggestions to <support@communigate.com>

use strict;
use CLI;

####  YOU SHOLD REDEFINE THESE VARIABLES !!!

my $CGServerAddress='127.0.0.1';  #IP or domain name;
my $AdminLogin='postmaster';
my $AdminPassword='pass';

my $Domain='test.dom';
my $isClustered=0; # 0-regular, 1-clustered

my $deleteAccounts=0; # 0-create, 1-delete
my $accountNamePrefix='test';
my $accountNum=100; #will create/delete test1-test100 accounts

my $accountPassword='test';

#### end of the customizeable variables list


print "Started\n";

my $cli = new CGP::CLI( { PeerAddr => $CGServerAddress,
                          PeerPort => 106,
                          login    => $AdminLogin,
                          password => $AdminPassword } )
   || die "Can't login to CGPro: ".$CGP::ERR_STRING."\n";


unless($deleteAccounts) {
  if($isClustered) {
    $cli->CreateSharedDomain($Domain); #ignore errors
  } else {
    $cli->CreateDomain($Domain);
  }
}

for(my $idx=1;$idx<=$accountNum;$idx++) {
  my $account="$accountNamePrefix$idx\@$Domain";
  if($deleteAccounts) {
    $cli->DeleteAccount($account);
  } else {
    $cli->CreateAccount(accountName=>$account,settings=>{Password=>$accountPassword});
  }
}

$cli->Logout;
print "All done\n";
exit(0); 



