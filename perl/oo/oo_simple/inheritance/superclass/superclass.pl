#!/usr/bin/perl

use strict;
use warnings;

use Paradigm;
use Language;

my $paradigm = Paradigm->new(name=>"functional");
my $language = Language->new(name=>"haskell", type=>"compilation");

$paradigm->show_attrs;

$language->show_attrs;

