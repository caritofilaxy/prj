use warnings;

sub think_what {
	my ($params) = @_;
	print "You think: $params\n";
}

# redefinition of say_what to get a warning;
#
sub say_what {
	1;
	}
