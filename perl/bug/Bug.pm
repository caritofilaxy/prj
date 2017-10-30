package Bug;

sub new {
	bless {_id=>$_[1], _type=>$_[2], _descr=>$_[3]}, $_[0];
}

sub print_me { 
	my ($self) = @_;
	print "ID: ", $self->{_id}, "\n"; 
	print "Desc: ", $self->{_descr}, "\n";
	print "Full fiasco\n" if $self->{_type} eq "fatal";
};
 
1;
