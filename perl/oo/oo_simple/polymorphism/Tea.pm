package Tea;

use strict;
use warnings;

use Carp;

sub new {
	my ($class,%conf) = @_;
	my $self = bless {}, $class;
	$self->_init(%conf);
	return $self;

}

sub _init {
	my ($self,%conf) = @_;
	my %init = (_name=>undef, _color=>undef, _price=>undef ); 
	$init{_name} = $conf{name};
	carp "Name must exist" unless $init{_name};
	$init{_color} = $conf{color} if ($conf{color} =~ /^(black|green)$/i);
	$init{_price} = $conf{price2} // "undef";
	%$self = %init;
	return $self;
}

# accessors: get_*

sub get_name  { $_[0]->{_name} };
sub get_color { my ($self) = @_; $self->{_color} };
sub get_price { $_[0]->{_price} };


sub show_attrs {
	my ($self) = @_;
	print "Name: ", $self->get_name, ", Color: ", $self->get_color, ", Price: ", $self->get_price, "\n";
}

1;

