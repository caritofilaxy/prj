#!/usr/bin/perl
#
use v5.24;

say "\tstart main running here";
#kill -9, $$; # kill myself before die
die "\tmain now dying here\n";
die "XXX: not reached\n";
UNITCHECK	{ say "1st unitcheck:			done compiling"; }
END		{ say "1st end:			done running"; }
CHECK		{ say "1st check:			done compiling"; }
INIT		{ say "1st init:			started running" ;}
END		{ say "2nd end:			done running"; }
BEGIN		{ say "1st begin:			still compiling" ; }
INIT		{ say "2nd init:			started running" ;}
BEGIN		{ say "2nd begin:			still compiling" ; }
CHECK		{ say "2nd check:			done compiling"; }
END		{ say "3rd end:			done running"; }

