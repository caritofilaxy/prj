#!/usr/bin/perl -w
#
# countAccounts.pl
#
# This script prints out the total number of accounts and the numbers of different grades
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

my %translate = (
  macnt => 'no-Grade',
  aacnt => 'A-Grade',
  bacnt => 'B-Grade',
  cacnt => 'C-Grade',
);
my %counters;
my $nTotal=0;

processAllDomains();

print "Accounts total: $nTotal\n";
foreach(sort keys %counters) {
  next if(/total/);
  my $n=$counters{$_};
  my $name=$translate{$_} || $_;
  print "$name: $n\n";
}


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
  print "Domain: $domain\n";
  my $accountList = $cli->ListAccounts($domain);
  unless($accountList) {
    print "*** Can't get accounts for $domain: ".$cli->getErrMessage."\n";
    return;
  }  
  foreach(values %$accountList) {
    if($counters{$_}) {
      $counters{$_}++;
    } else {
      $counters{$_}=1;
    }
    $nTotal++;
  }  
 
}


__END__;
