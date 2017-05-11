#!/usr/bin/perl -w
#
# listGrades.pl
#
# Please mail your comments and suggestions to <support@communigate.com>

use CLI;  # get one from www.stalker.com/CGPerl
use strict;


######  You should redefine some of these values !!!

my $CGServerAddress = "127.0.0.1";   
my $Login = "Postmaster";
my $Password = "pass";


#### end of the customizeable variables list


my $cli = new CGP::CLI( { PeerAddr => $CGServerAddress,
                          PeerPort => 106,
                          login    => $Login,
                          password => $Password } )
   || die "*** Can't login to CGPro CLI: ".$CGP::ERR_STRING."\n";

processAllDomains();
#processDomain('company.com');

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
  my $Domain=$_[0];
  my $isOK=0;

#print "Domain: $Domain\n";

  my $AccountList = $cli->ListAccounts($Domain) || die "Error: ".$cli->getErrMessage.", quitting";
  foreach(keys %$AccountList) {
    my $account=$_;
    my $gr=$AccountList->{$account};
    if($gr=~/^(.)acnt/) {
      if($1 eq 'm') {
      } else {
        print "$account\@$Domain - ".uc($1)."-grade\n";
      }
    } else {
      #print "Account $account\@$Domain has invalid type: $gr\n";
    }
  }
}



__END__


