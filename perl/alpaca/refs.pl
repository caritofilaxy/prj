#!/usr/bin/perl

use strict;
use warnings;


# this section checks required items
my @required = qw(shapka polotentse tapki mylo mochalka voda);
my %i = map {$_,1} 
	qw(bolt gaika tapki mylo mochalka voda);

for my $item (@required) {
	unless (exists $i{$item}) {
		print "I missed $item\n";
	}
}

######################################################################
# this one does the same via sub
my @me = qw(bolt gaika tapki mylo mochalka voda);
my @tolik = qw(sigi venik mylo mochalka shapka);


check_required_items0('me',@me);
check_required_items0('tolik',@tolik);

sub check_required_items0 {
	my $who = shift;
	my %whos_items = map {$_,1} @_;
	my @required = qw(shapka polotentse tapki mylo mochalka voda);

	
	for my $item (@required) {
		unless (exists $whos_items{$item}) {
			print "$who missed $item\n";
		}
	}
}
######################################################################
# here we pass list of items to compare via ref

sub check_required_items {
	my $who = shift;
	my $items = shift;
	my %whos_items = map {$_,1} @{$items};
	my @required = qw(shapka polotentse tapki mylo mochalka voda);
	
	for my $item (@required) {
		unless (exists $whos_items{$item}) {
			print "$who missed $item\n";
		}
	}
}

# same without shifts and hash
sub chk_req_items {
	my @required = qw(shapka polotentse tapki mylo mochalka voda);
	
	for my $item (@required) {
		unless (grep { $item eq $_ } @{$_[1]}) {
			print "$_[0] missed $item\n";
		}
	}
}


my @professor = qw(bolt polotence tapki mylo mochalka);
my $ref_prof = \@professor;
chk_req_items("professor", $ref_prof);
