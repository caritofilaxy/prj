#!/usr/bin/perl -w
#
# A script for emergency cleaning CommuniGate queue.
# You may need this tool badly if your queue is flooded
# with spam or bounces and you want to clean it quickly
# without stopping the server.
#
# The script must run on server and have read acces to Queue directory.
#
# Usage: 
# ./cleanQueue [-check|-c|-delete|-d] "pattern" ["pattern2" ...]
# The patterns are Perl regular expressions; the {}[]()^$.|*+?\ are
# metacharacters and should be escaped. Patterns are AND-grouped,
# i.e. all of them should match for the message to be deleted.

# Examples:
# ./cleanQueue -check "^Subject: Are you ready to be rich"
# ./cleanQueue -d "^From: .*@(domain1.com|domain2.com)" "[Vv][Ii][Aa][Gg][Rr][Aa]"
#
# Creation date: 24.07.2009
# Please mail your comments and suggestions to <support@communigate.com>


use strict;
use CLI;  #get one from www.communigate.com/CGPerl/


#### you need to redefine these values

my $CGServerAddress = "127.0.0.1";
my $PostmasterLogin = "postmaster";
my $PostmasterPassword = "password";

my $queueDir='/var/CommuniGate/Queue';
#my $queueDir='C:\\CommuniGate Files\\Queue'; #for Windows

my $errorText='NONDN';

####  end of the user configurable area


if(@ARGV < 2 || $ARGV[0]!~/^\-(c|d|check|delete)$/i) {
  print 'Usage: ./cleanQueue [-check|-delete] "pattern" ["pattern2" ...]'."\n";
  exit(1);
}

my @patterns;
for(my $idx=1;$idx<@ARGV;$idx++) {
  $patterns[$idx-1]=$ARGV[$idx];
  print "pattern: $patterns[$idx-1]\n";
}

my %msgList;
checkDir($queueDir,'/');
print "Checking completed\n\n";
my $nMessages=scalar(keys %msgList);

if($ARGV[0]=~/^\-d/) {
  print " $nMessages message(s) to delete\n";
  if((keys %msgList)>0) {
    my $cli = new CGP::CLI( { PeerAddr => $CGServerAddress,
                            PeerPort => 106,
                            login    => $PostmasterLogin,
                            password => $PostmasterPassword } );
    unless($cli) {
      die("Can't login to CGPro: ".$CGP::ERR_STRING);
    }
    my $nRejected=0;
    foreach(keys %msgList) {
      /(.*)\./;
      my $msgID=$1;
      print "$msgID\n";
      $nRejected++ if($cli->SendCommand("RejectQueueMessage $msgID $errorText"));  #ignore errors
    }
    $cli->Logout();
    print " $nRejected of $nMessages messages rejected.\n";
  }  
} else {
  foreach(keys %msgList) {
    print $msgList{$_}."$_\n";
  }
  print " $nMessages message(s) found\n";
}

exit(0);

sub checkMessage {
  my($msgName,$path)=@_;
  my $fName=$queueDir.$path.$msgName;
  return unless(-f $fName);
  unless(open(FILE,$fName)) {
    print "can't open $path$msgName: $!\n";
    return;
  }
  my @matched;
  my $nUnmatched=@patterns;
  for(my $idx=0;$idx<@patterns;$idx++) { $matched[$idx]=0; }
  OUTER: while(<FILE>) {
    for(my $idx=0;$idx<@patterns;$idx++) {
      unless($matched[$idx]) {
        if(/$patterns[$idx]/) {
          $matched[$idx]=1;
          last OUTER if(--$nUnmatched==0);
        }
      }
    }
  }
  close(FILE);
  if($nUnmatched==0) {
    $msgList{$msgName}=$path;
  }  
}

sub checkDir {
  my ($path,$pathPrefix)=@_;
  print "Checking: $path\n";
  opendir(DIR,$path) || die "can't opendir $path: $!";
  my @files = readdir(DIR);
  closedir DIR;

  foreach(@files) {
    if(/^\./) {
    }elsif(/\.msg$/ && -f "$path/$_") {
      checkMessage($_,$pathPrefix);
    }elsif(-d "$path/$_") {
      checkDir("$path/$_",$pathPrefix.$_."/");
    }
  } 
}

__END__



