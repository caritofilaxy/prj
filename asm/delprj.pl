#!/usr/bin/perl
#
use strict;
use warnings;
use Cwd;

my $argc = @ARGV;
my $prj = $ARGV[0];

die "Name, sister" unless $argc == 1;

#enter directory;
#rm files
#level up
#rm dir
#
chdir $prj;
opendir(my $dh, ".");
while(readdir $dh) {
	unlink $_;
}
chdir("..");
rmdir $prj;

