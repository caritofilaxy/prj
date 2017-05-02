#!/usr/bin/perl

$mypush = sub ($$) {
	push(@{$_[0]}, $_[1]);
};


$arr = [ qw(one two three) ];
$mypush->($arr,"four");

print "@{$arr}\n";
