#!/usr/bin/perl

use strict;
use warnings;

use Dancer2;

my $main_page = "Main page!";
my $contacts = "1-800-XXX-XX-XX";

get '/' => sub {
	return $main_page;
};

get '/contacts' => sub {
	return $contacts;
};

start;
