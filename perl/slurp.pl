#!/usr/bin/perl

use strict;
use warnings;

my $text;

open(my $fh, "<", $0);
{
	local $/ = undef; # sets input record separator (newline) to undef
	$text = <$fh>;
}

print $text;
