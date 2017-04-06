#!/usr/bin/perl

use strict;
use warnings;
use File::Find;

#sub action { print "$File::Find::name found\n" };
my $action = sub { print "$File::Find::name found\n" };


my @root_dir = "/home/aesin/git/prj/perl";
find($action, @root_dir);
