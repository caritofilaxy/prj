#!/usr/bin/perl

use v5.022;
use warnings;

foreach (<*>) {
	printf "%-20s\t%-20d\t%-20d\n",  $_, (stat)[8], (stat)[9];
}
