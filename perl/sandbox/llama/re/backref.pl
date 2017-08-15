#!/usr/bin/perl

use v5.022;

$_ = "I will not make any deals with abrakadabra";
say "Match!" if (/(abra)kad\1/);  # \1 - occurence in parenthesis

$_ = "anna pavanna";
say "Match!" if /((.)(.)\3\2).+\1/; # count the order of the open parenthesis
say "Match!" if /((.)(.)\g{3}\g{2}).+\g{1}/; # same with group numbers
say "Match!" if /((.)(.)\g{-1}\g{-2}).+\g{-3}/; # relative back refs

