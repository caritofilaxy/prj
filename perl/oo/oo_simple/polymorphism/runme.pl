#!/usr/bin/perl

# objects from different classes share the same API
# in this case its a show_attrs method;

use strict;
use warnings;

use Tea;
use Coffee;

my $ahmad = Tea->new(name=>"Ahmad", color=>"Black", price=>100);
my $pedronegro = Coffee->new(name=>"PN", exporter=>"PN Limited", volume=>1000, origin=>"Brazil");

$ahmad->show_attrs;
$pedronegro->show_attrs;

#my $brookbond = Tea->new(name=>"Akbar", color=>"Yellow");
#$brookbond->show_attrs;



