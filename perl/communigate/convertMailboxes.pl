#!/usr/bin/perl -w
#
# ConvertMailboxes.pl
#
# The mailbox conversion script for CommuniGate Pro.
# version 1.1 Tue, Feb 22, 2005 
# version 1.2 Tue, Jun 10, 2008 
# version 1.3 Aug 28, 2008 
# version 1.4 Oct 15, 2008 
# version 1.5 Jul 23, 2013 
# version 1.6 Nov 21, 2016
# version 1.7 Jan 11, 2017
# version 1.8 Mar 15, 2017

#
# Using this script you can convert accounts' mailboxes from one mailbox format to another (.mbox/.mdir/.mslc)
#
# Unlike other scripts which convert files directly, this one
# doesn't require shutting down the server.
#
# This script works with CGPro 5.1.0 or later.
#
# You can convert either one selected account, or all accounts in a domain,
# or all accounts in all domains, or account list from a file; un-comment the proper line in the script text.
#
# Mail your comments to support@communigate.com
#

use strict;
use CLI;  #get one from www.stalker.com/CGPerl


####  YOU SHOLD REDEFINE THESE VARIABLES !!!

my $CGServerAddress='127.0.0.1';  #IP or domain name;
my $Login='postmaster';
my $Password='pass';

my $destMailboxType='SlicedMailbox'; # 'MailDirMailbox' or 'TextMailbox' or 'SlicedMailbox';

# $useMailboxList values:
# 0 - convert all mailboxes, ignore the list
# 1 - convert only mailboxes included into convMailboxList
# 2 - convert all except included into convMailboxList
my $useMailboxList=0; 
my @convMailboxList = ('INBOX','Sent Items','Trash' );

my $disableQuota=1; # to prevent the error while convertin

#### end of the customizeable variables list


my $imap = new IO::Socket::INET(   PeerAddr => $CGServerAddress,
                                    PeerPort => 143,
                                    Timeout  => 600
                                  ) 
   || die "*** Can't connect to CGPro via IMAP.\n";                                

$imap->autoflush(1);
my $responseLine = <$imap>;

print $imap "x LOGIN $Login $Password\015\012";
do {
  $responseLine = <$imap>;
}until($responseLine =~/^x /);
die "*** Can't login to CGPro IMAP: $responseLine.\n"
  unless($responseLine =~ /^x OK/);

print $imap "x ENABLE EXTENSIONS\015\012";
do {
  $responseLine = <$imap>;
}until($responseLine =~/^x /);


my $imap2 = new IO::Socket::INET(   PeerAddr => $CGServerAddress,
                                    PeerPort => 143,
                                    Timeout  => 600
                                  ) 
   || die "*** Can't connect to CGPro via IMAP.\n";                                

$imap2->autoflush(1);
$responseLine = <$imap2>;

print $imap2 "x LOGIN $Login $Password\015\012";
do {
  $responseLine = <$imap2>;
}until($responseLine =~/^x /);
die "*** Can't login to CGPro IMAP: $responseLine.\n"
  unless($responseLine =~ /^x OK/);


my $cli = new CGP::CLI( { PeerAddr => $CGServerAddress,
                          PeerPort => 106,
                          login    => $Login,
                          password => $Password } )
   || die "*** Can't login to CGPro CLI: ".$CGP::ERR_STRING."\n";


# un-comment one of the below 4 lines

processAccount('user@company.com');
#processDomain('company.com');
#processAllDomains();
#processFile('accountList.txt');

print "Done\n";
$cli->Logout();
print $imap "x LOGOUT\015\012";
print $imap2 "x LOGOUT\015\012";
exit;

sub processFile {
  my ($fname)=@_;
  open(FILE,$fname) || die "can't open $fname: $!\n";
  while(<FILE>) {
    chomp;
    next if(/^#/);
    my $account=$_;
    if(length($account)>3) {
      processAccount($account);
    }
  }
  close(FILE);
}

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
  my $accountList = $cli->ListAccounts($domain);
  unless($accountList) {
    print "*** Can't get accounts for $domain: ".$cli->getErrMessage."\n";
    return;
  }  
  foreach(keys %$accountList) {
    processAccount("$_\@$domain"); 
  }  
}

sub processAccount {
  my $account=$_[0];
  my $mboxTypeSwitch=0;
  my ($oldQuota,$oldMaxMessageSize);
  print " Account: $account\n";

  my $effSettings=$cli->GetAccountEffectiveSettings($account);
  unless($effSettings) {
    print "*** Can't get settings for $account: ".$cli->getErrMessage."\n";
    return;
  }

  if(@$effSettings{'DefaultMailboxType'} ne $destMailboxType) {
    $cli->UpdateAccountSettings($account,{ DefaultMailboxType => $destMailboxType });
    $mboxTypeSwitch=1; 
  }

  if($disableQuota) {
    my $data=$cli->GetAccountSettings($account);
    $oldQuota=$data->{MaxAccountSize} if($data->{MaxAccountSize});
    $oldMaxMessageSize=$data->{MaxMessageSize} if($data->{MaxMessageSize});
    $cli->UpdateAccountSettings($account,{ MaxAccountSize => 'unlimited',MaxMessageSize => 'unlimited',});
  }

  unless($cli->KillAccountSessions($account)) {
#    print "*** Can't kill sessions for $account: ".$cli->getErrMessage."\n";
#    return;
  }

  my $mailboxesList=$cli->ListMailboxes(accountName=>$account);  
  unless($mailboxesList) {
    print "*** Can't list mailboxes for $account: ".$cli->getErrMessage."\n";
    return;
  }


  
  foreach(sort keys %$mailboxesList) {
    my $data=@$mailboxesList{$_};
    if(ref $data eq 'ARRAY') {
      $data=@$data[0];
    }   
    if(ref $data eq 'HASH') {
      my $mailbox=$_;
      my $nMessages=@$data{'Messages'};
      $nMessages=$1 if($nMessages && $nMessages=~/(\d+)/);

      my $size=@$data{'Size'};
      $size=$1 if($size && $size=~/(\d+)/);


      my $class=@$data{'Class'};
      
      if($useMailboxList == 0) {
        processMailbox($account,$mailbox,$nMessages,$size,$class);
      } elsif($useMailboxList == 1) {
        foreach(@convMailboxList) {
          if($_ eq $mailbox) {
            processMailbox($account,$mailbox,$nMessages,$size,$class);
            last;
          }
        }  
      } elsif($useMailboxList == 2) {
        my $found=0;
        foreach(@convMailboxList) {
          if($_ eq $mailbox) {
            $found=1;
            last;
          }
        }  
        processMailbox($account,$mailbox,$nMessages,$class) unless($found);
      } else {
        die "wrong value of \$useMailboxList";
      }
    }
  }  
  if($disableQuota) {
    #$oldQuota='Default' unless($oldQuota);
    $cli->UpdateAccountSettings($account,{ MaxAccountSize => ($oldQuota || 'Default'), MaxMessageSize => ($oldMaxMessageSize || 'Default') });
    
  }  
  if($mboxTypeSwitch) {
    $cli->UpdateAccountSettings($account,{ DefaultMailboxType => 'Default' });
  } 

}

sub processMailbox {  
  my ($account,$mailbox,$nMessages,$size,$mboxClass)=@_;
  my $tempMailbox="$mailbox--old--";
  my $delTempMailbox=1;

  #return if($inboxOnly && $mailbox ne 'INBOX');
  print "  Mailbox: $mailbox ($nMessages/$size)\n";

  my $mbInfo=$cli->GetMailboxInfo($account,$mailbox);
  unless($mbInfo) {
    print "*** Can't get info ~$account/$mailbox: ".$cli->getErrMessage."\n";
    return;
  }

  my $isLocked=($mbInfo->{Lock} && $mbInfo->{Lock}=~/YES/i);
  if($isLocked) {
    $cli->SendCommand("UpdateMailboxInfo $account MAILBOX ".$cli->printWords($mailbox)." {Lock=Default;}");
  }
  
  my $acl = $cli->GetMailboxACL($account,$mailbox);
  
  unless($cli->RenameMailbox($account,$mailbox,$tempMailbox)) {
    print "*** Can't rename ~$account/$mailbox: ".$cli->getErrMessage."\n";
    return;
  }
  
  if($mailbox ne 'INBOX' && !$cli->CreateMailbox($account,$mailbox)) {
    print "*** Can't create new ~$account/$mailbox: ".$cli->getErrMessage."\n";
    return;
  }
  $cli->SetMailboxACL($account,$mailbox,$acl) if(%$acl);
  $cli->SetMailboxClass($account,$mailbox,$mboxClass) if($mboxClass);
  
  if($nMessages) {
    print $imap qq{x SELECT "~$account/$tempMailbox"\015\012};
    do {
      $responseLine = <$imap>;
    }until($responseLine =~/^x /);
    unless($responseLine =~ /^x OK/) {
      print "*** Can't select ~$account/$tempMailbox: ". $responseLine."\n";
      $cli->RenameMailbox($account,$tempMailbox,$mailbox);
      return;
    }

    # should work faster if the target mailbox is oopen
    print $imap2 qq{x SELECT "~$account/$mailbox"\015\012};
    do {
      $responseLine = <$imap2>;
    }until($responseLine =~/^x /);
    unless($responseLine =~ /^x OK/) {
      print "*** Can't select ~$account/$mailbox: ". $responseLine."\n";
      $cli->RenameMailbox($account,$tempMailbox,$mailbox);
      return;
    }


    print $imap qq{x COPY 1:* "~$account/$mailbox"\015\012};
    do {
      $responseLine = <$imap>;
    }until($responseLine =~/^x /);
    unless($responseLine =~ /^x OK/) {
      print "*** Can't move messages from ~$account/$tempMailbox: ". $responseLine .", will try by one...\n";

      for(my $idx=1;$idx<=$nMessages;$idx++) {
        print $imap qq{x COPY $idx "~$account/$mailbox"\015\012};
        do {
          $responseLine = <$imap>;
        }until($responseLine =~/^x /);
        if($responseLine =~ /^x OK/) {
          print $imap qq{x STORE $idx +FLAGS (\\Deleted)\015\012};
          do {
            $responseLine = <$imap>;
          }until($responseLine =~/^x /);
        } else {
          print "*** Can't copy message $idx from ~$account/$tempMailbox: ". $responseLine."\n";
          $delTempMailbox=0;
        }

      } 

    }

    print $imap "c CLOSE\015\012";
    do {
      $responseLine = <$imap>;
    }until($responseLine =~/^c /);
    unless($responseLine =~ /^c OK/) {
      print "*** Can't close ~$account/$tempMailbox: $responseLine.\n";
    }

    print $imap2 "c UNSELECT\015\012";
    do {
      $responseLine = <$imap2>;
    }until($responseLine =~/^c /);
    unless($responseLine =~ /^c OK/) {
      print "*** Can't unselect ~$account/$mailbox: $responseLine.\n";
    }

  }

  if($isLocked) {
    $cli->SendCommand("UpdateMailboxInfo $account MAILBOX ".$cli->printWords($mailbox)." {Lock=YES;}");
  }

  if($delTempMailbox) {
    unless($cli->DeleteMailbox($account,$tempMailbox)) {
      print "*** Can't delete ~$account/$tempMailbox: ".$cli->getErrMessage."\n";
    }
  }
  
}


__END__

