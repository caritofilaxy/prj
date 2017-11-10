#!/usr/bin/perl

#
#	$msg_hash = {
#		$msgid => { time_from => $time_from,
#					from => $from, 
#					time_to => $time_to,
#					to => $to,
#					status => $status,
#					},
#	}
#
#




use strict;
use warnings;

use Data::Dumper;

die "Usage: $0 regexp" unless (scalar @ARGV == 1);

my $logfile = "../../../Downloads/maillog_0";
die "cant open $logfile" unless open(my $log, "<", $logfile);

my $msg_hash;

while(<$log>) {
    if (/((?:(\w|\d){12})):.*$ARGV[0]/i) {
        $msg_hash->{$1} = undef;
    }
}

for my $msg (keys %{$msg_hash}) {
    seek($log, 0, 0);
    while(<$log>) {
    	if (/$msg:\sfrom=<(.*)?>/ ) {
			my $tmp = $1;
			$msg_hash->{$msg}->{ from => $tmp };
		}	
	}
}
print Dumper(%{$msg_hash});



