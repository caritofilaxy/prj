#!/usr/bin/perl

use v5.22;
use warnings;
use IO::Socket::INET;

my $socket = IO::Socket::INET->new('localhost:2345');

print $socket "Knock knock";

my $answer = <$socket> =~ s/\R\z//r;
say "Got reply: $answer";

close($socket);


