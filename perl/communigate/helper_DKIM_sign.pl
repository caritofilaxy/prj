#!/usr/bin/perl -w

=head1 NAME

helper_DKIM_sign.pl

=head1 DESCRIPTION

An external filtering helper for CommuniGate Pro mail server
Adds DKIM signatures to outgoing messages.
Based on Mail::DKIM::Signer module.

=head1 INSTALLATION

Creating keys:
 To create the keys run these commands:
   openssl genrsa -out dkim.key 1024
   openssl rsa -in dkim.key -out dkim.public -pubout -outform PEM
 You will find two files: dkim.key & dkim.public.
 Open dkim.public and copy the contents excluding the –Begin– and –End– section. This is your DKIM key.  

Adding DNS records for signature verification:
 Choose a value for Selector, e.g. "mx1" or "mail"
 Create DNS record in the following format with your key in "p=" (assuming your domain is "domain1.dom" and the Selector is "mail")
   mail._domainkey.domain1.dom. IN TXT "v=DKIM1; g=*; k=rsa; p=..."

Configuring the helper:
 Fill the %domainList dictionary below.

Configuring CommuniGate Pro:
 Create a helper:
   Name: DKIM_sign
   Program Path: /usr/bin/perl helper_DKIM_sign.pl

 Then create a server-wide rule: 
   Data:
   [Source] [in] [trusted,authenticated]
   [Header Field] [is not] [DKIM-Signature:*]
   Action:
   [ExternalFilter] DKIM_sign

=head1 AUTHORS

Please mail your comments to support@communigate.com

=cut

use Mail::DKIM::Signer;  # http://search.cpan.org/~jaslong/Mail-DKIM/lib/Mail/DKIM/Signer.pm
use Mail::DKIM::TextWrap;  #recommended 
use strict;
use threads;
use Thread::Queue; 

## BEGIN CONFIG

my %domainList = (
  'domain1.dom' => {
    Algorithm => "rsa-sha256",
    Method => "relaxed",
    Selector => "mail",
    KeyFile => "domain1.key",
  }, 
  'domain2.dom' => {
    Algorithm => "rsa-sha1",
    Method => "relaxed/relaxed",
    Selector => "mail",
    KeyFile => "domain2.key",
  }, 

);

my $nThreads=5;	

## END CONFIG

$| = 1;
print "* helper_DKIM_sign.pl started.\n";

my $mainQueue = Thread::Queue->new();
foreach my $i (1..$nThreads) {
  my $thr = threads->create(\&threadProc, "thread#$i" );
} 



while(<STDIN>) {
  chomp;
  my ($command,$prefix);
  my @args;             
  ($prefix,$command,@args) = split(/ /);
  if($command eq 'INTF') {
    print "$prefix INTF 3\n";

  } elsif($command eq 'QUIT') {
    print "$prefix OK\n";
    last; 
  } elsif($command eq 'KEY') {
    print "$prefix OK\n";
  } elsif($command eq 'FILE') {
    $mainQueue->enqueue([$prefix,$args[0]]); 
     #  processFILE($prefix,$args[0]); 
  } else {
    print "$prefix ERROR unexpected command: $command\n";
  }
}

foreach (1..$nThreads) {
    $mainQueue->enqueue(undef);
}    
foreach my $thr (threads->list()) {
  $thr->join();
} 

print "* stoppig helper_DKIM_sign.pl\n";
exit(0);




sub processFILE {
  my ($prefix,$fileName) = @_;
  
  unless( open (FILE,"$fileName")) {
    print qq/$prefix REJECTED can't open $fileName: $!\n/;
    return undef;
  }
  
  while(<FILE>) { #skip the envelope
    chomp;
    last if($_ eq '');
  }    
  my @messageHeader;
  while(<FILE>) { #read the header
    chomp;
    s/\015$//;
    push(@messageHeader,$_);
    last if($_ eq '');
  }
  
  my $fromAddress; 
  for(my $i=0;$i<scalar @messageHeader;$i++) {
    my $h=$messageHeader[$i];
    while($i+1<scalar @messageHeader && $messageHeader[$i+1]=~/^\s+(.*)/) {
      $h.=" ".$1; $i++;
    }
    if($h=~/^From:\s*(.*)/i) {
      $fromAddress=lc($1) if(!$fromAddress);
    }    
  }
  unless($fromAddress) {
    print qq/$prefix ERROR "no 'From:' address"\n/;
    close(FILE);
    return undef;
  }
  $fromAddress=~/\@(.*)/;
  my $domain=lc($1);
  $domain=$1 if($domain=~/^(.*)[\s>]/);

  my $domainRef=$domainList{$domain};
  unless($domainRef) {
    print qq/$prefix OK the '$domain' is not served\n/;
    close(FILE);
    return undef;
  }

  my $dkim = Mail::DKIM::Signer->new(
                  Domain => $domain,
                  Algorithm => $domainRef->{Algorithm} || "rsa-sha1",
                  Method => $domainRef->{Method} || "relaxed",
                  Selector => $domainRef->{Selector} || "selector1",
                  KeyFile => $domainRef->{KeyFile} || "myprivate.key",
             );

  $dkim->PRINT(join("\015\012",@messageHeader)."\015\012");

  my $msgText=''; 
  while(<FILE>) { #read the mesage
    chomp;
    s/\015$//;
    $msgText.="$_\015\012";
    if(length($msgText)>32*1024) { # using big chunks is faster
      $dkim->PRINT($msgText);
      $msgText='';
    }  
  }
  $dkim->PRINT($msgText) if($msgText);

  $dkim->CLOSE;
  close(FILE);


  my $signature = $dkim->signature->as_string;
  
  if($signature) {
    $signature=~s/\015\012/\\e/g;
    $signature=~s/\t/\\t/g;
    $signature=~s/\"/\\\"/g;
    print qq/$prefix ADDHEADER "$signature"\n/;
  } else {
    print qq/$prefix OK failed to sign\n/;
  }
  return undef; 
}#processFile

sub threadProc {
  my ($name)=@_;
  while (my $data = $mainQueue->dequeue()) {
    processFILE($data->[0],$data->[1]);
  }
} 

__END__


