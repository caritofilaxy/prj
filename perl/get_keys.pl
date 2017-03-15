#!/usr/bin/perl
#
#
$c = "a";

for (1..4) {
	$hash{$_} = $c++;
	}

%rhash = reverse %hash;

for (keys %rhash) {
	print "$_ - $rhash{$_}\n";
	}
	
$value = "a3g";
$fchar=substr($value,0,1);
print $fchar."\n"

