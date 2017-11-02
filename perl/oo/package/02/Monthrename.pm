package Monthrename;

use List::MoreUtils qw(firstidx);

@h_names = qw(jan feb mar apr may jun jul aug sep oct nov dec);

sub m2h {
    my ($mname, @arr) = @_;
    my $index = firstidx { $_ eq $mname } @arr;
    return false unless $index;
    return $h_names[$index];
}
        


