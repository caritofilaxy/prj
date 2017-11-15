#!/usr/bin/perl

use 
use Element;

$root;

open($db, "<", "elements.db");
while(<$db>) {
	next if /^#/;
	($name,$symbol,$ram,$an,$p) = split(",", $_);
	$tmp = Element->new($name,$symbol,$ram,$an,$p);
	$tmp->set_next($root);
	$root = $tmp;
}

while ($root) {
	printf "%-5s %-20s\n", $root->get_sym(), $root->get_name();
	$root = $root->set_next($root->get_next());
}
