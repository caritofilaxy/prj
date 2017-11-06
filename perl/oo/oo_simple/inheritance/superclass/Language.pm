package Language;

use parent 'Paradigm';

sub new {
	my ($class,%conf) = @_;
	my $self = bless { _name=>$conf{name}, _type=>$conf{type} }, $class;
	return $self;
}

sub get_type {
	my $self = shift;
	$self->{_type};
}

# get_name from Paradigm package;

sub show_attrs {
	my ($self) = @_;
	$self->SUPER::show_attrs();
	print "L module: ", $self->get_type, "\n";
}

1;
