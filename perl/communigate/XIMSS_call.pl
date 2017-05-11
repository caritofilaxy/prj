#!/usr/bin/perl -w
use strict;
use Socket;
use Data::Dumper;

#### you need to redefine these values

my $CGServerAddress='127.0.0.1';  #IP or domain name of your CommuniGate server

my $CGServerLogin='user@domain.com'; # your full account name with domain part
my $CGServerPassword='pass';         # your password
my $destinationURI='someone@somewhere.'; # to whom you call 
my $port = 11024;
my $debug=1;
#### end of the customizeable variables list


print "Starting.\n";
my $ip=inet_aton($CGServerAddress) || die "no host: $CGServerAddress\n";
my $CGServerIP=inet_ntoa($ip) || die "no host: $CGServerAddress";


my $errCode;
my @responses;

$errCode=XIMSS_Connect($CGServerAddress,$port);
if($errCode) {
  print "Unable to connect to CGPro XIMSS: $errCode\n";
  exit(1);
}


$errCode=XIMSS_Login($CGServerLogin,$CGServerPassword);
if($errCode) {
  print "Login failed: $errCode\n";
} else { 
  my $callID='c'.int(rand(100000)); #a random ID for the call leg
  $errCode=XIMSS_CallStart($CGServerLogin,$callID);
 
  if($errCode) {
    print "CallStart failed: $errCode\n"; 
  } else {
    $errCode=XIMSS_CallTransfer($destinationURI,$callID);
    print "CallTransfer failed: $errCode\n" if($errCode);
  }
  
  XIMSS_Logout();
}

XIMSS_Disconnect();
print "Done.\n";
exit(0);



sub XIMSS_Connect {
  my ($address,$port)=@_;
  $port=11024 unless($port);
  
  my $iaddr   = inet_aton($address);
  unless($iaddr) {
    return "no host: $address";
  }  
  my $paddr   = sockaddr_in($port, $iaddr);

  my $proto   = getprotobyname('tcp');
  unless(socket(SOCK, PF_INET, SOCK_STREAM, $proto)) {
    return "socket error: $!";
  }  
  unless(connect(SOCK, $paddr)) {
    return "connect error: $!";
  }
  undef;
}

sub XIMSS_Disconnect {
  close (SOCK) || die "close: $!";
}

sub XIMSS_Login {
  my ($login,$password)=@_;
  #sendCommand(qq{<login id="x001" authData="$login" password="$password"/>});
  return checkError(XIMSS_command('login',{authData=>$login,password=>$password}));
}

sub XIMSS_Logout {
  return checkError(XIMSS_command('bye'));
}

sub XIMSS_CallStart {
  my ($login,$callID)=@_;
  my $body=<<EOT;
<sdp ip="[$CGServerIP]" origUser="-" sessionID="7777777" sessionVersion="9999" originIP="[$CGServerIP]">
    <media media="audio" ip="[$CGServerIP]:16398" protocol="RTP/AVP" direction="sendrecv">
        <codec id="0" name="PCMU/8000" />
        <codec id="4" name="G723/8000" />
        <codec id="8" name="PCMA/8000" />
        <codec id="101" name="telephone-event/8000" format="0-15"/>
    </media>
</sdp>
EOT
  my $data=XIMSS_command('callStart',{callLeg=>$callID,peer=>"$login;services=no"},$body);
  my $errCode=checkError($data);
  return($errCode) if($errCode);
  
  my $waitTill=time()+10; #wait for 10 seconds at max
  while(time()<=$waitTill) {
    if($data=findResponse('callConnected')) { return checkError($data); };
    if($data=findResponse('callDisconnected')) { return "callDisconnected: ".checkError($data); };
    if($data=findResponse('callOpFailed')) { return "callOpFailed: ".checkError($data); };
    @responses=();
    if(isReadable()) { 
      XIMSS_readProvisioning();
    } else {
      sleep(1);
    }
  }

  return 'a timeout';
  
}

sub XIMSS_CallTransfer {
  my ($peer,$callID)=@_;
  my $data=XIMSS_command('callTransfer',{callLeg=>$callID,peer=>$peer});
  my $errCode=checkError($data);
  return($errCode) if($errCode);
  
  my $waitTill=time()+10; #wait for 10 seconds at max
  while(time()<=$waitTill) {
    if($data=findResponse('callConnected')) { return checkError($data); };
    if($data=findResponse('callDisconnected')) { return "callDisconnected: ".checkError($data); };
    if($data=findResponse('callOpFailed')) { return "callOpFailed: ".checkError($data); };
    @responses=();
    if(isReadable()) { 
      XIMSS_readProvisioning();
    } else {
      sleep(1);
    }
  }
  return 'a timeout';
}


my $idCounter=0;

sub XIMSS_command {
  my ($command, $paramsRef,$body)=($_[0],$_[1],$_[2]);

  my $id='a'.$idCounter++;
  my $cmd="<$command id=\"$id\"";
  if($paramsRef) {
    if(ref($paramsRef) eq 'HASH') {
      foreach(keys(%$paramsRef)) {
        if(@$paramsRef{$_}) {
          $cmd.=" $_=\"@$paramsRef{$_}\"";
        } else {
          $cmd.=" $_=\"\"";
        }  
      }
    } else {
      $cmd.=' '.$paramsRef;
    }
  }  
  if($body) {
    $cmd.=">$body</$command>";
   } else {  
    $cmd.='/>';
  }
  sendCommand($cmd);
  
  @responses=();
  while(my $line = readLine()) {
    print "response: $line\n" if($debug);
    if($line =~ /^<response id=\"$id\"/ ) { #"
      return $line;
    }
    push(@responses,$line);
  }
  undef;
}

sub XIMSS_readProvisioning {
  while(isReadable()) {
    my $line = readLine();
    print "provisioned: $line\n" if($debug);
    push(@responses,$line);
  }
}

sub findResponse {
  my ($cmd)=@_;
  foreach(@responses) {
    if(ref($_) eq 'ARRAY' && $_->[0] =~ /$cmd/i) {
      return $_;
    } elsif($_ =~ /<$cmd/i) {
      return $_;
    }
  }
  undef;
}
 
sub checkError {
  my $dataRef=$_[0];
  return '' unless($dataRef);
  #print "errorCheck=".Dumper($dataRef)."\n";  

  if(ref($dataRef) eq 'ARRAY') { #parsed XML
    my $lastItem=$dataRef->[scalar(@$dataRef)-1];
    if(ref($lastItem) eq 'ARRAY') {
      $lastItem=$lastItem->[0];
      if(ref($lastItem) eq 'HASH') {
        my $eText=@$lastItem{'errorText'};
        return $eText if($eText);
      }
    }
  } else { #raw XML string
    if($dataRef=~/errorText=\"(.*?)\"/) {
      return $1;
    }
  }
  return '';
} 
 
sub sendCommand {
  my ($command)=@_;
  print "sending: $command\n" if($debug);
  send(SOCK,$command ."\0",0);
}

sub isReadable {
 my $rin = '';
 vec($rin, fileno(SOCK), 1) = 1;
 return select( $rin, undef, undef, 0);
}
    
sub readLine {
  my $ln='';
  for(;;) {
    my $ch;
    recv(SOCK,$ch,1,0);
    last if($ch eq "\0");
    $ln.=$ch;
  }
  return $ln;
}


__END__
