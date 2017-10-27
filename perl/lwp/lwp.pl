#!/usr/bin/env perl

use strict;
use warnings;
use v5.22;

use LWP::UserAgent;

my $separator = "============================";

my $ua = LWP::UserAgent->new();
$ua->agent("Figzilla 52.7");

my $response = $ua->get("http://www.rbc.ru");
my $text = $response->content;


my @lines = split("\n", $text);

foreach my $line (@lines) {
    if ($line =~ /$ARGV[0]/) {
        $line =~ s/^\s+//;
        $line =~ s/\s+$//;
        say $line;
        say $separator;
    }
}
