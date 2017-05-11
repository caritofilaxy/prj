#!/usr/bin/perl -w

# CommuniGate Pro base plugin
#
# Usage: CGP-helper-plugin.pl
# Example: perl CGP-helper-plugin.pl 
#
# Please mail your comments and suggestions to <support@stalker.com>
#

use strict;
use IO::Socket;

$| = 1;     

my ($errorMsg,$DIR);

## config
$DIR = '/var/tmp';
## end config

print "* CGP-helper-plugin v0.1 started\n";

while(<STDIN>) {
  chomp;             
  my ($prefix,$command,@args) = split(/ /);

  if($command eq 'INTF') {
    print "$prefix INTF 3\n";
  } elsif($command eq 'QUIT') {
    print "$prefix OK\n";
    last; 
  } elsif($command eq 'KEY') {
    print "$prefix OK\n";
  } elsif($command eq 'FILE') {
    processFILE($prefix,$args[0]); 
  } elsif($command eq 'CDR') {
    processCDR($prefix,@args); 
  } elsif($command eq 'VRFY') {
    verifyUser($prefix,$args[0]); 
  } elsif($command =~ /^SASL/) {
    verifySASL($prefix,$args[0]); 
  } else {
    print "$prefix ERROR unexpected command: $command\n";
  }
}

print "* CGP helper plugin stopped\n";

exit(0);

sub processCDR {
  my ($prefix,@args) = @_;

  # do something with CDR
  unless( open (FILE,">>","$DIR/CDR.$prefix")) {
    print "$prefix FAILURE can't write $DIR/CDR.$prefix: $!\n"; 
    return undef;
  }

  print FILE "@args\n" ||
	(print "$prefix FAILURE can't write $DIR/CDR.$prefix: $!\n" &&
	return undef);

  print qq/$prefix OK\n/;

  close (FILE);
}

sub processFILE {
  my ($prefix,$fileName) = @_;
 
  unless( open (FILE,"$fileName")) {
    print "$prefix FAILURE can't open $fileName: $!\n"; 
    return undef;
  }

  my $returnPath;
  my @recipients;

  while(<FILE>) {
    chomp;
    last if($_ eq '');
    my $address=(/\<(.*)\>/)[0];
    if(/^P/) { $returnPath=$address; }
    elsif(/^R/) { push(@recipients,$address);}
  }

  # modify to "do something"
  #my $errorMsg=doSomething($returnPath,\@recipients,\*FILE);

  if($errorMsg) {
    chomp($errorMsg);
    chop($errorMsg);
    print qq/$prefix ERROR "$errorMsg"\n/;

  } else {
    print qq/$prefix OK\n/;
  }
  
  close(FILE);
 
}

sub verifyUser {
    my ($prefix,@args) = @_;

    # do something

    print qq/$prefix ERROR auth failed\n/;
}

sub verifySASL {
    my ($prefix,@args) = @_;

    # do something

    print qq/$prefix ERROR auth failed\n/;
}

