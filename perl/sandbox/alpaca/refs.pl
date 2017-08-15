#!/usr/bin/perl

use strict;
use warnings;

#my @gen_regs = qw(eax ebx ecx edx);	my @gen_regs_named = ('General',\@gen_regs); 	#my $gen_regs_ref = \@gen_regs;
#my @ptr_regs = qw(esp ebp);      	my @ptr_regs_named = ('Pointers',\@ptr_regs);	#my $ptr_regs_ref = \@ptr_regs;
#my @ind_regs = qw(esi edi);	 	my @ind_regs_named = ('Index', \@ind_regs);	#my $ind_regs_ref = \@ind_regs;
#my @seg_regs = qw(cs ds ss);	 	my @seg_regs_named = ('Segment', \@seg_regs);	#my $seg_regs_ref = \@seg_regs;
#
#my @all_regs = (\@gen_regs_named, \@ptr_regs_named, \@ind_regs_named, \@seg_regs_named); my $all_regs_ref = \@all_regs;
#
#sub chk_req {
#	my ($who,$items) = (shift,shift);
#
#	my %whos_items = map { $_, 1 } @$items;
#
#	my @required = qw(eax ebx ecx edx esp ebp esi edi cs ds ss);
#	my @missing = ();
#
#	print "$who is missing ";
#	for my $item (@required) {
#		unless (exists $whos_items{$item}) {
#			print "$item ";
#			push @missing, $item;
#		}
#	}
#	print "\b.\n";
#
#	if (@missing) {
#		print "Adding @missing TO @$items FOR $who.\n";
#		push @$items, @missing;
#	}
#}
#
#
#for my $type (@all_regs) {
#	my $regs_type = $$type[0];
#	my $regs_ref = $$type[1];
#	print "Processing \"$regs_type\" with \"@$regs_ref\"\n";
#	chk_req($regs_type, $regs_ref);
#}

#chk_req(@$_) for @all_regs;

################################################################################################
my @dnsadmin = qw(dig host bind);
my @tcpadmin = qw(tcpdump nmap wget curl);
my @sillyadmin = qw(ping firefox);

my %all = (
	john => \@dnsadmin,
	james => \@tcpadmin,
	jim => \@sillyadmin,
);

my $all_ref = \%all;

#my @jameslist = @{$all_ref->{james}};
#my $james_wget = ${$all_ref->{james}}[2];
#print "@jameslist\n";
#print "$james_wget\n";

print_hash($all_ref);
print "+"x32 . "\n";
chk_req($all_ref);
print_hash($all_ref);


sub chk_req {
	my @netutils = qw(firefox tcpdump bind ping mtr dig host nmap ncat wget curl arp tc);
	print "All list: @netutils\n";
	my $hash_ref = shift;
	my @missing;

	for my $iter (keys %$hash_ref) {
		@missing = ();
		for my $util (@netutils) {
			push @missing, $util unless ( grep { $util eq $_ } @{$hash_ref->{$iter}} );
		}

		push @{$hash_ref->{$iter}}, @missing if (@missing);
	}
}

sub print_hash {
	my $hash_ref = shift;
	
	for my $item (keys %$hash_ref) {
		printf("%-20s: ", $item);
		for (@{$hash_ref->{$item}}) {
			print "$_ ";
		}
	print "\b.\n";
	}
}
