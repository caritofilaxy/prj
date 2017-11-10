#!/usr/bin/perl

use strict;
use warnings;

package Ltime;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

sub new {
	my ($class) = @_;
	my $self = bless {}, $class;
	$self->init();
	return $self;
}

sub init {
	my ($self) = @_;
	my %init = ( _sec   => $sec,
			     _min   => $min,
			     _hour  => $hour,
			     _mday  => $mday,
			     _mon   => $mon,
			     _year  => $year+1900,
			     _wday  => ++$wday,
			     _yday  => ++$yday,
			     _isdst => $isdst
			);
	$self->{_sec} = $init{_sec};
	$self->{_min} = $init{_min};
	$self->{_hour} = $init{_hour};
	$self->{_mday} = $init{_mday};
	$self->{_mon} = $init{_mon};
	$self->{_year} = $init{_year};
	$self->{_wday} = $init{_wday};
	$self->{_yday} = $init{_yday};
	$self->{_isdst} = $init{_isdst}; 

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

my $tm = Ltime->new();
printf("Dateline: %02d:%02d:%02d-%04d/%02d/%02d\n", 
		$tm->hour, $tm->min, $tm->sec, $tm->year, $tm->mon, $tm->mday);
