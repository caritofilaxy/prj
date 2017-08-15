#!/usr/bin/perl

use v5.022;
use Data::Dumper;

package Horse;
use parent qw(Exporter);

our @EXPORT = qw(new ride);

sub new {
	my $invocant = shift;
	my $class = ref($invocant) || $invocant;
	my $self = {
		color => 'bay',
		legs => 4,
		owner => undef,
		@_,
	};
	return bless $self, $class;
}

sub ride {
	print "Igogo!!\n";
	}

##########################################
package main;
my $ed = Horse->new;
#my $gop = Horse->new(color=>"black", owner=>"Nevzorov");

#print Dumper($ed);
#print Dumper($gop);
$ed->ride;
