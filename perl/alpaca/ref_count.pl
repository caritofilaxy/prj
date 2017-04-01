#!/usr/bin/perl

use strict;
use warnings;

my $ref;				# 1

{
	my @utils = qw(nmap ncat ping mtr tc);
	$ref = \@utils;			# 2

	print $ref->[2] . "\n";
}
					# name @utils eliminated as out of scope, but list stay in memory
print $ref->[2] . "\n";			# 1 becomes anon array.
push @$ref, "tcpdump";			# like ref to array
print "@$ref\n";
my $copy2ref = $ref;			# may be copied; now 2 links on list
print "\$ref == \$copy2ref\n" if ($ref == $copy2ref);
print $copy2ref->[1] . "\n";
$ref = undef;				# now 1 link to list, data remains alive until we destroy last reference
$copy2ref = undef;			# no links, data destroyed

$util_ref = [ qw(nmap ncat ping mtr tc) ];   # [...] returns reference to list inside. same as below;
my $copy_ref;						#{
{							#{
	my @temp_name = qw(nmap ncat ping mtr tc);	#{	redundant bullshit
	$copy2ref = \@temp_name;			#{	look at the top
}							#{

print "\$ref == \$copy2ref\n" if ($util_ref == $copy2ref); # theese are different links to different lists 

#my @named_util = ("Utilities", $util_ref);
my @named_util = ("Utilities", [ qw(nmap ncat ping mtr tc) ]); # dont need inermediate reference
