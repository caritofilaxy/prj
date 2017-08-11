#!/usr/bin/perl

use strict;
use warnings;
use v5.24;

my $argc = @ARGV;

my $usage = "Usage: $0 <create|delete> <perl|c|asm> <name>\n";

die $usage unless $argc == 3;

my($action, $lang, $name) = @ARGV;


die $usage unless (($action =~ /create|delete/i) or ($lang =~ /perl|c|asm/i) or ($name));
say "$action, $lang, $name";
say "here";
