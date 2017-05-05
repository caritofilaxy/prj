#!/usr/bin/perl
#
use v5.022;
#use lib "/home/aesin/git/prj/perl/OO";
use Horse;
use Data::Dumper;

my $ed = Horse->new;
#my $gop = Horse->new(color=>"black", owner=>"Nevzorov");

#print Dumper($ed);
#print Dumper($gop);
$ed->ride;
