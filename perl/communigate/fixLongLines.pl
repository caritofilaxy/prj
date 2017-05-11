#!/usr/bin/perl -w
#
# A script for rewriting .mbox files for the case of "mailbox contains a very long line" error.
#
#
# Please mail your comments and suggestions to <support@communigate.com>

use strict;

my $maxLineSize=1024*4;

if(@ARGV < 2) {
  die "Usage: fixLongLines.pl inputMailbox.mbox outputMailbox.mbox\n";
}
print "Reading $ARGV[0], writing $ARGV[1]\n";
my $cnt=0;

open(INF,$ARGV[0]) || die "Can't open $ARGV[0]: $!";
open(OUTF,">$ARGV[1]") || die "Can't create $ARGV[1]: $!";

while(<INF>) {
  my $line=$_;
  if($line=~/\000/) {
    print "zeros found in line $cnt, size=".length($line)."\n";
    $line=~s/\000//g;
  }  
  if(length($line)>$maxLineSize+1) {
    print "long line $cnt found, size=".length($line)."\n";
    print OUTF substr($line,0,$maxLineSize)."\n"; #we don't save the rest of the line
  } else {
    print OUTF $line;
  }
  $cnt++;
}

close(INF);
close(OUTF);
print "Done\n";
__END__
