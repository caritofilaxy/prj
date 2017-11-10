#!/usr/bin/perl

use strict;
use warnings;

package Ltime;

sub new {
	my ($class,$ttime) = @_;
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($ttime);
	my $self = bless {_sec   => $sec,
			     	  _min   => $min,
			     	  _hour  => $hour,
			     	  _mday  => $mday,
			     	  _mon   => $mon,
			     	  _year  => $year+1900,
			     	  _wday  => ++$wday,
			     	  _yday  => ++$yday,
			     	  _isdst => $isdst
					}, $class;
	return $self;
}


sub sec { $_[0]->{_sec} };
sub min { $_[0]->{_min} };
sub hour { $_[0]->{_hour} };
sub mday { $_[0]->{_mday} };
sub mon { $_[0]->{_mon} };
sub year { $_[0]->{_year} };
sub wday { $_[0]->{_wday} };
sub yday { $_[0]->{_yday} };
sub isdst { $_[0]->{_isdst} };

package main;

my $ctime = time;
my $tm = Ltime->new($ctime);
printf("Dateline: %02d:%02d:%02d-%04d/%02d/%02d\n", 
		$tm->hour, $tm->min, $tm->sec, $tm->year, $tm->mon, $tm->mday);
