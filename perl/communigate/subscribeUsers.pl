#!/usr/bin/perl -w
#
# subscribeUsers.pl
# Subscribes users to a shared mailbox via adding everyone a mailbox alias. 
#
# Please mail your comments and suggestions to <support@communigate.com>


use CLI;  # get one from www.stalker.com/CGPerl
use strict;


######  You should redefine some of these values !!!

my $CGServerAddress = "127.0.0.1";   
my $Login = "Postmaster";
my $Password = "pass";

my $aliasName='SharedContacts';
my $target='~public@s-m-c.ru/CONTACTS-S-M-C';

#### end of the customizeable variables list


my $cli = new CGP::CLI( { PeerAddr => $CGServerAddress,
                          PeerPort => 106,
                          login    => $Login,
                          password => $Password } )
   || die "*** Can't login to CGPro CLI: ".$CGP::ERR_STRING."\n";

#processAllDomains();
#processDomain('company.com');
processAccount('user@company.com');


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
#  print "Account: $accountn";
  my $data=$cli->GetMailboxAliases($account);
  unless($data) {
    print "*** Can't get aliases for $account: ".$cli->getErrMessage."\n";
    return;
  }
  $data->{$aliasName}=$target;
  $cli->SetMailboxAliases($account,$data);
}
__END__


