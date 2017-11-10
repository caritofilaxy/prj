#!/usr/bin/perl

@lines = (<< "END_OF_HERE_DOC" =~ /^\s*(.+)/gm);
I sit beside the fire and think
of all that I have seen,
of meadow-flowers and butterflies
and summers that have been;
END_OF_HERE_DOC

print "***: $_\n" for (@lines);
