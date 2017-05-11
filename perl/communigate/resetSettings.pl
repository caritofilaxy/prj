#!/usr/bin/perl -w
#
# resetSettings.pl
#
# This script resets AccessModes setting to default. 
# Can be easily modified to reset other settings. 
#
# Please mail your comments and suggestions to <support@communigate.com>

use strict;
use CLI;  #get one from www.stalker.com/CGPerl


####  YOU SHOLD REDEFINE THESE VARIABLES !!!

my $CGServerAddress='127.0.0.1';  #IP or domain name;
my $Login='postmaster';
my $Password='pass';

my $domain='company.com';


#### end of the customizeable variables list


my $cli = new CGP::CLI( { PeerAddr => $CGServerAddress,
                          PeerPort => 106,
                          login    => $Login,
                          password => $Password } )
   || die "*** Can't login to CGPro CLI: ".$CGP::ERR_STRING."\n";


#processAccount("user\@company.com");
processDomain($domain);
#processAllDomains();

$cli->Logout();

print "Done.\n";
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
  unless($cli->UpdateAccountSettings($account,{AccessModes=>'Default'})) {
    print "*** Can't update settings for $account:".$cli->getErrMessage."\n";
    return;
  }
}



__END__

