#!/usr/bin/perl

my $count = 0;

#sub catch_int {
#	$count++;
#	my $signame = shift;
#	print "\n$count $signame\n";
#	}


#$SIG{INT} = \&catch_int;

my $catch_int = sub {
	$count++;
	my $signame = shift;
	print "\n$count $signame\n";
	};

$SIG{INT} = $catch_int;
	

while ($count < 5) {
	sleep;
	}

print "End!\n";

