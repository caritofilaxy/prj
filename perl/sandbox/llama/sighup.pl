#!/usr/bin/env perl

use 5.016;
use warnings;

$SIG{HUP} = sub {
  say "Okay okay ...";
  exit;
};


1 while 1;

  
