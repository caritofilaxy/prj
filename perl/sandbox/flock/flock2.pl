#!/usr/bin/perl

#use Fcntl qw(:DEFAULT :flock);
#die "cannot open file: $!" unless open(my $fh, "<", "squid_timestamp");

#unless (flock($fh, 1)) {
#	local $| = 1;
#	print "Waiting for lock on file...\n";
#	die "cannot lock filename: $!" unless flock($fh, 2);
#	print "got it.\n";
#}


use v5.22;
use warnings;

open($fh, ">", "dummy_text.txt")|| die;
warn "flock2 cant lock file" unless flock($fh, LOCK_EX);

1 while(sleep(1));
