#!/usr/bin/perl
#
use strict;
use warnings;

my $h = {
	'professor.hut' => '7382830',
	'skipper.crew.hut' => '7104065',
	'gilligan.crew.hut' => '7237638',
	'fileserver.copyroom.hut' => '7175028',
	'maryann.girl.hut' => '7235878',
	'laser3.copyroom.hut' => '6948515',
	'ginger.girl.hut' => '7225624',
};

my $vals = [ sort by_value keys %$h ];
for (@$vals) {
	printf("%-30s: %-30d\n", $_, $h->{$_});
}

sub by_value {
       $h->{$b} <=> $h->{$a};
      }
             
