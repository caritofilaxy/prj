#!/usr/bin/perl
#
use strict;
use warnings;

use Scalar::Util qw(blessed);

package Planet;

sub new {
	my ($class,%conf) = @_;
	my $self = bless { _name=>$conf{name} }, $class;
	print $class, " named ",  $conf{name}, " is being born!\n";
}

sub get_myname {
	$_[0]->{_name};
}

sub DESTROY {
	my $self = shift;
	print "Last reference to ", Scalar::Util::blessed($self), " named ", $self->get_myname, " is being destroyed\n";
}

package main;

my $nibiru = Planet->new(name=>"nibiru");
print $nibiru->get_myname;

