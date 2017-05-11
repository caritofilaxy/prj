#!/usr/bin/perl

=head1 NAME

helper_DKIM_verify.pl

=head1 DESCRIPTION

An external filtering helper for CommuniGate Pro mail server
Verifies DKIM signatures and adds a header with the verification result
Based on Mail::DKIM::Verifier module

=head1 INSTALLATION

Configuring CommuniGate Pro:
 Create a helper:
   Name: DKIM_verify
   Program Path: /usr/bin/perl helper_DKIM_verify.pl

 Then create a server-wide rule: 
   Data: [Header field] [is] [DKIM-Signature:*]
   Action: [ExternalFilter] DKIM_verify

=head1 AUTHORS

Please mail your comments to support@communigate.com

=cut

use Mail::DKIM::Verifier; # http://search.cpan.org/~jaslong/Mail-DKIM/lib/Mail/DKIM/Verifier.pm
use strict;
use threads;
use Thread::Queue; 

## BEGIN CONFIG

my $Header="DKIM-Check-Result";
my $nThreads=5;	

## END CONFIG

$| = 1;
print "* helper_DKIM_verify.pl started.\n";

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

print "* stoppig helper_DKIM_verify.pl\n";
exit(0);




sub processFILE {
  my ($prefix,$fileName) = @_;
 
  
  unless( open (FILE,"$fileName")) {
    print qq/$prefix REJECTED can't open $fileName: $!\n/;
    return undef;
  }
  my $dkim = Mail::DKIM::Verifier->new();

  while(<FILE>) { #skip the envelope
    chomp;
    last if($_ eq '');
  }    
  while(<FILE>) {
    chomp;
    s/\015$//;
    $dkim->PRINT("$_\015\012");
  }
  close(FILE);
  $dkim->CLOSE;
  #my $result = $dkim->result;
  my $result = $dkim->result_detail;

  print qq/$prefix ADDHEADER "$Header: $result"\n/;

  return undef; 
}#processFile

sub threadProc {
  my ($name)=@_;
  while (my $data = $mainQueue->dequeue()) {
    processFILE($data->[0],$data->[1]);
  }
} 


__END__


