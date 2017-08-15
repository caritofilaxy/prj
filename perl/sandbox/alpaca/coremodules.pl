#!/usr/bin/perl

use v5.022;
use warnings;
use Module::CoreList;

print join "\n", Module::CoreList->find_modules(qr/hires/i);
print "\n";
print join "\n", Module::CoreList->first_release('Module::Build');
print "\n";
