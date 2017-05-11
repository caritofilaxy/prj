#!/usr/bin/perl -w
#
# listActive.pl
#
# Prints out active account names (who had logged in recently)
#
# Please mail your comments and suggestions to <support@communigate.com>


####  YOU SHOLD REDEFINE THESE VARIABLES !!!

my $InactivityDays = 60;    
my $Domain = 'company.com'; # The domain where to check accounts

my $CGServerAddress='127.0.0.1';  #IP or domain name;
my $Login='postmaster';
my $Password='pass';


#### end of the customizeable variables list


use CLI;  #get one from www.stalker.com/CGPerl
use POSIX qw(mktime);
use strict;


# Open TCP connection to given address port 106 (PWD, or CGPro CLI).
# Submit username and password. If login fail, the program will stop.
my $cli = new CGP::CLI( { PeerAddr => $CGServerAddress,
                          PeerPort => 106,
                          login    => $Login,
                          password => $Password } )
   || die "Can't login to CGPro: ".$CGP::ERR_STRING."\n";



my $deadline = time() - $InactivityDays*(24*60*60);   # the last day (in seconds)
my ($nTotal,$nActive) = (0,0);

my $Accounts=$cli->ListAccounts($Domain)
                   || die "Error: ".$cli->getErrMessage.", quitting";
foreach my $UserName (sort keys %$Accounts) {
  my $creationTime=0;
  my $lastLoginTime=0;

  if(my $Date=$cli->GetAccountInfo("$UserName\@$Domain",'Created')) {
    $creationTime=ConvTime($Date);
  } else {
    die "Error: ".$cli->getErrMessage.", quitting" unless($cli->isSuccess);
  }  
  if(my $Date=$cli->GetAccountInfo("$UserName\@$Domain",'LastLogin')) {
    $lastLoginTime=ConvTime($Date);
  } else {
    die "Error: ".$cli->getErrMessage.", quitting" unless($cli->isSuccess);
  }
  if(($lastLoginTime==0 && $creationTime==0) ||
     ($lastLoginTime<$deadline && $creationTime<$deadline) ) {
   #inactive
  } else {
    print "$UserName\@$Domain is active\n";
    ++$nActive; 
  }
  ++$nTotal;
}
  print " $nTotal accounts total, $nActive active\n";

$cli->Logout;

# ConvTime(string)
# This procedure converts CGPro textual date/time string into UNIX format
# (the number of seconds since 00:00:00 UTC, January 1, 1970).

sub ConvTime {
  my ($sec,$min,$hour,$mday,$month,$year);
  my %mNames=qw(Jan 0 Feb 1 Mar 2 Apr 3 May 4 Jun 5
                Jul 6 Aug 7 Sep 8 Oct 9 Nov 10 Dec 11);
  if($_[0] =~ /^(\d{1,2}).(\w\w\w).(\d\d\d\d).(\d\d):(\d\d):(\d\d)/) {
    $mday=$1;
    $month=$mNames{$2};
    $year=$3-1900;
    $hour=$4;
    $min=$5;
    $sec=$6;
  } elsif($_[0] =~ /(\d\d)-(\d\d)-(\d\d\d\d).(\d\d):(\d\d):(\d\d)/) {
    $mday=$1;
    $month=$2-1;
    $year=$3-1900;
    $hour=$4;
    $min=$5;
    $sec=$6;
  } elsif($_[0] =~ /^T#(\d\d)-(\d\d)-(\d\d\d\d)_(\d\d):(\d\d):(\d\d)/) {
    $mday=$1;
    $month=$2-1;
    $year=$3-1900;
    $hour=$4;
    $min=$5;
    $sec=$6;
  } elsif($_[0] =~ /(\d{1,2}).(\w\w\w).(\d\d\d\d).(\d\d):(\d\d):(\d\d)/) {
    $mday=$1;
    $month=$mNames{$2};
    $year=$3-1900;
    $hour=$4;
    $min=$5;
    $sec=$6;
  } else {
   die "Unknown date format: \"$_[0]\", quitting";
  }
  return POSIX::mktime($sec,$min,$hour,$mday,$month,$year);
}
