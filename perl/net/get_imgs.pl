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
my $req = HTTP::Request->new(GET => 'http://www.communigate.com/ru/main/purchase/scriptrepository.html');
my $res = $ua->request($req);
my @lines = split(/\n/, $res->content);
die "URL can not be reached!" unless $res->code == 200;
for (@lines) {
	print "http://www.communigate.com$1\n" if (m#A HREF="(.+?\.pl)"#);
}
