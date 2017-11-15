package Element;

sub new {
	($class,@pr) = @_;
	$self = bless { name=>$pr[0], sym=>$pr[1], ram=>$pr[2], an=>$pr[3], p=>$pr[4], next=>undef }, $class;
	#$self = bless { name=>$pr[0], sym=>$pr[1], ram=>$pr[2], an=>$pr[3], p=>$pr[4] }, $class;
	return $self;
}

#sub AUTOLOAD {
#	($self) = @_;
#	$AUTOLOAD =~ /.*::get_(\w+)/;
#	return $self->{$1};
#}

sub set_next {
	($self,$next) = @_;
	$self->{next} = $next;
}

sub get_name { $_[0]->{name} };
sub get_sym { $_[0]->{sym} };
sub get_ram { $_[0]->{ram} };
sub get_an { $_[0]->{an} };
sub get_p { $_[0]->{p} };
sub get_next { $_[0]->{next} };
sub set_next { $_[0]->{next} = $_[1] };

1;
