#!/usr/bin/perl 

use strict;
use warnings;

package Warcraft;

sub iam {
	my ($self) = @_;
	print "Im ", $self->{_me}, "\n";
}

package Race {
	my ($self,%args) = @_;

