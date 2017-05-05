#!/usr/bin/perl
#
use v5.22;
use Data::Dumper;

package Critter;
sub spawn { bless { } }

my $pet = Critter->spawn;

print Data::Dumper($pet);
