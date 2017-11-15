#!/usr/bin/perl

use strict;
use warnings;
use Digest::MD5 qw(md5 md5_hex md5_base64);

die "is this a file?" unless open(my $fh, "<", $ARGV[0]);

#binmode($fh, ":raw"); # same
binmode($fh);

my $data;
{
	local $/ = undef;
	$data = <$fh>;
}

my $dh = md5_hex($data);

print "$dh\n";
