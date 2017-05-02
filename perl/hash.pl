#!/usr/bin/perl

use v5.24;
use warnings;

use Data::Dumper;

my $headers =<<'END';
From: john@gmail.com
To: james@hotmail.com
Date: Mon, 17 Jul 2017 09:00:00 +04:00
Subject: Eye of the needle
END

my %fields = $headers =~ /^(.*): (.*)$/gm;

print Dumper(%fields);
