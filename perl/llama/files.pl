#!/usr/bin/perl

use v5.022;
use warnings;

my $file = $ARGV[0];

say "$file exists" if -e $file;
say -r _ ? "$file readable" : "Cant read $file";
say "$file is nonzero size and is setiud" if ( -s -u _ );

#  -r File or directory is readable by this (effective) user or group
#  -w File or directory is writable by this (effective) user or group
#  -x File or directory is executable by this (effective) user or group
#  -o File or directory is owned by this (effective) user
#  -R File or directory is readable by this real user or group
#  -W File or directory is writable by this real user or group
#  -X File or directory is executable by this real user or group
#  -O File or directory is owned by this real user
#  -e File or directory name exists
#  -z File exists and has zero size (always false for directories)
#  -s File or directory exists and has nonzero size (the value is the size in bytes)
#  -f Entry is a plain file
#  -d Entry is a directory
#  -l Entry is a symbolic link
#  -S Entry is a socket
#  -p Entry is a named pipe (a “fifo”)
#  -b Entry is a block-special file (like a mountable disk)
#  -c Entry is a character-special file (like an I/O device)
#  -u File or directory is setuid
#  -g File or directory is setgid
#  -k File or directory has the sticky bit set
#  -t The filehandle is a TTY (as reported by the isatty() system function; filenames can’t be tested by this test)
#  -T File looks like a “text” file
#  -B File looks like a “binary” file
#  -M Modification age (measured in days)
#  -A Access age (measured in days)
#  -C Inode-modification age (measured in days)


