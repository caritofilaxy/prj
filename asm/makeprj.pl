#!/usr/bin/perl
#
use strict;
use warnings;
use File::Copy;

my $argc = @ARGV;
my $prj = $ARGV[0];

die "Name, sister" unless $argc == 1;

create_dir($prj);
copy_makefile($prj);
copy_src($prj);


sub create_dir {
	print "Making directory... ";
	my $name = shift;
	mkdir $name;
	print "Done.\n";
}


sub copy_makefile {
	my $name = shift;
	print "Copying Makefile... ";
	open(my $in, "<", "sandbox/Makefile");
	open(my $out, ">", "$name/Makefile");
	while(<$in>) {
		s/sandbox/$name/;
		print $out $_;
	}
	close($in);
	close($out);
	print "Done.\n";
}


sub copy_src {
	my $name = shift;
	print "Copying source... ";
	copy("sandbox/sandbox.asm","$name/$name.asm");
	print "Done.\n";
}
