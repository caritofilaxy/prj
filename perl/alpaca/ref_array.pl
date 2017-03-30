#!/usr/bin/perl

use strict;
use warnings;

my @regs = qw(eax ebx); 	# array
my $ref_regs = \@regs;		# get ref 2 arr
my $copy_ref = $ref_regs;	# copy ref (to the same array, that is, same memory location);
print $copy_ref."\n"; 		# print address of array
my @deref = @{$copy_ref};	# dereferencing array;
my @deref2 = @$copy_ref; 	# same and here i can avoid braces;
my $deref_slice = $$copy_ref[1]; # slice gets $ptrs[1];
$$ref_regs[2] = "ecx";		# add element to array;
print "@regs\n";

my @ptrs = qw(esp ebp);
my $ref_ptrs = \@ptrs;

push @$ref_regs, @$ref_ptrs;
print "@regs\n";

##############################################
my @regs_used = qw(ebx esi edi ebp);

sub chk_req {
	my @regs_req = qw(eax ebx ecx edx esp ebp);
	my @missing = ();
	
	for my $item (@regs_req) {
		unless (grep {$item eq $_} @{$_[0]}) {
			push @missing, $item;
		}
	}

	if (@missing) {
		push @{$_[0]}, @missing;
	}
}

chk_req(\@regs_used);

print "@regs_used\n";
##############################################
