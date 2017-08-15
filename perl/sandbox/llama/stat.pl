#!/usr/bin/perl

use v5.022;
use warnings;

# my($dev, $ino, $mode, $nlink, $uid, $gid, $rdev,$size, $atime, $mtime, $ctime, $blksize, $blocks) = stat($filename);

say foreach (stat($0));
