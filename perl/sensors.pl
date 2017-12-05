#!/usr/bin/perl

use Term::ANSIColor;                

while(1) {
    print "\033[2J";
    @output = `sensors`;
    $sum = 0;
    $c = 0;
    for (@output) {
        if (/^CPU T/) {
           ($m,undef, $m_t) = split(/\s+/, $_);
            $m_t =~ s/\+(\d+).+/$1/;
            print $m . ": ";
            if ($m_t > 60) {
                print_red($m_t);
                print "\n";
            } else {
                print_green($m_t);
                print "\n";
            }
        }
    
        if (/^MB/) {
           ($m,undef, $m_t) = split(/\s+/, $_);
            $m_t =~ s/\+(\d+).+/$1/;
            print $m . ": ";
            if ($m_t > 45) {
                print_red($m_t);
                print "\n";
            } else {
                print_green($m_t);
                print "\n";
            }
        }

        if (/(^Core)/) {
            $c++;
            $core_t = (split(/\s+/, $_))[2];
            $core_t =~ s/\+(\d+).+/$1/;
            $sum += $core_t;
        }
    }
$avg = $sum/$c;
print "Cores: "; 
if ($avg > 65) {
    print_red($avg);
} else {
    print_green($avg);
}
print "\n";

sleep 5;
} 


sub print_red {
    $val = shift;
    print color 'red';
    print $val;
    print color 'reset';
}

sub print_green {
    $val = shift;
    print color 'green';
    print $val;
    print color 'reset';
}
