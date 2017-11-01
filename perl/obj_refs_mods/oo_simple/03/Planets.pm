package Planets;

use strict;
use warnings;

sub new {
    my ($class,%conf) = @_;
    bless {
        _dist2sun=>$conf{dist2sun},
        _radius=>$conf{radius},
    }, $class;
}

sub get_dist2sun { $_[0]->{_dist2sun} };
sub get_radius { $_[0]->{_radius} };

sub print_me {
    print "Distance to sun: ", $_[0]->get_dist2sun(), " km\n";
    print "Radius: ", $_[0]->get_radius(), "\n";
  }

sub set_dist2sun { 
    my ($self,$dist) = @_;
    $self->{_dist2sun} = $dist if $dist;
}


1;

