#!/usr/bin/env perl
#
use strict;
use warnings;
use v5.24;

use Cwd 'abs_path';

my $argc = @ARGV;
my $name;
my @langs;

my $exec_dir = abs_path($0);
$exec_dir =~ s#/\w+\.pl$##;
opendir(my $dh, "$exec_dir/tmplts") || die "Can not open tmplts dir\n";
my @tmplts = grep { ! /^\./ } readdir($dh);

if (($argc == 1) and ($ARGV[0] eq 'list')) {
	print_langs();
} else {
	($name, @langs) = @ARGV;
	die "Select at least one lang\n" unless (@langs);
	foreach (@tmplts) { die "Wrong name $name\n" if ($name eq $_) };
	mkdir $name;
	foreach (@langs) {
		mkdir "$name/$_";	
		mk_lang($_);
	}
}

sub mk_lang {
	my $lang = shift;
	my $ext = $lang;
	$ext = 'pl' if $lang eq 'perl';
	if ( -e "$exec_dir/tmplts/$lang/sandbox.$ext") {
		open(my $fh_in, "<", "$exec_dir/tmplts/$lang/sandbox.$ext");
		open(my $fh_out, ">", "$name/$lang/$name.$ext");
		while(<$fh_in>) {
			s#sandbox#$name#;
			print $fh_out $_;
		}
	close($fh_in);
	close($fh_out);
	chmod 0755, "$name/$lang/$name.$ext" if $ext eq 'pl';
	}
	
	if ( -e "$exec_dir/tmplts/$lang/Makefile") {
		open(my $fh_in, "<", "$exec_dir/tmplts/$lang/Makefile");
		open(my $fh_out, ">", "$name/$lang/Makefile");
		while(<$fh_in>) {
			s#sandbox#$name#;
			print $fh_out $_;
		}
	close($fh_in);
	close($fh_out);
	}
}

sub print_langs {
	print "Available templates: "; 
	print "$_ " foreach @tmplts;
	print "\n";
}
