#!/usr/bin/perl

use strict;
use warnings;
use Tie::File;

my @data;

tie @data, 'Tie::File', "tmplt";

# flush after all changes

(tied @data)->defer;
$data[1] = "substituted";
(tied @data)->flush;
