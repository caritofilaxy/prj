#!/usr/bin/perl

use v5.022;
use warnings;

use File::Spec;

my $filespec = File::Spec->catfile($ENV{HOME},'web_docs','kitty.gif');

print $filespec."\n";
