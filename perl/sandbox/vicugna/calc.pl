#!/usr/bin/perl

use v5.022;
use warnings;

use vars qw(%ops);

%ops = (
	'+' => sub { $_[0] + $_[1] },
	'-' => sub { $_[0] - $_[1] },
	'*' => sub { $_[0] * $_[1] },
	'/' => sub { $_[1] ? $_[0] / $_[1] : "NaN" },
	);

REPL: while(1) {
	my ($operator, @operand) = get_line();

	my $some_sub = $ops{$operator};
	unless ( defined $some_sub ) {
		say "Unknown operator [$operator]";
		last REPL;
		}
	say $ops{$operator}->(@operand);
	}
	print "Done. Exiting... \n";

	sub get_line {
		print "\nprompt> ";
		my $line = <STDIN>;
		$line =~ s/^\s+|\s+$//;
		(split /\s*/, $line)[1,0,2];
	}
