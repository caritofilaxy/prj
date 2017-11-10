#!/usr/bin/perl

# use strict;
use warnings;

package Tie::Constvar;
use Carp;
sub TIESCALAR {
    my ($class, $initval) = @_;
    my $var = $initval;
    return bless \$var => $class;
}

sub FETCH {
    my $selfref = shift;
    return $$selfref;
}

sub STORE {
    confess "Meddle not with the constants of the universe";
}


package main;
tie my $avogadro, Tie::Constvar, 6.02252e23;

print $avogadro, "\n";
$avogadro = 1;
