#!/usr/bin/perl

use Element;

$root;

open($db, "<", "elements.db");
while(<$db>) {
	next if /^#/;
	($name,$symbol,$ram,$an,$p) = split(",", $_);
	$tmp = Element->new($name,$symbol,$ram,$an,$p);
	#$tmp->set_next(undef) unless $root;
	$tmp->set_next($root);
	$root = $tmp;
	$cnt++;
}

$cnt = 0;

while (defined $root->get_next()) {
	$root = root->get_next();
	$cnt++;
}
