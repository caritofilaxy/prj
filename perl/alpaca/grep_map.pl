#!/usr/bin/perl

use strict;
use warnings;

#my @files = <*>;

#@files =  grep { -s $_ < 200 }  @files;
#@files = map { "____".$_."\n"; } @files;
#print for @files;


# grep indexes of array elements with odd sum of its digits; 
my @input_numbers = qw(1 2 4 8 16 32 64 128 256 512);
my @ind_odd_sum = grep {		
	my $n = $input_numbers[$_];	# get current value( $_ is index of 0..$#input)
	my $sum;			# init sum 
	$sum += $_ for split //, $n;	# get sum
	$sum%2;				# true if sum is odd ($sum%2=1)
	} 0..$#input_numbers;
print "@input_numbers\n";
print "@ind_odd_sum\n";

my %utils = (
	"net-dns" => [ qw(avahi bind cagibi coredns dnscap dnstop dnswalk heziod) ],
	#"net-p2p" => [ qw(amule bitcoind ctorrent dbhub freenet gnut transmission tribler) ],
	"net-p2p" => [ qw(amule bitcoind transmission tribler) ],
	"net-vpn" => [ qw(6tunnel tor vpnc vtun) ],
	"dummy" => [ qw(avahi amule tor) ],
);

my @less_than_5 = grep { @{ $utils{$_} } < 5 } keys %utils;
print "@less_than_5\n";

# suppose we have 2 arrays and we want elements (indexes) of @x that are larger than corresponding value in @y
my @x = qw( 1 2 3 6 18 108 1944);
my @y = qw( 1 2 4 8 16 32 64);

my @bigger_indices = grep { 
	($_ > $#y) or ($x[$_] > $y[$_]);
	} 0..$#x;
print "@bigger_indices\n";

my @bigger_values = map { if ($_ > $#y or $x[$_] > $y[$_]) { $x[$_] } else { () }; } 0..$#x;
print "@bigger_values\n";

# from %utils who has "tor" ?
my @hiders = grep { 
		my @items = @{ $utils{$_} };
		grep { $_ eq "tor"} @items;
} keys %utils;

print "@hiders\n";
