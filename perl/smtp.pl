#!/usr/bin/perl
#
use strict;
use warnings;
use Net::SMTP;

my $mailfrom = "sender\@fromdomain.com";
my $rcptto = "recipient\@todomain.com";
my $body = "";

my $smtp = Net::SMTP->new('localhost');
$smtp->mail($mailfrom);
if ($smtp->to($rcptto)) {
$smtp->data();
$smtp->datasend("From: $mailfrom\n");
$smtp->datasend("To: $rcptto\n");
$smtp->datasend("Subject: knock knock\n");
#$smtp->datasend("MIME-Version: 1.0\n");
#$smtp->datasend("Content-Type: multipart/mixed; boundary=frontier\n");
#$smtp->datasend("Content-Transfer-Encoding: quoted-printable\n");
#$smtp->datasend("Content-Type: text/html; charset=\"UTF=8\"\n");
$smtp->datasend($body);
$smtp->dataend();
} else {
print "Error: ",
$smtp->message();
}
$smtp->quit;
