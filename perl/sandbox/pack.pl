#!/usr/bin/perl -w
use strict;

# dump the contents of a string as decimal and hex bytes and characters
sub DumpString {
    my @a = unpack('C*',$_[0]);
    my $o = 0;
    while (@a) {
        my @b = splice @a,0,16;
        my @d = map sprintf("%03d",$_), @b;
        my @x = map sprintf("%02x",$_), @b;
        my $c = substr($_[0],$o,16);
        $c =~ s/[[:^print:]]/ /g;
        printf "%6d %s\n",$o,join(' ',@d);
        print " "x8,join('  ',@x),"\n";
        print " "x9,join('   ',split(//,$c)),"\n";
        $o += 16;
    }
}

# place our web order
my $t = time;
my $emp_id = 217641;
my $item = "boxes of paperclips";
my $quan = 2;
my $urgent = 1;
my $rec = pack( "l i a32 s2", $t, $emp_id, $item, $quan, $urgent);
DumpString($rec);

# process a web order
my ($order_time, $monk, $itemname, $quantity, $ignore) =
       unpack( "l i a32 s2", $rec );
print "Order time: ",scalar localtime($order_time),"\n";
print "Placed by monk #$monk for $quantity $itemname\n";

# string formats
$rec = pack('a8',"hello");               # should produce 'hello\0\0\0'
DumpScalar($rec);
$rec = pack('Z8',"hello");               # should produce 'hello\0\0\0'
DumpScalar($rec);
$rec = pack('A8',"hello");               # should produce 'hello   '
DumpScalar($rec);
($rec) = unpack('a8',"hello\0\0\0");     # should produce 'hello\0\0\0'
DumpScalar($rec);
($rec) = unpack('Z8',"hello\0\0\0");     # should produce 'hello'
DumpScalar($rec);
($rec) = unpack('A8',"hello   ");        # should produce 'hello'
DumpScalar($rec);
($rec) = unpack('A8',"hello\0\0\0");     # should produce 'hello'
DumpScalar($rec);

# bit format
$rec = pack('b8',"00100110");            # should produce 0x64 (100)
DumpScalar($rec);
$rec = pack('B8',"00100110");            # should produce 0x26 (38)
DumpScalar($rec);

# hex format
$rec = pack('h4',"1234");                # should produce 0x21,0x43
DumpScalar($rec);
$rec = pack('H4',"1234");                # should produce 0x12,0x34
DumpScalar($rec);
