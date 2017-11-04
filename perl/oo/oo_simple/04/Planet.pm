package Planet;

# this is an example of separate initialization function from constructor

use strict;
use warnings;
use Carp;

STDOUT->autoflush(1);

sub new {
	Carp::carp("Options should be array, not anything else") if (ref($_[1]) eq 'ARRAY');
	my ($class, @args) = @_;
	my $self = bless {}, $class;
	$self->init(@args);
	return $self;
}

sub init {
	
	my ($self, @args) = @_;
	my %init = (_name=>1, _d2s=>1,_rad=>1);
	$init{_name} = $args[0];
	$init{_d2s} = $args[1];
	$init{_rad} = $args[2];
	%$self = %init;
	return $self
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
	while ($d-->0) {
		print "$d";
		sleep 1;
	};
	print "Kaboom!!!\n";
}

1;
