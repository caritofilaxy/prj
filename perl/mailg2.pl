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

foreach my $id (@{$ids}) {
	seek($log, 1, 0);
	while (<$log>) {
		print if /$id/;
	 }
print "="x90, "\n";
}
print Dumper($table);
