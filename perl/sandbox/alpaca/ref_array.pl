#!/usr/bin/perl

use strict;
use warnings;

my @gen_regs = qw(eax ebx ecx edx);	# array
my $ref_regs = \@gen_regs;		# get ref 2 arr
my $copy_ref = $ref_regs;		# copy ref (to the same array, that is, same memory location);
print "Address of array: $copy_ref.\n";# print address of array
my @deref = @{$copy_ref};		# dereferencing array;
my @deref2 = @$copy_ref; 		# same and here i can avoid braces;
my $deref_slice = $$copy_ref[1]; 	# slice gets $ptrs[1];
$$ref_regs[2] = "ecx";			# add element to array;
print "@gen_regs\n";

my @ptr_regs = qw(esp ebp);
my $ref_ptrs = \@ptr_regs;

push @$ref_regs, @$ref_ptrs;
print "@gen_regs\n";

##############################################
# in functions parameters are passed by reference;
print "+"x32 . "\n";
@gen_regs = qw(eax ebx ecx edx);	# array
sub mod_gen_regs {
	$_[0] = "flags";
}

print "Initial general registers array: @gen_regs\n";
mod_gen_regs(@gen_regs);
print "After modifying: @gen_regs\n";
print "+"x32 . "\n";


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
# nested arrays
my @ind_regs = qw(esi edi);
my @seg_regs = qw(cs ds ss);

my @all_regs = (\@gen_regs, \@ptr_regs, \@ind_regs, \@seg_regs);# create array of refs (root array)
my $all_regs_ref = \@all_regs;					# get ref to array
my $give_me_ptrs = @{$all_regs_ref}[1];				# dereferece root array and get ref to second array
print "@$give_me_ptrs\n";					# print dereferenced second array

my $fst_index_reg = ${@$all_regs_ref[2]}[0];			# dereference root array, slice 3rd member, dereference it 
								# and get 1st value. phewww... 
print $fst_index_reg."\n";					# print it.

##############################################
# dereferencing with arrow
@gen_regs = qw(eax ebx ecx edx); my @gen_regs_named = ('General',\@gen_regs); 	#my $gen_regs_ref = \@gen_regs;
@ptr_regs = qw(esp ebp);         my @ptr_regs_named = ('Pointers',\@ptr_regs);	#my $ptr_regs_ref = \@ptr_regs;
@ind_regs = qw(esi edi);	 my @ind_regs_named = ('Index', \@ind_regs);	#my $ind_regs_ref = \@ind_regs;
@seg_regs = qw(cs ds ss);	 my @seg_regs_named = ('Segment', \@seg_regs);	#my $seg_regs_ref = \@seg_regs;

@all_regs = (\@gen_regs_named, \@ptr_regs_named, \@ind_regs_named, \@seg_regs_named); $all_regs_ref = \@all_regs;

print "-"x32 . "\n";
my $esi =  ${${$all_regs[2]}[1]}[0];
print $esi . "\n";
#$esi =  $all_regs[2]->[1]->[0];
#$esi = $all_regs_ref->[2]->[1]->[0];
$esi = $all_regs_ref->[2][1][0];
my @take_ptr_regs = @{$all_regs_ref->[1][1]};
print $esi . "\n";
print "@take_ptr_regs\n";

# another example
my @this_prog_stat = stat($0);
my $this_prog_stat_ref = \@this_prog_stat;
my $inode = $this_prog_stat_ref->[1];
#print $0 . " inode is " . $inode . "\n";
print join(" ", $0,"inode is",$inode,"\n");
