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

###################################################

#sub create_find_callback {
#	my $count=0;
#	return sub { print ++$count, ":$File::Find::name\n" };
#}

#my $callback1 = create_find_callback();
#my $callback2 = create_find_callback();
#find($callback, @root_dir);
#find($callback1, '/boot');
#find($callback2, '/mnt');

####################################################
#
#sub create_find_callback_that_sums_the_size {
#	my $total_size = 0;
#	return sub {
#		if (@_) {
#			return $total_size;
#		} else {
#			$total_size += -s if -f;
#		}
#	};
#}
#
#my $callback =  create_find_callback_that_sums_the_size();
#find($callback,@root_dir);
#my $total_size = $callback->('dummy');
#print "total size of @root_dir is $total_size\n";
#
######################################################

sub create_find_callback_that_sums_size {
	my $total_size = 0;
	return (sub { my $target = $File::Find::name; 
			if (-f $target and $target =~ "en") {
				print $target , ": ", -s $target, "\n";
				$total_size += -s $target;
				}
			}, 
		sub {return $total_size });
}

my ($targets, $get_results) = create_find_callback_that_sums_size();
find($targets, @root_dir);
my $total_size = &$get_results();
print "Total size is $total_size\n";
