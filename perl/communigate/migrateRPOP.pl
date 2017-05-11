#!/usr/bin/perl -w
#
# This script "converts" RPOP retrieved messages UIDs from 5.2.x to 5.3.x
# by moving files from {account}/account.rpopids/ into {account}/account.web/private/rpopids/
#
# Note: this script uses direct file access to account directorys, so
# it must be launched on the same machine with CGPro and as root user. 
# After launching this script it's desirable to restart CommuniGate.

#
# Please mail your comments and suggestions to <support@stalker.com>
#


use CLI;  # get one from www.stalker.com/CGPerl
use strict;
my ($BaseDir,$PathSeparator);


######  You should redefine some of these values !!!

my $Login = "Postmaster";
my $Password = "pass";


if($^O eq 'MSWin32') {
  $BaseDir      = "C:\\CommuniGatePro\\";
  $PathSeparator="\\";
} else {
  $BaseDir      = "/var/CommuniGate/";
  $PathSeparator="/";
}

#### end of the customizeable variables list

my $CGServerAddress = "127.0.0.1";   #local machine only


die "Unable to read $BaseDir. You must be root to launch this script.\n"
   unless -r $BaseDir;

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

print "Domain: $Domain\n";

  my $DomainPath=$cli->GetDomainLocation($Domain);
  unless($DomainPath) {
    die "Can't get path for $Domain: ".$cli->getErrMessage;
  }
  $DomainPath=~s/\\\\/\\/g;
  $DomainPath = $BaseDir . $DomainPath . $PathSeparator;
  unless(-d $DomainPath) {
    die "can't find the directory for $Domain\n";
  }  

#  print "Scanning $DomainPath\n";
  my $AccountList = $cli->ListAccounts($Domain) || die "Error: ".$cli->getErrMessage.", quitting";
  foreach(keys %$AccountList) {
    processAccount($Domain,$_,$DomainPath);
  }
}


sub processAccount {
  my ($Domain,$Account,$DomainPath) = @_;
  print "Account: $Account\@$Domain\n";

  my $AccLocation = $cli->GetAccountLocation("$Account\@$Domain");
  unless($AccLocation) {
    print "Error: can't get location: ".$cli->getErrMessage."\n";
    return;
  }  
  $AccLocation=~s/\\\\/\\/g;

  my $basePath = $DomainPath . $AccLocation . $PathSeparator;
  my $oldDir=$basePath.'account.rpopids';
  unless(-d $oldDir) {
    print " no old UIDs found\n";
    return;
  }
  
  my $newDir=$basePath.'account.web'.$PathSeparator."private".$PathSeparator.'rpopids';
  unless(-d $newDir) {
    print " creating $newDir\n";
    mkdir($basePath.'account.web') unless(-d $basePath.'account.web');
    mkdir($basePath.'account.web'.$PathSeparator."private") unless(-d $basePath.'account.web'.$PathSeparator."private");
    unless(mkdir($newDir)) {
      print "Error: can't mkdir $newDir:$!\n";
      return;
    } 
  }

  my $dh;
  unless(opendir($dh,$oldDir)) {
    print "Error: can't opendir $oldDir: $!\n";
    return;
  }
  my @fNames = grep { -f $oldDir.$PathSeparator.$_ } readdir($dh);
  closedir($dh);
  foreach(@fNames) {
    my $oldFile=$oldDir.$PathSeparator.$_;
    my $newFile=$newDir.$PathSeparator.$_;
    if(-f $newFile) {
      print " the $_ already exists\n";
    } else {
      print " *moving $_\n";
      unless(rename($oldFile,$newFile)) {
        print "Can't move $oldFile to $newFile: $!\n";
      }
    }
  }
  rmdir($oldDir);
}

__END__

