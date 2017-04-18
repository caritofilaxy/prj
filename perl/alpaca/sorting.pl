#!/usr/bin/perl

use v5.022;
use warnings;

my @input = qw(Gilligan Skipper Professor Ginger Mary Ann);
say "input: @input";

my @sorted = sort @input;
say "sorted_input: @sorted";

my @sorted_positions = sort { $input[$a] cmp $input[$b] } 0..$#input;
say "sorted_positions: @sorted_positions";

my @ranks;
@ranks[@sorted_positions] = (0..$#sorted_positions);
say "input_ranks: @ranks";

