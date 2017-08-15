#!/usr/bin/perl

use strict;
use warnings;



print "Enter temperature: ";
chomp(my $t = <STDIN>);
while($t !~ /^-?\d+$/) {
	print "Not a digit. Again: ";
	$t = <STDIN>;
}

my $temp = do {;
	if ($t<0) 	{ 'Cold' }
	elsif ($t=0) 	{ 'Zero' }
	else  		{ 'Warm' }
};

print $temp."\n";

my $file_contents = do {;
	local $/;
	local @ARGV = ( $0 );
	<>;
};

print "My code:\n";
print $file_contents;
