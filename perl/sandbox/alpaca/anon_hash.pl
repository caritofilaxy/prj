#!/usr/bin/perl

use strict;
use warnings;

my %svc = (
	ftp=>'21/tcp',
	ssh=>'22/tcp',
	smtp=>'25/tcp',
	dns=>'53/udp',
);

my %utils = (
	ftp => 'openftp',
	ssh => 'openssh',
	smtp => 'postfix',
	dns =>'dig',
);

my @henv = (\%svc, \%utils);
my $henv_ref = \@henv;

#my $postfix = $henv_ref->[1]->{smtp};
my $postfix = $henv_ref->[1]{smtp};
print $postfix . "\n";

###########################################################

$henv_ref = [
			+{				# anon hash uses a curly braces and looks like 
				ftp=>'21/tcp',		# usual block of code
				ssh=>'22/tcp',		# to explicitly show to compiler that i want 
				smtp=>'25/tcp',		# anon hash but not block put a '+' in front
				dns=>'53/udp',		# of opening curly brace
			},
			+{
				ftp => 'openftp',
				ssh => 'openssh',
				smtp => 'postfix',
				dns =>'dig',
			},
		]; 
{;							# to explicitly show to compiler that
	$postfix = $henv_ref->[1]{smtp};		# i want a block of code but not anon hash
	print $postfix . "\n";				# put ';' right after opening curly brace
}
