#!/usr/bin/perl

use strict;
use warnings;
use v5.24;

use Getopt::Long;


my $create;
my $delete;
my $perl;
my $c;
my $asm;

my $action;
my $lang;
my $name;

my $string;

GetOptions('create' => \$create, 
	   'delete' => \$delete, 
	   'perl'   => \$perl, 
	   'c'	    => \$c,
	   'asm'    => \$asm);

if ($create) { $action = "create" };
if ($delete) { $action = "delete" };

if ($perl) { $lang = "perl" };
if ($c)    { $lang = "C" };
if ($asm)  { $lang = "assembler" };

$string = $0 . ' ' . $action . ' '. $lang;

say $string;

