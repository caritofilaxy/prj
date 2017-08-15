#!/usr/bin/perl 

use strict;
use warnings;

use File::Spec;

my $path = File::Spec->catfile($ENV{HOME}, "data.txt");

open my $fh, '<', $path

print while(<$fh>);
