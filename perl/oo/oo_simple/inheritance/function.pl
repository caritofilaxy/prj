#!/usr/bin/perl 

use strict;
use warnings;

use Scalar::Util qw(blessed);

package Warcraft;

sub get_name {
	my ($self) = @_;
	$self->{_name};
}

sub iam {
	my ($self) = @_;
	print "You can use ", $self->get_name(), "!\n";
}



package Race;
@Race::ISA = qw(Warcraft);

sub new {
	my ($class,%args) = @_;
	my $self = bless { _name=>$args{name} }, $class;
	return $self;
}

package Weapon;
@Weapon::ISA = qw(Warcraft);

sub new {
	my ($class,%args) = @_;
	my $self = bless { _name=>$args{name} }, $class;
	return $self;
}

package main;

my $orc = Race->new(name=>"Orc");
my $human = Race->new(name=>"hUman");
my $bfg = Weapon->new(name=>"BFG-9000");

$orc->iam();
$human->iam();
$bfg->iam();

