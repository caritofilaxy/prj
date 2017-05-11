#!/usr/bin/perl -w
#
# getRPOP.pl
#
# Reads the RPOP records of users and exports the data into a .CSV file for viewing in Excel
#
# Please mail your comments and suggestions to <support@communigate.com>

use CLI;  # get one from www.stalker.com/CGPerl
use strict;

######  You should redefine some of these values !!!

my $CGServerAddress = "127.0.0.1";   #IP or domain name
my $Login = "postmaster";
my $Password = "pass";
my $outFileName = "rpops.csv"; # text file for importing into Excel

#### end of the customizeable variables list

   
my $cli = new CGP::CLI( { PeerAddr => $CGServerAddress,
                          PeerPort => 106,
                          login    => $Login,
                          password => $Password } )
   || die "*** Can't login to CGPro CLI: ".$CGP::ERR_STRING."\n";

open(FILE,">$outFileName") || die "Can't create $outFileName: $!";
print FILE "Account;Record ID;Poll at;Period;APOP;TLS;Leave\n";

######### Uncomment one of these lines:

processAllDomains();
#processDomain("company.com");

###################################


close(FILE);
$cli->Logout();
print "Done, see $outFileName file\n";
exit(0);





sub processAllDomains {
  my $DomainList = $cli->ListDomains()
               || die "*** Can't get the domain list: ".$cli->getErrMessage.", quitting";
  foreach(@$DomainList) {
    processDomain($_);
  }
}         

sub processDomain {
  my $domain=$_[0];
#  print "Domain: $domain\n";

  my $cookie="";
  do {
    my $data=$cli->ListDomainObjects($domain,5000,undef,'ACCOUNTS',$cookie);
    unless($data) {
      print "*** Can't get accounts for $domain: ".$cli->getErrMessage."\n";
      return;
    }
    $cookie=$data->[4];
    foreach(keys %{$data->[1]} ) {
      processAccount("$_\@$domain"); 
    }
  }while($cookie ne '');
 
}


sub processAccount {
  my ($account)=@_;
#  print "Account: $account\n";
  my $rpops=$cli->GetAccountRPOPs($account);
  unless($rpops) {
    print "*** Can't get RPOP records for $account: ".$cli->getErrMessage."\n";
    return;
  }

  foreach(keys %$rpops) {
    my $acc=($rpops->{$_}->{authName} || "?").'@'.($rpops->{$_}->{domain} || "?");
    my $period=$rpops->{$_}->{period} || "?";
    my $apop=$rpops->{$_}->{APOP} || "";
    my $tls=$rpops->{$_}->{TLS} || "";
    my $leave=$rpops->{$_}->{leave} || "";
    print FILE "$account;$_;$acc;$period;$apop;$tls;$leave;";
  }


  
 
}  
__END__  