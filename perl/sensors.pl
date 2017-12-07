#!/usr/bin/perl

use Term::ANSIColor qw(:constants);  

while(1) {
    print "\033[2J";
    @output = `sensors`;
    $tcosum = 0;
    $tc = 0;
    $tm = 0;
    $c = 0;
    for (@output) {
        if (/^CPU T/) {
           ($m,undef, $tc) = split(/\s+/, $_);
            $tc =~ s/\+(\d+).+/$1/;
        }
    
        if (/^MB/) {
           ($m,undef, $tm) = split(/\s+/, $_);
            $tm =~ s/\+(\d+).+/$1/;
        }

        if (/(^Core)/) {
            $c++;
            $core_t = (split(/\s+/, $_))[2];
            $core_t =~ s/\+(\d+).+/$1/;
            $tcosum += $core_t;
        }
    }
$avg = $tcosum/$c;
$avg = ($avg + $tm + $tc) / 3;
printf "%.4f", c_print($avg);

sleep 5;
} 


sub c_print {
    if ($_[0] > 50) {
        print RED, $_[0], RESET;
    } else {
        print GREEN, $_[0], RESET;
    }
print "\n";
}
