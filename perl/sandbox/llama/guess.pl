#!/usr/bin/perl

use v5.022;

my $val = int(1+rand 100);

my $debug = $ENV{DEBUG} // 1;
say "secret is $val" if ($debug);
chomp(my $guess = <STDIN>);
while ($guess != $val) {
	say "secret is $val" if ($debug);
	last if ($guess =~ /exit|quit|\A\s*\z/i);  
	($guess > $val) ? say "2 high" : say "2 low";
	chomp($guess = <STDIN>);
}
