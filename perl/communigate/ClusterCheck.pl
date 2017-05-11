#!/usr/bin/perl -w
#
# ClusterCheck.pl
# Checks Dymanic Cluster status - if all cluster members are online and connected to the same Controller. 
#
# Please mail your comments and suggestions to <support@communigate.com>


use strict;
use CLI;  #get one from www.stalker.com/CGPerl/


####  YOU SHOLD REDEFINE THESE VARIABLES !!!

my $Login='postmaster';
my $Password='pass';

my @Backends=("127.0.0.1","10.0.1.1","10.0.1.2"); #the IPs of Backends
my @Frontends=("127.0.0.1","10.0.0.1","10.0.0.2"); #the IPs of Frontends

my $SMTPserver='127.0.0.1'; #the SMTP server where to send the notification messages;
my $notifyAddress='admin@company.com'; #the e-mail address where to send the notofocation messages;

#### end of the customizeable variables list


my $controllerIP=undef;

foreach(@Backends) {
  my $newControllerIP=checkServer($_);
  if($controllerIP && $newControllerIP && $controllerIP ne $newControllerIP) {
    sendMessage("[ALERT] Cluster problem","The $_ Backend has $newControllerIP as the Controller.\nIt is diferent from $controllerIP which is used as the Controller for other servers and it may indicate about a cluster split."); 
  }
  $controllerIP=$newControllerIP if($newControllerIP && !$controllerIP);
}

foreach(@Frontends) {
  my $newControllerIP=checkServer($_);
  if($newControllerIP && $controllerIP ne $newControllerIP) {
    sendMessage("[ALERT] Cluster problem","The $_ Frontend has $newControllerIP as the Controller.\nIt is diferent from $controllerIP which is used as the Controller for other servers and it may indicate about a cluster split."); 
  }
}

exit(0);


sub checkServer {
  my($address)=@_;
  #print "Checking $address\n";
  my $cli = new CGP::CLI( { PeerAddr => $address,
                          PeerPort => 106,
                          login    => $Login,
                          password => $Password } );
  unless($cli) {
    sendMessage("[ALERT] $address is down","The $address cluster member is down");
    return undef;
  }                        
  my $controller=$cli->GetCurrentController();
  $cli->Logout;
  $controller;
}

sub sendMessage {
  my($subject,$body)=@_;
  
  $body=~s/\n/\015\012/g;
  $body=~s/^\./\.\./mg;
  
  my $smtp = new IO::Socket::INET(PeerAddr => $SMTPserver,
                                  PeerPort => 25
                                 )
     || die "*** Can't connect to $SMTPserver via SMTP.";                                
  $smtp->autoflush(1);
  my $responseLine;
  do {
    $responseLine = <$smtp>;
  }until($responseLine =~/^(\d\d\d) /);
  return $responseLine unless($1 eq '220');

#  print $smtp "HELO $LocalDomainName\015\012";
#  do {
#   $responseLine = <$smtp>;
#  }until($responseLine =~/^(\d\d\d) /);
#  return $responseLine unless($1 eq '250');
  
  print $smtp "MAIL FROM:<>\015\012";
  do {
    $responseLine = <$smtp>;
  }until($responseLine =~/^(\d\d\d) /);

  return $responseLine unless($1 eq '250');

  print $smtp "RCPT TO:<$notifyAddress>\015\012";
  do {
    $responseLine = <$smtp>;
  }until($responseLine =~/^(\d\d\d) /);
  die $responseLine unless($responseLine =~/^250 /);

  print $smtp "DATA\015\012";
  do {
    $responseLine = <$smtp>;
  }until($responseLine =~/^(\d\d\d) /);
  die $responseLine unless($1 eq '354');

  print $smtp "From: Cluster health check script\015\012";
  print $smtp "To: $notifyAddress\015\012";
  print $smtp "Subject: $subject\015\012";
  print $smtp "\015\012\015\012$body\015\012";

  
  print $smtp ".\015\012";
  do {
    $responseLine = <$smtp>;
  }until($responseLine =~/^(\d\d\d) /);

  print $smtp "QUIT\015\012";
  do {
    $responseLine = <$smtp>;
  }until($responseLine =~/^(\d\d\d) /);
  return undef;

 
}

__END__;
