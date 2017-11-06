package Paradigm;

sub new {
	my ($class,%conf) = @_;
	my $self = bless { _name=>$conf{name} }, $class;
	return $self;
}

sub get_name { $_[0]->{_name} };

sub show_attrs {
	my ($self) = @_;
	print "P module: ", $self->get_name, "\n";
}

1;
