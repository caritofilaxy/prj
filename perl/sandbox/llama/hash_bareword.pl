#!/usr/bin/perl


#any bareword (a sequence of nothing but letters, digits, and underscores not starting with a digit, but optionally prefixed with plus or minus) to the left of the big arrow is implicitly quoted. So you can leave off the quote marks on a bareword to the left of the big arrow. You may also omit the quote marks if there’s nothing but a bareword as a key inside the curly braces of a hash

use v5.022;

my %chars = (
	john => 'silver',
	captain => 'smollet',
	jim => 'hawkins',
	hunter => undef,
	billy => 'bones',
	Dr => 'Livesey',
	);

print "Dr $chars{Dr}\n";

$chars{Black} = "Dog";

print "Black $chars{Black}\n";

my @ks = (1,2,3);
my @vals = ('one','two','three');

if (exists $chars{hunter}) {
	print "Hunter key present\n";
	}
if ($chars{hunter}) {
	print "Hunter value preset\n";
	} else {
	print "Hunter value is undef\n";
	}
	
