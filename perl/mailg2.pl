#!/usr/bin/perl 

#use strict;
use warnings;

die "Usage: $0 regexp" unless (scalar @ARGV == 1);

use Data::Dumper;

my $logfile = "../../../Downloads/maillog";
die "cant open $logfile" unless open(my $log, "<", $logfile);

my $strings = {};;
my $line_pattern = qr/^(\w+\s+\d\d?\s+\d+\:\d+\:\d+)\s+.+?:\s+(.+?):\s+(.+$ARGV[0].+)/;


while(<$log>) {
    if (/$line_pattern/) {
		my $msg = $2;
        $strings->{$2} = undef;
    }
}

my $ids = [ keys %{$strings} ];

my $hash = {};
my $rec = {};
my $to_list = [];

foreach my $id (@{$ids}) {
	seek($log, 1, 0);
	$hash->{$id} = $rec;
	while (<$log>) {
		$hash->{$id}->{$rec} = { from => $1 } if (/$id.+from=<(.+?)>/);
		$hash->{$id}->{$rec} = { to => $1 } if (/$id.+to=<(.+?)>/);
	 }
}

print Dumper($hash);
