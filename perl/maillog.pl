#!/usr/bin/perl

#use strict;
use warnings;

#die "Usage: $0 regexp" unless (scalar @ARGV == 1);

use Data::Dumper;

my $logfile = "../../../Downloads/maillog_0";
die "cant open $logfile" unless open(my $log, "<", $logfile);

my $message_id = {};

while(<$log>) {
    if (/((?:(\w|\d){12})):.*$ARGV[0]/i) {
        $message_id->{$1} = undef;
    }
}

#my $msg_id = "1E3EF29002BE";

my $table;

for my $msg_id (keys %{$message_id}) {
    seek($log, 0, 0);
	$table->{$msg_id} = {};
    while(<$log>) {
    	$table->{$msg_id} = { "time_from" => $1, "from" => $2 } 
							if (/^(\w+\s\d\d?\s\d+?\:\d+?\:\d+?)\s.*$msg_id:\sfrom=<(.*)?>/ ); 
		$table->{$msg_id} = { "time_to" => $1, "to" => $2 } 
							if (/^(\w+\s\d\d?\s\d+?\:\d+?\:\d+?)\s.*$msg_id:\sto=<(.*)?>/ ); 
	}
}

print Dumper($table);
