#!/usr/bin/perl -w
#
# cmpClusterSettings.pl
# Compares settigs of two Cluster Member servers.
#
# Please mail your comments and suggestions to <support@communigate.com>

use strict;
use CLI;  #get one from www.stalker.com/CGPerl/


####  YOU SHOLD REDEFINE THESE VARIABLES !!!

my @servers=qw/10.0.0.1 10.0.0.2/;  #IPs or domain names 
my $Login='postmaster';
my $Password='pass';

#### end of the customizeable variables list

my @funcs=qw/
GetCurrentController
GetQueueSettings GetSignalSettings GetMediaServerSettings GetSessionSettings GetClusterSettings GetNetwork GetBanned
GetServerMailRules GetServerSignalRules GetRouterSettings GetRouterTable
GetServerIntercept
GetLANIPs GetClientIPs GetBlacklistedIPs GetWhiteHoleIPs GetNATedIPs GetDebugIPs GetDeniedIPs GetTempClientIPs GetTempBlacklistedIPs
GetDomainDefaults GetServerAccountDefaults GetServerAccountPrefs GetServerTrustedCerts
GetDirectoryIntegration GetServerAlerts ListServerSkins ListServerPBXFiles
/;

my @modules=qw/
HTTPA HTTPU 
SMTP LOCAL POP RPOP IMAP PIPE RADIUS DIAMETER FTP TFTP PWD LDAP ACAP LIST SNMP SIP XIMSS XMPP BSDLOG
/;


my $nSrv=@servers;
my @cli;
foreach(0..$nSrv-1) {
 $cli[$_] = new CGP::CLI( { PeerAddr => $servers[$_],
                          PeerPort => 106,
                          login    => $Login,
                          password => $Password } )
   || die "*** Can't login to CGPro CLI @".$servers[$_].": ".$CGP::ERR_STRING."\n";
}


callFuncM($_) foreach(@modules);
callFunc($_) foreach(@funcs);

$cli[$_]->Logout() foreach(0..$nSrv-1);
print "Done\n";
exit;

sub callFunc {
  my($fn)=@_;
  my $d1=$cli[0]->$fn();
  unless($cli[0]->isSuccess) {
    print "error calling $fn@",$servers[0],": ".$cli[0]->getErrMessage."\n";
    return;
  }
  for(1..$nSrv-1) {
    my $d2=$cli[$_]->$fn();
    unless($cli[$_]->isSuccess) {
      print "error calling $fn@",$servers[$_],": ".$cli[$_]->getErrMessage."\n";
      return;
    }
    cmpItem($servers[0],$servers[$_],"$fn->",$d1,$d2);
  }  
}
sub callFuncM {
  my($m)=@_;
  my $d1=$cli[0]->GetModule($m);
  unless($cli[0]->isSuccess) {
    print "error calling GetModule($m)@",$servers[0],": ".$cli[0]->getErrMessage."\n";
    return;
  }
  for(1..$nSrv-1) {
    my $d2=$cli[$_]->GetModule($m);
    unless($cli[$_]->isSuccess) {
      print "error calling GetModule($m)@",$servers[$_],": ".$cli[$_]->getErrMessage."\n";
      return;
    }
    cmpItem($servers[0],$servers[$_],"module($m)->",$d1,$d2);
  }  
}




sub cmpItem {
  my($srv1,$srv2,$title,$x1,$x2)=@_;
  if((!defined($x1)) && (!defined($x2))) {
    return 0; 
  }elsif(!defined($x1)) {
    #perror($title,"=null","@".$srv1);
    #return 1; 
    $x1='null';
  }elsif(!defined($x2)) {
    #perror($title,"=null","@".$srv2);
    #return 1; 
    $x2='null';
  }
  if(ref($x1) ne ref($x2)) {
    perror($title,"different types: ".(ref($x1) || 'STR')."@".$srv1." vs. ".(ref($x2) || 'STR')."@".$srv2);
    return 1; 
  }
  if(ref($x1) eq 'ARRAY') {
    if(@$x1 != @$x2) {
      perror($title,"different array sizes: ".@$x1."@".$srv1." vs. ".@$x2."@".$srv2);
    }
    foreach(my $i=0;$i<@$x1;$i++) {
      return 0 if(cmpItem($srv1,$srv2,$title."[$i]",$x1->[$i],$x2->[$i]));
    } 
  } elsif(ref($x1) eq 'HASH') {
    foreach(sort keys(%$x1)) {
#  print "key=$_\n";
      cmpItem($srv1,$srv2,$title."{$_}",$x1->{$_},$x2->{$_});
    } 
  }elsif($x1 ne $x2) {
    perror($title,": ","\"$x1\"","@".$srv1," vs. ","\"$x2\"","@".$srv2);
    return 1;
  }

  0;
}

sub perror {
  print join("",@_)."\n";

}

__END__

