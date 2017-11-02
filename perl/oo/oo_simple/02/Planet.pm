package Planet;

sub new {
	my ($class, %conf) = @_;
	my $self = bless {
		_mass = $conf{mass},
		_distance = $conf{distance},
		_speed = $conf{speed}
	}, $class;
	return $self;
}


1;
