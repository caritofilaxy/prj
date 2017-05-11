#!/usr/bin/perl -w
#
# setSettings.pl
# Imports account names and values for RealName attribute and assigns them to accounts. Can be easily modified to import other settings. 
# Usage: ./setSettings.pl import.tx
#
# Please mail your comments and suggestions to <support@communigate.com>

use strict;
use CLI;

####  YOU SHOLD REDEFINE THESE VARIABLES !!!

my $CGServerAddress='127.0.0.1';  #IP or domain name;
my $Login='postmaster';
my $Password='pass';

my $Domain='company.com';
my $theSetting='RealName';

#### end of the customizeable variables list

if(@ARGV != 1) {
  print "Usage: ./setSettings.pl import.txt\n";
  exit(1);
}

print "Started\n";

my $cli = new CGP::CLI( { PeerAddr => $CGServerAddress,
                          PeerPort => 106,
                          login    => $Login,
                          password => $Password } )
   || die "Can't login to CGPro: ".$CGP::ERR_STRING."\n";


while(<>) {
  chomp;
  my ($name,$value)=split(/\t/);
  print "$name\@$Domain: $theSetting:=$value\n";
  $cli->UpdateAccountSettings("$name\@$Domain",{ $theSetting => $value })
    || die "Error: ".$cli->getErrMessage.", quitting"; 
}


$cli->Logout;
print "All done\n";
exit(0); 



__END__


