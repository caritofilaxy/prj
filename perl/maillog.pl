#!/usr/bin/perl

#use strict;
use warnings;

#die "Usage: $0 regexp" unless (scalar @ARGV == 1);

my $logfile = "/ap2/maillog";
die "cant open $logfile" unless open(my $log, "<", $logfile);

my %message_id;

#while(<$log>) {
#    if (/((?:(\w|\d){12})):.*$ARGV[0]/i) {
#        $message_id{$1} = 1;
#    }
#}

my $msg_id = "1E3EF29002BE";

for my $msg_id (keys %message_id) {
    seek($log, SEEK_SET, 0);
    while(<$log>) {
        $message_id{$msg_id} = { time_from => $1, from => $2 } if (/^(\w+?\s\d{,2}\s(?:(w+?|:))).*$msg_id:\sfrom=<(.*)?>/ );
        $message_id{$msg_id} = { time_to => $1, to => $2 }     if (/^(\w+?\s\d{,2}\s(?:(w+?|:))).*$msg_id:\sto=<(.*)?>/ );
    }
}

print $message_id{$msg_id}->{to}, "\n";
