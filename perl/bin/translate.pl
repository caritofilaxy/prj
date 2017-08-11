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

$req = HTTP::Request->new(GET => "https://dictionary.yandex.net/api/v1/dicservice/lookup?key=dict.1.1.20170209T095644Z.cbcf637ed3552f7d.b15d691e3a45abbe5248ff62eceb6531a68e64d2&lang=en-ru&text=$string" );
my $dic = $ua->request($req);

my $tr_text = $tr->content;
$tr_text =~ s#^.+\[\"(.+)\"\].+$#$1#;

my $dic_text = $dic->content;
my $parser = XMLin($dic_text, forcearray => 1);


print $tr_text."\n";
print "\n";

my $xmlout = XMLout($parser, xmldecl => 1, NoAttr => 1, rootname => 'text');
print strip_tags($xmlout);
