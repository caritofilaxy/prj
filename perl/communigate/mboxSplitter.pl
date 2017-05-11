#!/usr/bin/perl -w
#
# Splits large .mbox files into several small files.
#
# Please mail your comments and suggestions to <support@communigate.com>

use strict;

######  You may want to redefine some of these values 

my $sizeThreshold=1000*1024;

#### end of the customizeable variables list



if(@ARGV eq 0) {
  print "Usage: ./mboxSplitter.pl mailbox.mbox\n";
  exit;
}

my $size=$sizeThreshold;
my $fileNum=0;

my $prevLine="\n";  
while(<>) {
  my $line=$_;
  if($line=~/^From <>\(/ && $prevLine eq "\n") {
    if($size>=$sizeThreshold) {
      close(FILE) if($fileNum);
      my $fileName=sprintf("split_%03d.mbox",++$fileNum);
      print "Creating: $fileName\n";
      open(FILE,">$fileName") || die "Can't create $fileName: $!";
      $size=0;
    }
  }
  $size+=length($line);
  print FILE $line;
  $prevLine=$line;
}  
close(FILE);  
  
print "Done.\n";
  
  