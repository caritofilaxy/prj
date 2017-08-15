#!/usr/bin/perl

use strict;
use warnings;
use Carp qw(croak);

my %svc = (
	ftp=>'21/tcp',
	ssh=>'22/tcp',
	smtp=>'25/tcp',
	dns=>'53/udp',
);

#my $svc_ref = \%svc;
#for (keys %svc) {
#	print "$_: $svc_ref->{$_}\n";
#	}


my %utils = (
	ftp => 'openftp',
	ssh => 'openssh',
	smtp => 'postfix',
	dns =>'dig',
);

my @environment = (\%svc, \%utils);
my $env_ref = \@environment;

print $environment[0]->{ssh} . "\n";
print $env_ref->[1]{smtp} . "\n";

foreach (keys %svc) {
	my $port = $env_ref->[0]{$_};  
	my $util = $env_ref->[1]{$_};
	print "I use \"$util\" to reach \"$port\"\n";
}



sub is_hash_ref {
	my $href = shift;
	return eval { keys %$ref_type; 1 };
}

my %h=('aaa'=>'bbb'); my $r = \%h; my $ref_type = ref $r;
print $ref_type . "\n";
croak "I expected hash reference" unless is_hash_ref($ref_type);
