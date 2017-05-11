#!/usr/bin/perl -w
#
# checkMboxSizes.pl
#
# Checks sizes of mailboxes (.mbox for being close to 2Gb and .mdir for more than 4000 messages in mailbox) and sends alerts to users. 
#
# Please send your comments to <support@communigate.com>

use strict;
use CLI;  #get one from www.communigate.com/CGPerl/
use Encode qw/encode decode/; 

####  YOU SHOLD REDEFINE THESE VARIABLES !!!

my $CGServerAddress='127.0.0.1';  #IP or domain name;
my $Login='postmaster';
my $Password='pass';

my $sendAlerts=1;
my $alertMbox='Your mailbox "^1" is close to critical size of 2GB. You need to move some messages out of it.'; 
my $mboxCritical=1990*1024*1024;

my $alertMdir='Your mailbox "^1" contains more than ^2 messages which is critical. You need to move some messages out of it.'; 
my $mdirCritical=4000;


my ($BaseDir,$PathSeparator);
if($^O eq 'MSWin32') {
  $BaseDir      = "C:\\CommuniGatePro\\";
  $PathSeparator="\\";
} else {
  $BaseDir      = "/var/CommuniGate/";
  $PathSeparator="/";
}

#### end of the customizeable variables list




my $cli = new CGP::CLI( { PeerAddr => $CGServerAddress,
                          PeerPort => 106,
                          login    => $Login,
                          password => $Password } )
   || die "*** Can't login to CGPro CLI: ".$CGP::ERR_STRING."\n";
$cli->setStringsTranslateMode(1);

#processDomain('company.com');
processAllDomains();

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
  my $DomainPath=$cli->GetDomainLocation($domain);
  unless($DomainPath) {
    print "*** Can't get domain location for $domain: ".$cli->getErrMessage."\n";
    return;
  }
  $DomainPath=~s/\\\\/\\/g;
  $DomainPath = $DomainPath . $PathSeparator;

  my $cookie="";
  do {
    my $data=$cli->ListDomainObjects($domain,5000,undef,'ACCOUNTS',$cookie);
    unless($data) {
      print "*** Can't get accounts for $domain: ".$cli->getErrMessage."\n";
      return;
    }
    $cookie=$data->[4];

    foreach(keys %{$data->[1]} ) {
      processAccount($domain,$_,$DomainPath);

    }
  }while($cookie ne '');
 
}



sub processAccount {
  my ($Domain,$Account,$DomainPath) = @_;
#  print "Account: $Account\@$Domain\n";

  my $AccLocation = $cli->GetAccountLocation("$Account\@$Domain");
  unless($AccLocation) {
    print "*** Can't get location for $Account\@$Domain: ".$cli->getErrMessage."\n";
    return;
  }  
  $AccLocation=~s/\\\\/\\/g;

  my $basePath = $BaseDir.$DomainPath . $AccLocation ;
 
  checkDir($basePath,'',"$Account\@$Domain");

} 

sub checkDir {
  my ($b,$path,$account)=@_;
#  print "Checking dir: $path\n";
  unless(opendir(DIR,$b.$path)) {
    print "*** Can't opendir $b.$path: $!\n";
    return;
  }  
  my @files = readdir(DIR);
  closedir DIR;

  foreach(sort @files) {
    my $curPath2=$path.$PathSeparator.$_;
    my $curPath=$b.$curPath2;
    if(/^\./ || $_ eq "account.web") {
    }elsif(/\.mbox$/ && -f $curPath) {
      checkMBox($b,$curPath2,$account);
    }elsif(/\.mdir$/ && -d $curPath && !(-l $curPath)) {
      checkMDir($b,$curPath2,$account);
    }elsif(-d $curPath && !(-l $curPath) ) {
#print "dir: path/$_\n";
      checkDir($b,$curPath2,$account);
    }
  } 
}

sub checkMBox {
  my ($b,$path,$account)=@_;
#  print "Checking mbox: $path\n";
  my $size=(stat($b.$path))[7];
  #print "size=$size\n";         
  if($size>$mboxCritical) {
    if($sendAlerts) {
      my $msg=$alertMbox;
      my $mailbox=$path;
      $mailbox=~s/\.folder//g;
      $mailbox=~s/\.mbox//;
      $mailbox=~s/\\/\//g;
      $mailbox=~s/^\///;
      $mailbox=imap_utf7_decode($mailbox);
  
      $msg=~s/\^1/$mailbox/;
      $cli->PostAccountAlert($account,$msg);
    }
    print "$account\t$path\tsize=$size\n";
  }
  
}
sub checkMDir {
  my ($b,$path,$account)=@_;
#  print "Checking mdir: $path\n";
  my $nFiles=-2;

  unless(opendir(DIR,$b.$path)) {
    print "*** Can't opendir $b.$path: $!\n";
    return;
  }
  $nFiles++ while(readdir(DIR)); 
  closedir DIR;
  #print "n=$nFiles\n";         
  if($nFiles>=$mdirCritical) {
    if($sendAlerts) {
      my $msg=$alertMdir;
      my $mailbox=$path;
      $mailbox=~s/\.folder//g;
      $mailbox=~s/\.mdir//;
      $mailbox=~s/\\/\//g;
      $mailbox=~s/^\///;
      $mailbox=imap_utf7_decode($mailbox);
  
      $msg=~s/\^1/$mailbox/;
      $msg=~s/\^2/$nFiles/;
    
      $cli->PostAccountAlert($account,$msg);
    }  
    print "$account\t$path\tsize=$nFiles\n";
  }
}

sub imap_utf7_decode {
	my ($s) = @_;

	$s =~ s/\+/PLUSPLACEHOLDER/g;
	$s =~ s/&([^,&\-]*),([^,\-&]*)\-/&$1\/$2\-/g;
	$s =~ s/&(?!\-)/\+/g;
	$s =~ s/&\-/&/g;
	$s =~ s/PLUSPLACEHOLDER/+-/g;
	return decode("UTF-7",$s);
	#return Unicode::String::utf7($s)->latin1;
}


__END__

