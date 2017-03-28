#!/usr/bin/perl

use v5.022;
use warnings;

use File::Basename;

#my $fullname = "/usr/sbin/iptables";
my $fullname = "C:\\windows\\system32\\command.com";
#my @suffixlist = qw(pl sh out exe com);

#my ($name,$path,$suffix) = fileparse($fullname, @suffixlist);
my ($name,$path,$suffix) = fileparse($fullname);

print "$name\n";
print "$path\n";
#print "$suffix\n";

my $bname = basename($fullname);
my $dname = dirname($fullname);
print "basename: $bname, dirname: $dname\n";
