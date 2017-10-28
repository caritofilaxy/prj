package Bug;

sub new {
    my $class = $_[0];
    my $objref = {
        _id => $_[1],
        _type => $_[2],
        _descr => $_[3],
    };
    bless $objref, $class;
    return $objref;
}

sub print_me {
    my ($self) = @_;
    for (keys %$self) {
        print $_, ": ", $self->{$_}, "\n";
    }
}

1;
