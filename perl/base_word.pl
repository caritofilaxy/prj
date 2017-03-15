#!/usr/bin/perl

use warnings;

#print "$_  " for (0..9); 
#print "$_  " for (a..z); 
#print "$_  " for (A..Z); 
#print "\n";

#print "$_  " for (0..9);
#print "$_ " for (10..61);
#print "\n";

$c=0;

for (0..9) {
	$hash{$c} = $_;
	$c++;
	}
for ("a".."z") {
	$hash{$c} = $_;
	$c++;
	}
for ("A".."Z") {
	$hash{$c} = $_;
	$c++;
	}
$hash{$c} = "_"; $c++;
$hash{$c} = "\$";


$encoded = encode(99998);
print $encoded."\n";
$decoded = decode($encoded);
print $decoded."\n";

sub decode {
	$value = shift;
	%rhash = reverse %hash;
	$c=2;
	$a=1;
	while ($c>1)
		$fchar = substr($value,$a-1,$a);
		$val = $rhash{$fchar};
		$res += (64**$c)*$val;
		$c--;
		$a++;
		} while ($c>1);
	
	return $res;
}

sub encode {
	$value = shift;
	while ($value > 64) {
		$cel = int($value/64);
#		print $cel."\n";
		$ost = $value % 64;
#		print $ost."\n";
		$res .= $hash{$ost};
#		print $res."\n";
		$value = $cel;
		}
	$res .= $hash{$cel};
	if (length($res) == 2) {$res .= "0"};
	if (length($res) == 1) {$res .= "00"};
	$res = reverse $res;

	return $res;
	}
