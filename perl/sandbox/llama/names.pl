#!/usr/bin/perl
#
@names = qw(fred betty barney dino wilma pebbles bamm-bamm);

chomp(@nums = <STDIN>);

foreach (@nums) {
	if (defined($names[$_])) {
		print "$names[$_]\n"
	} else {
		print "undef\n"
	}
}
