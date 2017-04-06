#!/usr/bin/perl

use strict;
use warnings;
use File::Find;

#sub action { print "$File::Find::name found\n" };
#my $action = sub { print "$File::Find::name found\n" };

my @root_dir = "/home/aesin/git/prj/perl";
# find($action, @root_dir);

find ( sub { print "$File::Find::name found\n" }, @root_dir );

### closures

my $total_size = 0;
find ( sub { $total_size += -s if -f }, @root_dir );
print $total_size."\n";
