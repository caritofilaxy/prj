#!/usr/bin/perl

use strict;
use warnings;

use HTTP::SimpleLinkChecker;

my $ua = HTTP::SimpleLinkChecker::user_agent();

$ua->transactor->name('Xyulla 3000');

my $code  = HTTP::SimpleLinkChecker::check_link('http://softland.ru/1234/');

print $code."\n";
