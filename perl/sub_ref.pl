#!/usr/bin/perl
#
use strict;
use warnings;

my %constraints = (
	is_defined => sub { defined $_[0] },
	not_empty => sub { length $_[0] > 0 },
	has_whitespace => sub { $_[0] =~ /\s/ },
	no_whitespace => sub { $_[0] != /\s/ },
	has_digit => sub { $_[0] =~ /\d/ },
	has_special => sub { $_[0] =~ /[^a-z0-9]/i },
);

chomp (my $passwd = <STDIN>);
my $fail = grep {
	! $constraints{$_}->($passwd)
	} qw( has_whitespace has_digit has_special );

print "Failed\n" if $fail;
