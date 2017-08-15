#!/usr/bin/perl

use strict;
use warnings;

sub my_sub_ref { 
	print "Passing by reference\n";
	print "Initial value: $_[0]\n";
	 $_[0]++;
	print "New value in sub: $_[0]\n";  
};

sub my_sub_val { 
	print "Passing by value\n";
	print "Initial value: $_[0]\n";
	my ($param) = @_; 
	$param++;
	print "New value in sub: $param\n"; 
} 

# parameters passed by reference;
my $var = 5;
my_sub_ref($var);
print "Value after sub: $var\n";

# parameters passed by value;
$var = 5;
my_sub_val($var);
print "Value after sub: $var\n";
