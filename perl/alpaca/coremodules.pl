#!/usr/bin/perl

use v5.022;
use warnings;
use Module::CoreList;

print join "\n", Module::CoreList->find_modules(qr/./);
print "\n"
