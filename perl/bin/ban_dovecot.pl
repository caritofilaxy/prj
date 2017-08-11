#!/usr/bin/perl

use feature say;
use warnings;

my $file = "/var/log/dovecot/dovecot-info.log";
my $matched;
my @ipt_rules;

my $now = scalar localtime();

open(my $fh,"<",$file) || die "Cant open file $!";
while(<$fh>) {
	if (m#auth:\sInfo:\s\w+-\w+\(.+?,(.+?)\):\s(unknown user|Password mismatch)#) {
		next if /dil_otchet/;
		$matched->{$1} = 1;
	}
}

$matched = [ keys %$matched ];
@ipt_rules = `/sbin/iptables-save`;

for my $p (@$matched) {
		next if $p =~ /192.168.12/;
		unless ( grep { $_ =~ $p } @ipt_rules ) {
			system("/sbin/iptables -I INPUT 1 -i eth0 -s $p -m comment --comment \"Dovecot at $now\" -j DROP\n");
                }
}
