#!/usr/bin/perl

# perl -alnE '$h{$F[0]}++; END { say "$_: $h{$_}" for (sort { $h{$b} <=> $h{$a} } keys %h) };' softland.ru_access.log

use strict;
use warnings;
use Term::ANSIColor;
use Term::Cap;

$| = 1;

my $hashref;
my $maxlen;

die "Usage: nginx_stat.pl rows" unless scalar @ARGV == 1;
die "rows shoud be a number" unless $ARGV[0] =~ /^\d+$/;

my $OSPEED = 9600;
my $terminal = Term::Cap->Tgetent({OSPEED=>$OSPEED});

open(my $fh, "<", "/var/log/nginx/softland.ru_access.log") or die "cant open file: $!";

$SIG{INT} = sub {
	close $fh;
	print "\033[2J";    #clear the screen
	print "\033[0;0H"; #jump to 0,0
	print color 'reset';
	exit;
};

	print "\033[2J";    #clear the screen
	print "\033[0;0H"; #jump to 0,0

for (;;) {
	seek $fh, 0, 0;
	while(<$fh>) {
		my ($ip) = split(/\s+/);
		$hashref->{$ip}++;
	}

	show_plain($hashref, $ARGV[0]);
	
	sleep 2;
	$hashref = ();

	eval {
		require POSIX;
		my $termios = POSIX::Termios->new( );
		$termios->getattr;
		$OSPEED = $termios->getospeed;
	};
	$terminal->Tgoto('cm', 0, 0, \*STDOUT);
}


sub show_plain {
	my ($hash, $rows) = @_;
	my $row_cntr=0;
	for my $key (sort { $hash->{$b} <=> $hash->{$a} } keys %$hash) {
		if ($hashref->{$key} > 300) {
			print color('red');
			printf "%-15s %6d\n", $key, $hashref->{$key};
		} 
		else {
			print color('green');
			printf "%-15s %6d\n", $key, $hashref->{$key};
		}
		last if ++$row_cntr > $rows;
	}
}
