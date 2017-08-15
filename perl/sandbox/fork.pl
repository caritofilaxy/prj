#!/usr/bin/perl

if (fork) {
	print "Im parent\n";
	} else {
	print "Im child\n";
	}

	
