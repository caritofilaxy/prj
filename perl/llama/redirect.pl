#!/usr/bin/perl

use v5.022;
use warnings;

open(STDOUT,'>','ls.out') || die "cant open stdout: $!";
open(STDERR,'>','ls.err') || die "cant open stderr: $!";

chdir("/root") || die "Cant chdir to /root: $!";
exec 'ls', '-l';
