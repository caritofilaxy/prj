#!/usr/bin/perl

use strict;
use warnings;
use Cwd;
use File::Spec;

my $current_dir = getcwd();
my @files = <*>;

foreach my $file (@files) {
	my $fullpath = File::Spec->catfile($current_dir, $file);
	print "$fullpath\n";
	}

