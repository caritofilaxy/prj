#!/usr/bin/perl -w
#
#  A simple CommuniGatePro log analysing script. Prints out incoming and outgoing
#  traffic details. 
#  The log files should be specified as parameters in commnad line. 
#  Make sure you have 'Major & Failures' or lower logging level
#  in Message log, Enqueur, Dequeuer, Local, WebUser, SMTP, and RPOP modules.
#
#  Please send your comments and suggestions to <support@stalker.com>
#
#  Revision date: 21-Jul-2003
#  Revision date: 23-Nov-2016
#  Revision date: 01-Jan-2017
#  Revision date: 20-Mar-2017

use strict;

if(@ARGV eq 0) {
  print "Usage: ./LogAnalyse.pl log_file [log_file ...]\n";
  exit;
}

my %MsgList;
my %PerAccountList;

my ($totalMailsIn,$totalBytesIn,$totalMailsOut,$totalBytesOut)=(0,0,0,0);

while(<>) {

  if(/\[(\d+)\]/) {
    my $id=$1;
  
#print "id=$id\n";    
    my ($src,$op,$size,$ret,$time,$rcpt);
    if(defined $MsgList{$id}) {
      my $data=$MsgList{$id};
      ($src,$op,$size,$ret,$time,$rcpt)=@$data;
    } else {
      $src=$op=$size=$ret=$time='???';$rcpt=[];
    }
    if(/\] report (composed) / || /\] (composed)/ || /\] (received)/ || / (fed)/ || /rule\(.* (->) /) {
      $src='unknown';
      $op=$1;
      if(/(\d\d:\d\d:\d\d\.\d+) /) {
        $time=$1; #substr($1,0,8);
      }
      if(/(\d+) bytes/) {
        $size=$1;
      }  
      if($op eq 'fed') {
        if(/is fed as \[(\d+)\]/) {
          $id=$1;
        }  
      } elsif($op eq '->') {
        if(/ -> \[(\d+)\]/) {
          $id=$1;
          $op='rule action';
        }  
      }
      if(/ \d RPOP/) {
        $op='RPOP';
      }
      if(/\((.+?)\)/) {
        $src=PurgeName($1);
      }elsif(/\d DEQUEUER.* report /) {
        $src='DEQUEUER report';
      }elsif(/\d PIPE /) {
        $src='PIPE';
      }  
    }elsif(/ 2 QUEUE\(\[/) {
      if(/ from <(.*?)>, (\d+) bytes /) {
        $ret=$1;$size=$2;
      }elsif(/ deleted/) {
        if(addMsg($id)) {
          delete $MsgList{$id};
          $id=undef;
        } 
      }
    }elsif(/ 2 DEQUEUER \[/) {    
      if(/ (delivered)/ || / (relayed)/) {
        my $dst_op=$1;
        /(\S*\(\S*\)?\S*)/;
        my $dst=PurgeName($1);
        /(\d\d:\d\d:\d\d\.\d+) /;
        my $tm=$1; #substr($1,0,8);
        push(@$rcpt,[$dst,$dst_op,$tm]);
      }
    }

    if($id) {
      $MsgList{$id}= [$src,$op,$size,$ret,$time,$rcpt];
    }
  }
}
#print "-----------------------------\n";

foreach my $id (keys %MsgList) {
  if(addMsg($id)) {
    delete $MsgList{$id};
    $id=undef;
  } 
}

if(%MsgList) {  # print messages that were not removed from queue
  print "\nUnprocessed messages:\n";
  foreach my $id (keys %MsgList) {
    my $data=$MsgList{$id};
    my ($src,$op,$size,$ret,$time,$rcpt)=@$data;
    foreach my $data2 (@$rcpt) {
      my ($dst,$dst_op,$tm)=@$data2;
      print "$tm id=$id Src=$src <$ret> ($op) To=$dst $dst_op ($size bytes)\n";
    }
  }  
}



if(%PerAccountList) { 
my ($id,$mailsIn,$bytesIn,$mailsOut,$bytesOut);
format STDOUT =
@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< @>>>> @>>>>>> @>>>> @>>>>>>
$id,$mailsIn,$bytesIn,$mailsOut,$bytesOut
.

# This will be displayed on the top of the each output page.
format STDOUT_TOP =
                                                 Mails         Mails
Address                                             In   Bytes   Out   Bytes
================================================ ===== ======= ===== =======
.

  print "\nPer Account Traffic:\n";
  foreach $id (sort keys %PerAccountList) {
    my $data=$PerAccountList{$id};
    ($mailsIn,$bytesIn,$mailsOut,$bytesOut)=@$data;
    write;
  }
  print '-' x 76 ."\n";
  $id="Total:";
  $mailsIn=$totalMailsIn;$bytesIn=$totalBytesIn;
  $mailsOut=$totalMailsOut;$bytesOut=$totalBytesOut;
  write;
}

sub addMsg {
  my ($id)=@_;
  my $data=$MsgList{$id};
  return 0 unless($data);
  my ($src,$op,$size,$ret,$time,$rcpt)=@$data;
  if($src ne '???') {
    foreach my $data (@$rcpt) {
      my ($dst,$dst_op,$tm)=@$data;
      print "$tm id=$id Src=$src <$ret> ($op) To=$dst $dst_op ($size bytes)\n";
      if($src eq 'PIPE') {
        AddToOutput("PIPE <$ret>",$size) if(isDesired($ret));
      } else {
        AddToOutput($src,$size) if(isDesired($src));
      }   
      AddToInput($dst,$size) if(isDesired($dst));
    }
    return 1;
  }
  return 0;
}

sub PurgeName {  # remove prefixes from some names
  my $name = $_[0];
  return $1 if($name =~/LOCAL\((.*)\)/);
  return $1 if($name =~/LIST\((.*)\)/);
 # return $1 if($name =~/SYSTEM\(\)(.*)/);

  return $2 if($name =~/SMTP\((.*)\)(.*)/);
  return $name; 
}

sub isDesired {
  my $addr= $_[0];

  return 1;  #remove this line for the filtered output

  if($addr =~/\@/) {
    return 1 if($addr =~/\@mydomain\.com/);  # insert your domain here
    return 0;  
  }
  return 0 if($addr =~/[\[\]\s]/);  # IP address or 'Dequeuer Report'
  return 1;  #or 0 if you don't want mails for the main domain to be counted
}

sub AddToOutput {
  my ($source,$size)= @_;
  my ($mailsIn,$bytesIn,$mailsOut,$bytesOut);
  if(defined $PerAccountList{$source}) {
    my $data=$PerAccountList{$source};
    ($mailsIn,$bytesIn,$mailsOut,$bytesOut)=@$data;
  } else {
    $mailsIn=$bytesIn=$mailsOut=$bytesOut=0;
  }
  ++$mailsOut; $bytesOut+=$size;
  ++$totalMailsOut; $totalBytesOut+=$size;
  $PerAccountList{$source}= [$mailsIn,$bytesIn,$mailsOut,$bytesOut];
}

sub AddToInput {
  my ($dest,$size)= @_;
  my ($mailsIn,$bytesIn,$mailsOut,$bytesOut);
  if(defined $PerAccountList{$dest}) {
    my $data=$PerAccountList{$dest};
    ($mailsIn,$bytesIn,$mailsOut,$bytesOut)=@$data;
  } else {
    $mailsIn=$bytesIn=$mailsOut=$bytesOut=0;
  }
  ++$mailsIn; $bytesIn+=$size;
  ++$totalMailsIn; $totalBytesIn+=$size;
  $PerAccountList{$dest}= [$mailsIn,$bytesIn,$mailsOut,$bytesOut];
}

