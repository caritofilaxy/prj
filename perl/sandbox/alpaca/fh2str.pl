#!/usr/bin/perl

use v5.022; # state
use warnings;

#open my $sfh_w, '>', \ my $string;
#
#print $sfh_w "hello\n";
#print $sfh_w "goodbye";
#
#my $multiline = "privet\nbonjour\nhello\n";
#
#open my $sfh_r, '<', \$multiline;
#
#while( <$sfh_r> ) {
#	print $.,": ", $_;
#}

#die "Usage $0 coconet.dat" if $ARGV[0] ne 'coconet.dat';

open my $coco, '<', 'coconet.dat';
while(<$coco>) {
	state $fhs;

	my ($src,$dst,$bytes) = split;

	unless($fhs->{$src}) {
		open my $fh, '>>', $src or die;
		$fhs->{$src} = $fh;
	}

	say { $fhs->{$src} } "$dst $bytes";
}
