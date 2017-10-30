package CD::Music;

use strict;
use Carp;

{
    my $_count = 0;
    sub get_count { $_count };
    sub _inc_count { ++$_count };
}


sub new {
    my ($class) = @_;
    $class->_inc_count();
    bless {
        _name       => $_[1],
        _artist     => $_[2],
        _publisher  => $_[3],
        _ISBN       => $_[4],
        _tracks     => $_[5],
        _room       => $_[6],
        _shelf      => $_[7],
        _rating     => $_[8],
    }, $class;
}

sub get_name { $_[0]->{_name} };
sub get_artist { [0]->{artist} };
sub get_publisher { [0]->{_publisher}; };
sub get_ISBN { [0]->{_ISBN}; };
sub get_tracks { [0]->{_tracks}; };


sub set_location {
    my ($self, $shelf, $room) = @_;
    $self->{_room}= $room if $room;
    $self->{_shelf}= $shelf if $shelf;
}

sub set_rating {
    my ($self, $rating) = @_;
    $self->{_rating} = $rating if $rating;
}

1;

