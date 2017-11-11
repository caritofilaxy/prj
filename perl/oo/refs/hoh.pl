#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $hash = {};

my $tmplt = << "END";
Iron: Fe 55.845 26 8 4
Copper: Cu 63.546 29 11 4
Sodium: Na 22.989 11 1 3
END

for my $line (split /\n/, $tmplt) {
	my $rec = {};
	my $metall = (split / /, $line)[0];
	$metall =~ s/://;
	$hash->{$metall} = $rec;
	my ($name,$symbol,$ram,$an,$gn,$p) = (split /\s+/, $line);
	$rec->{name} = $name;
	$rec->{symbol} = $symbol;
	$rec->{ram} = $ram;
	$rec->{an} = $an;
	$rec->{gn} = $gn;
	$rec->{p} = $p;
}
	

print Dumper($hash);

my $metall = "Copper";
printf "%s\'s rel atomic mass is %.3f\n", $metall, $hash->{$metall}->{ram};
