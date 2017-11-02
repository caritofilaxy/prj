package Bug;

#sub new {
#    bless {_id=>$_[1], _type=>$_[2], _descr=>$_[3]}, $_[0];
#}

sub new {
    my $class = $_[0];
    my $self = {
        _id => $_[1],
        _type => $_[2],
        _descr => $_[3],
    };
    bless $self, $class;
    return $self;
}

#sub print_me {
#    my ($self) = @_;
#    for (keys %$self) {
#        print $_, ": ", $self->{$_}, "\n";
#    }
#}

sub print_me {
    my ($self) = @_;
    print "ID: ", $self->{_id}, "\n";
    print "Type: !!!fatal!!!!\n" if $self->{_type} eq "fatal";
    print "Description: ", $self->{_descr}, "\n";
}

1;
