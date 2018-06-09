#!/usr/bin/perl

# recursively prints files, ctimes and sizes

use strict;
use warnings;

use Cwd qw(abs_path);

my $total_size = 0;
indir();
$total_size /= 1024;
print $total_size."K\n";

sub indir {
	opendir(my $dh, ".") || die "cant open dir: $!";
	while (readdir $dh) {
		next if (/^\.$/);
		next if (/^\.\.$/);
		if ( -f $_ ) {
			my ($size, $ctime) = (stat($_))[7,10];
			$total_size += $size;
			$ctime = localtime($ctime);
			print abs_path($_).";$ctime;$size\n";
		} elsif ( -d $_) {
			chdir($_);
			indir();
			chdir("..");
		}
	}
	closedir $dh;
}
