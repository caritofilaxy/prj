#!/usr/bin/perl

use strict;
use warnings;
use File::Find;

#sub action { print "$File::Find::name found\n" };
#my $action = sub { print "$File::Find::name found\n" };

my @root_dir = "/home/aesin/git/prj/perl";
# find($action, @root_dir);

#find ( sub { print "$File::Find::name found\n" }, @root_dir );

### closures

#my $total_size = 0;
#find ( sub { $total_size += -s if -f }, @root_dir );
#print $total_size."\n";

#The kind of subroutine that can access all lexical variables that existed at the time we
#declared it is called a closure. In Perl
#terms, a closure is a subroutine that references a lexical variable that has gone out of
#scope.

#my $callback;
#{
#	my $count = 0;
#	$callback = sub { print  ++$count, ": $File::Find::name\n" };
#}										# at this moment $count eliminated.
#find($callback, @root_dir);

sub create_find_callback {
	my $count=0;
	return sub { print ++$count, ":$File::Find::name\n" };
}

my $callback = create_find_callback();
#find($callback, @root_dir);
find($callback, '/bin');




