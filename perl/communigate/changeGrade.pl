#!/usr/bin/perl -w
#
# changeGrade.pl
# Usage: ./changeGrade.pl account_list.txt
#
# Please mail your comments and suggestions to <support@communigate.com>


use strict;
use CLI;  #get one from www.communigate.com/CGPerl/


####  YOU SHOLD REDEFINE THESE VARIABLES !!!

my $CGServerAddress='127.0.0.1';  #IP or domain name;
my $Login='postmaster';
my $Password='pass';

my $destGrade='AGrade'; #A-grade

#### end of the customizeable variables list



if(@ARGV != 1) {
  die "Usage: ./changeGrade.pl account_list.txt\n";
}

my $cli = new CGP::CLI( { PeerAddr => $CGServerAddress,
                          PeerPort => 106,
                          login    => $Login,
                          password => $Password } )
   || die "*** Can't login to CGPro CLI: ".$CGP::ERR_STRING."\n";


print "Reading $ARGV[0]\n";

  while(<>) {
    chomp;
    next if(/^#/);
    my $account=$_;
    if(length($account)>3) {
      processAccount($account);
    }
  }

print "Done\n";
$cli->Logout();
exit;

sub processAccount {
  my $account=$_[0];
  print "Account: $account\n";
  unless($cli->SetAccountType($account,$destGrade)) {
    print "*** Can't set grade for $account:".$cli->getErrMessage."\n";
    return;
  }
}

__END__
