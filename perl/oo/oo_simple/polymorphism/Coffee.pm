package Coffee;

use strict;
use warnings;

sub new {
	my ($class,%conf) = @_;
	my $self = bless {}, $class;
	$self->_init(%conf);
	return $self;

}

sub _init {
	my ($self,%conf) = @_;
	my %init = (_name=>undef, _origin=>undef, _exporter=>undef, _volume=>undef ); 
	$init{_name} = $conf{name};
	die "Name must exist" unless $init{_name};
	$init{_origin} = $conf{origin} // "undef";
	$init{_exporter} = $conf{exporter} // "undef";
	$init{_volume} = $conf{volume} // "undef";
	%$self = %init;
	return $self;
}

# accessors: get_*

sub get_name  { $_[0]->{_name} };
sub get_origin  { $_[0]->{_origin} };
sub get_exporter { my ($self) = @_; $self->{_exporter} };
sub get_volume { $_[0]->{_volume} };


sub show_attrs {
	my ($self) = @_;
	print "Name: ", $self->get_name, ", Origin: ", $self->get_origin, ", Exporter: ", $self->get_exporter, ", Volume: ", $self->get_volume, "\n";
}

1;

