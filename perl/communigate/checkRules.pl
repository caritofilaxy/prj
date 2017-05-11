#!/usr/bin/perl -w
#
# checkRules.pl
# Prints out names of accounts who have redirection rules. 
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



processAllDomains();
#processDomain('company.com');
#processAccount('test');



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
#  print "Account: $account\n";
  my $Rules=$cli->GetAccountMailRules($account);
  unless($Rules) {
    print "*** Can't get rules for $account:".$cli->getErrMessage."\n";
    return;
  }
      foreach my $Rule (@$Rules) {
        my $Priority=$Rule->[0];
        #next unless($Priority);
        my $actions=$Rule->[3];

        foreach my $actn (@$actions) {
          my $a=$actn->[0];
          if($a=~/Forward to|Redirect to|Mirror to/) {
            print "$account: '$a' -> $actn->[1]\n";
          } 
          if($a=~/Discard/) {
            print "$account: Discard\n";
          }

        }
      }


 }


__END__
