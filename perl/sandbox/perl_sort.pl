#!/usr/bin/perl

use v5.022;
use warnings;

sub by_nmbr { if ($a<$b) { -1 } elsif ($a>$b) { 1 } else { 0 } };
sub by_nmbr_rev { $b <=> $a }; # same as above just reversed
sub by_code { $a cmp $b };
sub by_code_rev { $b cmp $a };

# numeric sorting
my @nmbrs;
for (1..30) {
	push @nmbrs, int(1+rand(300));
}

my @asc_n = sort by_nmbr @nmbrs;
say "@asc_n";
my @desc_n = sort by_nmbr_rev @nmbrs;
say "@desc_n";

say "";

# alphabetic sorting
my %dict;
my @wrds;

open(my $fh,'<',"/usr/share/dict/cracklib-small") || die "Cant open file: $!";
while (<$fh>) {
	chomp;
	$dict{$.} = $_;
}

for (1..10) {
	push @wrds, $dict{int(1+rand(50000))};
}

my @asc_w = sort by_code @wrds;
say "@asc_w";
my @desc_w = sort by_code_rev @wrds;
say "@desc_w";
