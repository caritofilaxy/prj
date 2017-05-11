#!/usr/bin/perl -w
#
#  This script exports accounts data into LDIF file
#
# Please mail your comments and suggestions to <support@communigate.com>

use strict;
use MIME::Base64;

use CLI;  #get one from www.communigate.com/CGPerl/


####  YOU SHOLD REDEFINE THESE VARIABLES !!!

my $CGServerAddress='127.0.0.1';  #IP or domain name;
my $Login='postmaster';
my $Password='pass';

my %translationTable=(
  RealName => 'cn',
  Password => 'userPassword',
  Organization => 'o',

  City => 'l',
  Department => 'ou',
  Title => 'description',
  FirstName => 'givenName',
  FamilyName => 'sn',
);



my $outFileName='LDIF.txt';

#### end of the customizeable variables list
#### but see below...


my $cli = new CGP::CLI( { PeerAddr => $CGServerAddress,
                          PeerPort => 106,
                          login    => $Login,
                          password => $Password } )
   || die "*** Can't login to CGPro CLI: ".$CGP::ERR_STRING."\n";

$cli->setStringsTranslateMode(1);
my $nAdded=0;

open(FILE,">$outFileName") || die "can't create $outFileName: $!";


# ...un-comment one of the below 4 lines

#processAccount('aaa','company.com');
processDomain('company.com');
#processAllDomains();



print " $nAdded records added.\n";
close(FILE);
$cli->Logout;

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

  my $cookie="";
  do {
    my $data=$cli->ListDomainObjects($domain,5000,undef,'ACCOUNTS',$cookie);
    unless($data) {
      print "*** Can't get accounts for $domain: ".$cli->getErrMessage."\n";
      return;
    }
    $cookie=$data->[4];
    foreach(keys %{$data->[1]} ) {
      processAccount($_,$domain); 
    }
  }while($cookie ne '');
 
}




sub processAccount {
  my ($name,$Domain)=@_;


print "Account: $name\@$Domain\n";  

  my $Settings;
  unless($Settings=$cli->GetAccountSettings("$name\@$Domain")) {
    die "Error: ".$cli->getErrMessage.", quitting";
  }  


  print FILE "dn: uid=$name,cn=$Domain\n";
  print FILE "objectclass: top\n";
  print FILE "objectclass: person\n";
  print FILE "objectclass: organizationalPerson\n";
  print FILE "objectclass: inetOrgPerson\n";
  print FILE "objectclass: CommuniGateAccount\n";
  print FILE "mail: $name\@$Domain\n";
  print FILE "uid: $name\n";
  
  my %outAtr=();
  
  foreach (keys %$Settings) {
    my $key=$_;
    my $value=@$Settings{$key};
    $key=$translationTable{$key} if(exists($translationTable{$key}));
    putLDIF($key,$value);

    $outAtr{$key}=1;
  }
  
  print FILE "cn:\n" unless($outAtr{'cn'});
  print FILE "sn:\n" unless($outAtr{'sn'});
  
  print FILE "\n";

  $nAdded++;

}

sub putLDIF {
  my ($name,$value)= @_;
  if(!defined($value)) {
    print FILE "$name:\n";
    return;
  } elsif(ref($value) eq 'HASH') {
    my $outp='"{';
    foreach (sort keys %$value) {
      my $value=@$value{$_};
      $outp .= convertValue2($_).'='.convertValue2($value).';';
      $outp.= '}"';
    }
    print FILE "$name:$outp\n"

  } elsif(ref($value) eq 'ARRAY') {
    my $outp='';
    my $first=1;
    foreach (@$value) {
      if(!$first) { $outp.=','; } else { $first=0; }
      $outp.=convertValue2($_);
    }
    print FILE "$name:$outp\n"

  } elsif($value=~/^\[(.*)\]$/ && is_base64($1)) {
    print FILE "$name::$1\n"

  } else {
    print FILE "$name:$value\n";
  }



}

sub is_base64{
  my $data = shift;
  return(undef) unless ($data =~ /[A-Za-z0-9+\/=]/); #test for valid Base64 characters
  if (length ($data)%4==0){
    my $decoded = decode_base64($data);
    return 1;
    # return( $decoded );
  } else {
    return(undef);
  }
}



sub convertValue2 {
  my $data = $_[0];
  if(!defined($data)) {
    return '""';
  } elsif(ref($data) eq 'HASH') {
    my $outp='{';
    foreach (sort keys %$data) {
      my $value=@$data{$_};
      $outp .= convertValue2($_).'='.convertValue2($value).';';
    }
    $outp.= '}';
    return $outp;
  } elsif(ref($data) eq 'ARRAY') {
    my $outp='(';
    my $first=1;
    foreach (@$data) {
      if(!$first) { $outp.=','; } else { $first=0; }
      $outp.=convertValue2($_);
    }
    $outp.= ')';
    return $outp;
  } else {
    if($data =~ /[\W_]/ || $data eq '') {
      $data =~ s/([\x00-\x1F\x7F])/'\\'.('0'x(3-length(ord($1)))).ord($1)/ge;
      return '"' . $data . '"';
    } else {
      return $data;
    }
  }
}

__END__


