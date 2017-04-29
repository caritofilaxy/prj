#!/usr/bin/perl
#
use strict;
use warnings;

use Data::Dumper;

my $hash;

open(my $fh, '<', '/home/aesin/.mutt/caritofilaxy_gmail') || die "$!";

while(my $line = <$fh>) {
	my ($k,$v) = $line =~ m/(\w+)\s=\s(.+)/;
	$hash->{$k} = $v if defined($k);
	}

print Dumper($hash);
