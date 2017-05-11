#!/usr/bin/perl -w

=head1 NAME

RosterGroup.pl
 v1.0  7-Jul-2013

=head1 DESCRIPTION

A script for managing Roster groups in CommuniGate Pro mail server.

The script is launched from command line as:
  perl RosterGroup.pl accounts.txt

where accounts.txt should contain the following data:
1st line: group name; other lines: group member addresses, one per
line. The deleted group members are prefixed with '#'

The script will add all listed group members to the Rosters of each
current group member unless they're already there; will delete the
deleted group members from current group members and current group
members from deleted group members' Rosters.

Example of the input file with 3 current and 1 deleted member:
------
Our Company's Group
sales@company.com
marketing@company.com
#ex_worker@company.com
worker@company.com
------
     
=head1 AUTHORS

Roman Prokhorov <roma@communigate.com>

=cut


use strict;
use Data::Dumper;
use CLI;  #get one from www.stalker.com/CGPerl

####  YOU SHOLD REDEFINE THESE VARIABLES !!!

my $CGServerAddress='127.0.0.1';  #IP or domain name;
my $Login='postmaster';
my $Password='pass';

#### end of the customizeable variables list

if(@ARGV != 1) {
  die "Usage: ./RosterGroup.pl account_list.txt\n";
}
unless(-f $ARGV[0]) {
  die "no such file: $ARGV[0]\n";
}

my @addList;
my @delList;

print "Reading $ARGV[0]\n";
my $groupName=<>;
chomp($groupName);
while(<>) {
  chomp;
  next if(length($_)<2);
  if(/^#(.*)/) {
    push(@delList,lc($1));
  } else {
    push(@addList,lc($_));
  }
}

if(scalar(@addList)==0) {
  print "no group members found\n";
  exit(1);
}

print "Group members:\n";
print "  '$_'\n" foreach(@addList);

print "Deleted members:\n";
if(@delList) {
  print "  '$_'\n" foreach(@delList);
} else {
  print "  none\n";
}
my $cli = new CGP::CLI( { PeerAddr => $CGServerAddress,
                          PeerPort => 106,
                          login    => $Login,
                          password => $Password } )
   || die "*** Can't login to CGPro CLI: ".$CGP::ERR_STRING."\n";

foreach my $account (@addList) {
  my $rd=$cli->Roster($account,{what=>'List'});
  #print Dumper($rd);
  
  foreach my $member (@addList) {
    if($account ne $member && !$rd->{$member}) {
      print "$account: adding $member\n";
      $cli->Roster($account,{what=>'Update', peer=>$member, data=>{ Inp=>'YES','Out'=>'YES', GroupName=>[$groupName] } });
    }
  }
  foreach my $member (@delList) {
    if($rd->{$member}) {
      print "$account: deleting $member\n";
      $cli->Roster($account,{what=>'remove', peer=>$member});
    }
  }
}
print "processing deleted members...\n" if(@delList);
foreach my $account (@delList) {
  my $rd=$cli->Roster($account,{what=>'List'});
  foreach my $member (@addList,@delList) {
    if($account ne $member && $rd->{$member}) {
      print "$account: deleting $member\n";
      $cli->Roster($account,{what=>'remove', peer=>$member});
    }
  }
}



print "Done\n";
$cli->Logout();
exit;

