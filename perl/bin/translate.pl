#!/usr/bin/perl

use LWP::UserAgent;
use XML::Simple;
use HTML::StripTags qw(strip_tags);
#use Data::Dumper;

my $string = @ARGV[0];
my $req;

my $ua = LWP::UserAgent->new;

$req = HTTP::Request->new(GET => "https://translate.yandex.net/api/v1.5/tr.json/translate?key=trnsl.1.1.20170209T090607Z.a39f7575b059cdb5.3504d8ba72ef20024d1fe3416505cc36b7272f51&text=$string&lang=en-ru&format=plain" );
my $tr = $ua->request($req);

my $tr_text = $tr->content;
$tr_text =~ s#^.+\[\"(.+)\"\].+$#$1#;

print $tr_text."\n";
print "\n";
