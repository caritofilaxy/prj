#!/usr/bin/perl -w
#
# executeCLI.pl
# Allows to execute a CLI command quickly from OS shell.
#
# Usage: ./executeCLI.pl "command { \"parameters\" }"
# 
# Please mail your comments and suggestions to <support@communigate.com>


use strict;
use IO::Socket;
use Digest::MD5;


####  YOU SHOLD REDEFINE THESE VARIABLES !!!

my $CGServerAddress='127.0.0.1';  #IP or domain name;
my $Login='postmaster';
my $Password='pass';


#### end of the customizeable variables list

die 'Usage: ./executeCLI.pl "command { \"parameters\" }"' if(@ARGV<1);

my $command=$ARGV[0];

print "Command: $command\n";

my $cli = new IO::Socket::INET(   PeerAddr => $CGServerAddress,
                                    PeerPort => 106,
                                  ) 
   || die "*** Can't connect to CGPro via CLI.\n";                                

$cli->autoflush(1);
my $responseLine = <$cli>;
my $errCode=undef;
my $hasData=undef;
#print "$responseLine\n";

$responseLine =~ /(\<.*\@*\>)/;
    my $md5=Digest::MD5->new;
    if($md5) {
      $md5->add($1.$Password);
      clisend('APOP '.$Login.' '.$md5->hexdigest);
      _parseResponse();
    } else {
      close($cli);
      die "Can't create MD5 object";
    }

if($errCode) {
  die "Can't login via CLI: $errCode\n";
}

clisend($command);
_parseResponse();
print $responseLine;
if((!$errCode) && $hasData) {
  print getWords();
}
clisend("Quit");
_parseResponse();

exit(0);

sub clisend {
  my ($command) = @_;
  #print "Sending: $command\n";
  print $cli "$command\012\015";
}

sub _parseResponse {

  $responseLine = $cli->getline();
#print "Getting: $responseLine";
  if($responseLine =~ /data follow/) {
    $hasData=1;
  } else {
    $hasData=undef;
  }

  $responseLine =~ /^(\d+)\s(.*)$/;
   if($1 != 200) {
    $errCode = $responseLine; #$2;
  }

}


sub getWords {
  my ($bag, $line) = ('', '');
  my $firstLine = 1;
  my $lastLine = '';
  while (1) {
    $line = $cli->getline();
    chomp $line;
    #$line =~ s/^\s+//;
    $line =~ s/\s+$//;

    #$line = strip($line);
    if($firstLine) {
      $line =~ /^(.)/;
      if ($1) {
        $lastLine = '\)' if $1 eq '(';
        $lastLine = '\}' if $1 eq '{';
        $lastLine = $lastLine . '$';
        $firstLine = 0;
      }
    }
    $bag .= $line."\n";
    last if $line =~ /$lastLine/;
  }
  return $bag;
}

__END__
