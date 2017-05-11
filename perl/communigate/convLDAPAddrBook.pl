#!/usr/bin/perl -w
#
#  convLDAPAddrBook.pl
#  Directory -> Contacts conversion script
#  version 1.1 Tue, Dec 27, 2005 (UIDs added) 
#  version 1.0 Wed, Dec 21, 2005 
#
#  This script reads users from Central Directory via LDAP and adds
#  them to a contacts-type mailbox in vCard format via IMAP.
#  Using this script you can maintain a shared address book with your local users.
#
# Please mail your comments and suggestions to <support@communigate.com>

######## You should redefine these values
my $CGServerAddress =  '127.0.0.1';   
my $CGServerLogin = 'postmaster';
my $CGServerPassword = 'pass';

my $LDAPServerAddress = $CGServerAddress;
my $LDAPServerLogin = $CGServerLogin;
my $LDAPServerPassword = $CGServerPassword;

#my $LDAPSearchBase = 'cn=mydomain.com';
my $LDAPSearchBase = 'top';

my $LDAPSearchFilter = '(objectClass=inetOrgPerson)';

my $ContactsMailboxName = '~public/SharedAddressBook';

my $clearMailbox=1;  # to delete all messages from the destination mailbox



########## End of the customizeable area


use strict;
use Net::LDAP;  #get one from <http://www.cpan.org/modules/by-module/Net/>
use MIME::Base64;
#use MIME::QuotedPrint;



print "Starting\n";

my $ldap = Net::LDAP->new($LDAPServerAddress,port=>389,timeout=>20)
  || die "Can't connect to $LDAPServerAddress via LDAP";

my $result;
$result = $ldap->bind($LDAPServerLogin,password=>$LDAPServerPassword)
  || die "Can't bind: ".$result->error;
    
$result->code && die "Can't bind as admin: ".$result->error;
 
my $mesg = $ldap->search (  # perform a search
               base   => $LDAPSearchBase, 
               filter => $LDAPSearchFilter
             );

$ldap->unbind();                        # unbind & disconnect

unless(defined $mesg && !$mesg->code) {
  die "LDAP search failed: ".$result->error;   
} 
if($mesg->all_entries() eq 0) {
  die "LDAP: nothing found";
}
  
my $imap = new IO::Socket::INET(   PeerAddr => $CGServerAddress,
                                  PeerPort => 143
                                ) 
   || die "*** Can't connect to CGPro via IMAP.\n";                                

$imap->autoflush(1);
my $responseLine = <$imap>;

print $imap "x LOGIN $CGServerLogin $CGServerPassword\012";
do {
  $responseLine = <$imap>;
}until($responseLine =~/^x /);
die "*** Can't login to CGPro IMAP: $responseLine.\n" unless($responseLine =~ /^x OK/);

if($clearMailbox) {
  print $imap "x SELECT $ContactsMailboxName\012";
  do {
    $responseLine = <$imap>;
  }until($responseLine =~/^x /);
  die "*** Can't select $ContactsMailboxName: $responseLine.\n" unless($responseLine =~ /^x OK/);
  
  print $imap "s STORE 1:* +FLAGS (\\Deleted)\012";
  do {
    $responseLine = <$imap>;
  }until($responseLine =~/^s /);
  unless($responseLine =~ /^s OK/) {
    die "*** Can't store flags for $ContactsMailboxName messages: $responseLine.\n";
  }
  print $imap "c CLOSE\012";
  do {
    $responseLine = <$imap>;
  }until($responseLine =~/^c /);
  unless($responseLine =~ /^c OK/) {
    die "*** Can't close $ContactsMailboxName: $responseLine.\n";
  }

}


my $nRecords=0;    
foreach my $entry ($mesg->all_entries) {
  my $ref1=@$entry{'asn'};
  if(my $errCode=AddEntry(@$ref1{'attributes'}, @$ref1{'objectName'})) {
    print "Error in ".@$ref1{'objectName'}.":$errCode\n";
  }
}

print $imap "x LOGOUT\n";
do {
  $responseLine = <$imap>;
}until($responseLine =~/^x /);

print "\nDone\n";
print "  $nRecords records total\n";

exit(0);

# cn -> Subject, FN
# mail ->To:,EMAIL
# sn -> N[0]
# givenName -> N[1]
# telephonenumber ->TEL;WORK
# homePhone ->TEL;HOME
# userCertificate ->KEY
# description ->NOTE
# ou -> ?
# l  -> ? 


sub AddEntry {
  my ($attrsRef,$objName)=@_;

      
  my ($dn,$cn,$subj,$mail,$certificate,$sn,$givenName,$title,$telephonenumber,$homePhone,$description,$l);

  foreach my $atrRef (@$attrsRef) {
    my $type=@$atrRef{'type'};
    my $vals=@$atrRef{'vals'};
    # print "type=$type, vals =".join(',',@$vals)."\n";
      
    $dn=@$vals[0] if($type eq 'dn');
    $cn=@$vals[0] if($type eq 'cn');
    $mail=@$vals[0] if($type eq 'mail');
    $certificate=@$vals[0] if($type eq 'userCertificate');
    
    $sn=$vals if($type eq 'sn');
    $givenName=$vals if($type eq 'givenName');
    $title=$vals if($type eq 'title');
    $telephonenumber=$vals if($type eq 'telephonenumber');
    $homePhone=$vals if($type eq 'homePhone');
    $description=$vals if($type eq 'description');
    $l=$vals if($type eq 'l');
  }
  $cn=$objName unless($cn);
  unless($mail) {
    $objName =~ /=(.*),.*=(.*)/;
    $mail=$1.'@'.$2;
  }
  $subj=$cn;
  if($subj =~ /[\x80-\xff]/) {
    #print "needs conversion ";
    $subj =~ s/([\=\?\x7F-\xFF])/sprintf("=%02X",ord($1))/ge;
    $subj = '=?utf-8?Q?'. $subj. '?=';
  }
     
  my @contact;
  push(@contact,"content-class: urn:content-classes:person");
  push(@contact,"Subject: $subj");
  push(@contact,"To: $mail");
  push(@contact,"X-Has-Certificate: true") if($certificate);
  
  push(@contact,"MIME-Version: 1.0");
  push(@contact,'Content-Type: text/x-vcard; charset="utf-8"');
  push(@contact,"");
  push(@contact,"BEGIN:VCARD");
  push(@contact,"VERSION:2.1");
  push(@contact,"EMAIL:$mail");
  push(@contact,"FN:$cn");

  sub cv {
    return (defined($_[0]) ) ? $_[0] : '';  
  }
  sub cva {
    my $ptr=$_[0];
    return (defined($ptr) && ref($ptr) eq 'ARRAY') ? join(';',@$ptr) : '';
  }
  sub cvb {
    my $ptr=$_[0];
    return (defined($ptr) && ref($ptr) eq 'ARRAY') ? join(',',@$ptr) : '';
  }


  push(@contact,"KEY;X509;ENCODING=BASE64:".encode_base64($certificate,'')) if($certificate);
  push(@contact,"TEL;WORK:".cva($telephonenumber)) if($telephonenumber);
  push(@contact,"TEL;HOME:".cva($homePhone)) if($homePhone);
  push(@contact,"NOTE:".cva($description)) if($description);

  push(@contact,"N:".cvb($sn).";".cvb($givenName).";;".cvb($title).";;") if($sn || $givenName || $title); 

  push(@contact,"UID:".abs(time())."$nRecords.\@public");

  push(@contact,"END:VCARD");
  push(@contact,"");

  my $vCardData = join("\r\n",@contact);
  my $vCardSize=length($vCardData);

  print $imap "x APPEND $ContactsMailboxName {$vCardSize}\012";
  $responseLine = <$imap>;

  print $imap "$vCardData";
  print $imap "\012";
  $responseLine = <$imap>;
  $nRecords++;
  print "Contact: $cn <$mail>\n";
  undef;
}

__END__


