#!/usr/bin/perl

use v5.022;
use warnings;

my $init_array = [ qw(1 2 three four) ];
#my $shcopy = [ @$init_array ]; 	# not a shallow copy, use ref copy;
my $shcopy = $init_array;

show($init_array, $shcopy);
$shcopy->[1] = 3;
show($init_array, $shcopy);

print "\nOrig: ", $init_array, "\nCopy: ", $shcopy, "\n";

sub show {
	foreach my $ref (@_) {
		print "Element [1] is $ref->[1]\n";
		}
	}


print "\n\n";
####################################################################
# shallow_copy.pl
my $AoA = [
	[ qw( a b ) ],
	[ qw( X Y ) ],
	];

# Make the shallow copy
my $shallow_copy = [ @$AoA ];

# Check the state of the world before changes
show_arrays( $AoA, $shallow_copy );

# Now, change the shallow copy
$shallow_copy->[1][1] = "Foo";

# Check the state of the world after changes
show_arrays( $AoA, $shallow_copy );

print "\nOriginal: $AoA->[1]\nCopy: $shallow_copy->[1]\n";

sub show_arrays {
	foreach my $ref ( @_ ) {
	print "Element [1,1] is $ref->[1][1]\n";
	}
}
