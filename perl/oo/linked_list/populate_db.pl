#!/usr/bin/perl
#
# get eletement with properties from https://ascii.periodni.com
#

$index = `curl https://ascii.periodni.com`;
@index_lines = split(/\n/, $index);

for (@index_lines) {
	if (/href/) {
		@line = split(/\s+/, $_);
		for (@line) {
			if (/href=\"(.+?)\.html"/ and ! /index/) {
				push @syms, $1;
			}
		}
	}
}

%links = map { $_ => "https://ascii.periodni.com/$_.html" } @syms;

open($db, ">>", "elements.db");

for $symbol (keys %links) {
	$content = `curl https://ascii.periodni.com/$symbol.html`;
	@lines = split(/\n/, $content);
	for (@lines) {
		ucfirst($symbol);
		$elem{sym} = $symbol;
		$elem{name} = $1 if(m#English</A>:\s+(\S+)#);
		$elem{ram} = $1 if (m#Relative atomic mass:\s+(\S+?)\s+#);
		$elem{an} = $1 if (m#Atomic number:\s+(\d+)#);
		$elem{p} = $1 if (m#Period:\s+(\d+)#);
	}
	print $db "name, symbol, relative atomic mass, atomic number, period\n";
	print $db $elem{name}, ",", $elem{sym}, ",", $elem{ram}, ",", $elem{an}, ",", $elem{p}, "\n";
}
