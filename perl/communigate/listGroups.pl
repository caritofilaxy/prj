#!/usr/bin/perl -w
#
# listGroups.pl
# Please mail your comments and suggestions to <support@communigate.com>

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


# un-comment one of the below 2 lines

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
  my $groupList = $cli->ListGroups($domain);
  unless($groupList) {
    print "*** Can't get groups for $domain: ".$cli->getErrMessage."\n";
    return;
  }  
  foreach(@$groupList) {
    processGroup("$_\@$domain"); 
  }  
}

sub processGroup {
  my $name=$_[0];

  print "Group: $name";
  my $settings=$cli->GetGroup($name);
  unless($settings) {
    print "*** GetGroup failed for $name:".$cli->getErrMessage."\n";
    return;
  }
  my $members=$settings->{Members};
  my $realName=$settings->{RealName};
  print "  ($realName)" if($realName);
  print "  Members: ".join(",",@$members)."\n";
}


__END__;
