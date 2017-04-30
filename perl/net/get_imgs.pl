#!/usr/bin/perl
#
use strict;
use warnings;
use LWP::UserAgent;

#use HTTP::SimpleLinkChecker;
#
#            my $code = HTTP::SimpleLinkChecker::check_link($url);
#
#            unless( defined $code ) {
#                    print "Error: $HTTP::SimpleLinkChecker::ERROR\n";
#                    }


my $ua = LWP::UserAgent->new();
$ua->agent("mr. Robot");
my $req = HTTP::Request->new(GET => 'http://softland.ru');
my $res = $ua->request($req);
my @lines = split(/\n/, $res->content);
die "URL can not be reached!" unless $res->code == 200;
for (@lines) {
	print "$1\n" if (m#img.+src="(.+?)"#);
}
