#!/usr/bin/perl

use strict;
use warnings;

package Planet;

# this is an example of separate initialization function from constructor

use Carp;

STDOUT->autoflush(1);

sub new {
	Carp::carp("Options should be array, not anything else") if (ref($_[1]) eq 'ARRAY');
	my ($class, @args) = @_;
	print "NEW: $class\n";
	my $self = bless { _name => $args[0],
					   _d2s => $args[1],
					   _rad => $args[2],
						}, $class;
	print "ref(myself) is ", ref($self), "\n";
	return $self;
}

sub get_name { $_[0]->{_name} };
sub get_d2s { $_[0]->{_d2s} };
sub get_rad { $_[0]->{_rad} };
sub print_me {
	my ($self) = @_;
	print "name : ", $self->get_name(), " | ";
	print "d2s : ", $self->get_d2s(), " | ";
	print "rad : ", $self->get_rad(), " | ";
	print "\n";
}

sub goto_sun {
	my ($self) = @_;
	my $d = $self->get_d2s();
	while ($d-->1) {
		print "$d ";
		sleep 1;
	};
	print "Kaboom!!!\n";
}

package main;
my $mercury = Planet->new("Mercury", 7, 2440);
$mercury->print_me();
#$mercury->goto_sun();
