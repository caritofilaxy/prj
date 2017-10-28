#!/usr/bin/env perl

use strict;
use warnings;
use v5.22;

use LWP::UserAgent;
use Time::HiRes qw(gettimeofday tv_interval);

my $separator = "============================";

my $ua = LWP::UserAgent->new();
$ua->agent("Figzilla 52.7");

my $t0 = [gettimeofday];
my $response = $ua->get("http://www.news.com");
my $t1 = tv_interval ($t0, [gettimeofday]);
print "fetched for $t1 seconds\n";
$t0 = [gettimeofday];
my $text = $response->content;
my $t2 = tv_interval($t0, [gettimeofday]);
printf "content generated for $t2 seconds\n";


my @lines = split("\n", $text);

foreach my $line (@lines) {
    if ($line =~ /$ARGV[0]/) {
        $line =~ s/^\s+//;
        $line =~ s/\s+$//;
        say $line;
        say $separator;
    }
}
