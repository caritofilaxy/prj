#!/usr/bin/perl

# setting $/ to a ref to integer or scalar, containing an integer
# will make "readline" and <$fh> operations read in fixed-length records.
# $/ = \11 or ($v1 = 11 && $/=\$v1) will read 11 bytes from $fh

$/ = \11;


my $file = "dummy_text.txt";

die "cant open $file: $!" unless open(my $fh, "<", $file);
my $record = <$fh>;

print $record, "\n";


