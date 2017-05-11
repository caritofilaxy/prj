#!/usr/bin/perl -w

#
# RecreateAccounts.pl
# Account moving script for CommuniGate Pro. 
# Vers 1.2 Wed, Aug 17, 2005 
# Vers 1.3 Wed, Aug 14, 2009 
#
# Read the annotation below.
# Please mail your comments and suggestions to <support@stalker.com>


my $note=<<EOT;

  ACCOUNTS vs MAILBOXES & their types.


  There are two general mailbox formats supported in CGPro: TextMailbox
and MailDirMailbox (also referred as .mbox and .mdir). See their description
at <http://www.stalker.com/CommuniGatePro/Mailboxes.html#Formats>.

  There are three account types you can create in CGPro. Don't mix account
types with mailbox types. The account types are as follows:

TextMailbox     - single mailbox account with InBox of TextMailbox type
MailDirMailbox  - single mailbox account with InBox of MailDirMailbox type
MultiMailbox    - multi-mailbox account with mailboxes of different types

  When MultiMailbox account is being created its InBox type and other initial
mailboxes types are defined in the domain's account template in "Miscellaneous"
panel in "New Mailboxes:" popup. Then, when account already exists, the same
popup becomes available in the account settings page.

 How to convert your own InBox mailbox to another format:
 
1) Go to WebAdmin and in your account settings page change the "New
   Mailboxes:" to the desired format. 
2) Rename your InBox mailbox to some name. New InBox of new type will
   be created automatically.
3) Move old mesages from old InBox to new InBox, delete the old InBox.

  When creating a mailbox you can override the default mailbox type if you
explicitly specify the type by appending .mbox or .mdir to the mailbox name.
For example, if you specify "aaa.mdir" mailbox name then "aaa" mailbox of
.mdir type will be created. So you can convert mailboxes other than InBox
on your own without the admin's intervention by creating a new mailbox and
moving messages from the old one.

  There's no way to convert a single-mailbox account (TextMailbox or
MailDirMailbox) into MultiMailbox account or vice versa. Also there's
no way to convert from External INBOX to CGPro-based INBOX. All you can
do is to create a new account of the desired type and migrate its mail.
The following script was created to perform this task.

  What the script does:

1) opens CLI and IMAP connections to CGPro
2) reads space-separated pairs of source and destination names from STDIN
   until end-of-file.
3) copies from the the source account into the destination account:
    general settings (real name, password, access modes, limits, etc) 
    WebMail settings (signature, default charset, etc)
    rules
    access rights
    mailbox subscription list
    mailbox aliases
6) deletes from the source account and assigns to the destination account:
    account aliases
    RPOP records
4) copies mailboxes, thier contents and ACLs.    
5) copies Personal WebSite files
6) deletes the source account if success, destination account if failure.

  The source and destination can be in different domains.
  If the destination name is omited or same as the source then the
source account is renamed into 'XXX-Copy-<source>' name, then copied
into its original name, then deleted.

  Accounts which own mailing lists can NOT be copied by this script.

EOT

use CLI;

print $note;

my $CGServerAddress = '127.0.0.1';  #redefine this value
my $Login = "Postmaster";
my $Password='***';  #put here the postmaster password    

die "You should configure the script before you run it" if($Password eq '***');

my $imap = new IO::Socket::INET(   PeerAddr => $CGServerAddress,
                                    PeerPort => 143
                                  ) 
   || die "*** Can't connect to CGPro via IMAP.\n";                                

$imap->autoflush(1);
my $responseLine = <$imap>;
#print "$responseLine\n";

print $imap "x LOGIN $Login $Password\015\012";
do {
  $responseLine = <$imap>;
}until($responseLine =~/^x /);
die "*** Can't login to CGPro IMAP: $responseLine.\n"
   unless($responseLine =~ /^x OK/);

my $cli = new CGP::CLI( { PeerAddr => $CGServerAddress,
                          PeerPort => 106,
                          login    => $Login,
                          password => $Password } )
   || die "*** Can't login to CGPro CLI: ".$CGP::ERR_STRING."\n";

my $destAccountType='MultiMailbox'; # MailDirMailbox | TextMailbox

print qq/Enter "source\@domain destination\@domain" pairs\n/;
while(<STDIN>) {
  chomp;
  my ($srcName,$dstName);
  $srcName=$_;
  if($_=~/(.+)\s+(.+)/) {
    $srcName=$1;$dstName=$2;
  }
  
  if((!defined($dstName)) || $dstName eq '' || $srcName eq $dstName) { 
    $dstName=$srcName;
    $srcName="XXX-Copy-$srcName";
    unless($cli->RenameAccount($dstName,$srcName)) {
      print "Can't rename $dstName: ".$cli->getErrMessage."\n";
      next;
    }  
  }
  my $result=moveAccount($srcName,$dstName);
  if($result==0) {
    $cli->DeleteAccount($srcName) 
      || print qq/Can't delete "$srcName": /.$cli->getErrMessage."\n";;
    print "moved.\n"  
  } else {
    $cli->DeleteAccount($dstName) if($result<0);
    $cli->RenameAccount($srcName,$dstName) if($srcName =~/^XXX-Copy/);
    print "failed.\n"; 
  }  
  print qq/Enter more "source\@domain destination\@domain" pairs or hit Ctrl+C\n/;
 
 
}

$cli->Logout();
print $imap "x LOGOUT\015\012";
exit(0);

sub moveAccount {
  my ($srcName,$dstName) = @_;
  
  print "Account: $srcName -> $dstName\n";

  my $settings=$cli->GetAccountSettings($srcName);
  unless($settings) {
    print qq/Can't read "$srcName": /.$cli->getErrMessage."\n";
    return 1;
  }
  
  if(my $lists=$cli->GetAccountLists($srcName)) {
    if(scalar(%$lists)) {
      print qq/Account "$srcName" can't be copied becasue /
              ."it owns the following mailing lists: "
              .join(", ",keys %$lists)."\n";
      return 1;
    }
  }

  my $Boxes= $cli->ListMailboxes(accountName=>$srcName,filter=>'*')
            || die "Error: ".$cli->getErrMessage.", quitting";

  if($destAccountType ne 'MultiMailbox' && scalar(keys %$Boxes)!=1) {
      print qq/Account "$srcName" can't be recreated as "$destAccountType"/
               ." becasue it contains multiple mailboxes: "
               .join(", ",keys %$Boxes)."\n";
      return 1;
    
  }

  delete @$settings{ExternalINBOX};

  my $accessRights=$cli->GetAccountRights($srcName);
  my $webSettings=$cli->GetWebUser($srcName);
  my $Subscription= $cli->GetAccountSubscription($srcName);
  my $mailboxAliases=$cli->GetMailboxAliases($srcName);

  my $aliases=$cli->GetAccountAliases($srcName);
  my $rPOP=$cli->GetAccountRPOP($srcName);
       
  unless($cli->CreateAccount(accountName => $dstName,
                             settings => $settings,
                             accountType => $destAccountType)) {
    print "Can't create $dstName: ".$cli->getErrMessage."\n";
    return 1;   
  }


  $cli->SetAccountRights($dstName,$accessRights) if(@$accessRights);
  $cli->SetWebUser($dstName,$webSettings) if(%$webSettings);
  $cli->SetAccountSubscription($dstName,$Subscription) if(@$Subscription);
  $cli->SetMailboxAliases($dstName,$mailboxAliases) if(%$mailboxAliases);

  foreach (sort keys %$Boxes) {
    return -1 if(moveMailboxContents($srcName,$dstName,$_));
  }
  print $imap "x SELECT INBOX\015\012"; #move selection to postmaster's inbox
  do {
    $responseLine = <$imap>;
  }until($responseLine =~/^x /);   

  return -1 if(moveWebFiles($srcName,$dstName,""));

  if(@$aliases) {
    $cli->SetAccountAliases($srcName,[]);
    $cli->SetAccountAliases($dstName,$aliases)
  }  
  if(@$rPOP) {
    $cli->SetAccountRPOP($srcName,[]);
    $cli->SetAccountRPOP($dstName,$rPOP) ;
  }
  0;
}

sub moveMailboxContents {
  my ($srcName,$dstName,$boxName) = @_;
  print "Box: $boxName\n";

  my $info = $cli->GetMailboxInfo($srcName,$boxName);
  unless($info) {
      print qq/GetMailboxInfo "$boxName" for "$dstName" failed: /.$cli->getErrMessage."\n";
      return -1;
  }
  my $class=@$info{'Class'};
  
  if($boxName ne 'INBOX') {
    unless($cli->CreateMailbox($dstName,$boxName)) {
      print qq/Unable to create mailbox "$boxName" for "$dstName: /.$cli->getErrMessage."\n";
      return -1;
    } 
    $cli->SetMailboxClass($dstName,$boxName,$class) if($class);
  }
  
  my $acl = $cli->GetMailboxACL($srcName,$boxName);
  $cli->SetMailboxACL($dstName,$boxName,$acl) if(%$acl);

  print $imap qq|x SELECT "~$srcName/$boxName"\015\012|;
  do {
    $responseLine = <$imap>;
  }until($responseLine =~/^x /);
  return -1 unless($responseLine =~ /^x OK/);

  print $imap qq|x COPY 1:* "~$dstName/$boxName"\015\012|;
  do {
    $responseLine = <$imap>;
  }until($responseLine =~/^x /);
  return -1 unless($responseLine =~ /^x OK/);

  0;
}

sub moveWebFiles {
  my ($srcName,$dstName,$dirName) = @_;
# print "WebDir: $dirName\n";
  
  if($Files=$cli->ListWebFiles($srcName,$dirName)) {
    foreach (keys %$Files) {
      my $fileName=(($dirName eq '') ? '': ($dirName."/")).$_;
      if(ref(@$Files{$_}) eq 'ARRAY') {
        moveWebFiles($srcName,$dstName,$fileName);
      } else {
        print "WebFile: $fileName\n";
        my $data=$cli->GetWebFile($srcName,$fileName);
        unless($data) {
          print qq/Unable to read web file: /.$cli->getErrMessage."\n";
          return -1;
        }  
        @$data[0]=$1 if(@$data[0]=~/^\[(.*)\]$/);
        unless($cli->PutWebFile($dstName,$fileName,@$data[0])) {
          print qq/Unable to store web file: /.$cli->getErrMessage."\n";
          return -1;
        }  
      }
    }
  }  
  0;
}

