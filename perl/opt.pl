#!/usr/bin/perl
#
use strict;
use warnings;
use v5.24;

my $argc = @ARGV;
my $usage_msg = "Usage: $0 create perl|c|asm name
       $0 delete name\n";
my $param_count_msg = "Wrong parameter number;";

die $param_count_msg unless (($argc == 2) or ($argc == 3));

my $sandbox_text;
my $makefile_text;

my $action;
my $lang;
my $name;

if ($argc == 3) {
	($action,$lang,$name) = @ARGV;
	die $usage_msg unless (($action =~ /^create$/ ) and ($lang =~ /^(perl|c|asm)$/) and ($name));
	my $flag = name_exists($name);
	unless ($flag) {
		create_structure($lang, $name); } 
	}

if ($argc == 2) {
	($action, $name) = @ARGV; 
	die $usage_msg unless (($action =~/^delete$/) and ($name)); 
	my $flag = name_exists($name);
	if ($flag) {
		delete_structure($name); } 
	}

sub name_exists {
	my ($dir) = @_;
	opendir(my $dh, ".");
	my $got = grep { -d $_ && $_ =~ /^$dir$/ } readdir($dh);
	$got;
	}
	
sub create_structure {
	my ($lng, $mn) = @_;
	say "Creation $lng $mn in progress...";
	if ($lng =~ /^asm$/) {
		$makefile_text = <<'MAKE_END';
NAME := sandbox
SOURCE := $(NAME).asm
OBJFILE := $(NAME).o

.PHONY: make
make: as ld

.PHONY: debug
debug: as_d ld

.PHONY: as
as:
	nasm -f elf -o $(OBJFILE) $(SOURCE)

.PHONY: as_d
as_d:
	nasm -f elf -g -F stabs $(SOURCE)

.PHONY: ld
ld:
	ld -o $(NAME) $(OBJFILE)
	rm -f $(OBJFILE)

.PHONY: clean
clean:
	rm -f $(OBJFILE) $(NAME)
MAKE_END

	$sandbox_text = <<'SANDBOX_END';
section .data
section .text

global _start

_start:
        nop
        mov eax, 0xabcd
        mov ebx, 0xff
        jmp 0x8048093
        add eax,1
        shr eax,2
        nop

section .bss
SANDBOX_END

	do_all($lng,$mn);
	
	}
	
	if ($lng =~ /^c$/) {
		$makefile_text = <<'MAKE_END';

NAME := sandbox
SOURCE := $(NAME).c
OBJFILE := $(NAME).o

.PHONY: make
make:
	gcc -o $(NAME) $(SOURCE)
	rm -rf $(OBJFILE);

.PHONY: clean
clean:
	rm -f $(OBJFILE) $(NAME)

MAKE_END

	$sandbox_text = <<'SANDBOX_END';
#include<stdio.h>

int main(void) {
	printf("hell\n");
	}

SANDBOX_END

	do_all($lng,$mn);

	}

	if ($lng =~ /^perl$/) {
	$sandbox_text = <<'SANDBOX_END';
#!/usr/bin/perl

use warnings;
use strict;
use v5.24;

SANDBOX_END

	$makefile_text = '';

	}

	do_all($lng,$mn);
}



	
sub delete_structure {
	my ($nm) = @_;
	say "Deletion $nm in progress...";}


sub create_dir {
        print "Making directory... ";
        my $name = shift;
        mkdir $name;
        print "Done.\n";
}


sub do_makefile {
	my $lang = shift;
        my $name = shift;
	unless ($lang =~ /^perl$/) {
        	print "Writing Makefile... ";
        	open(my $out, ">", "$name/Makefile");
        	$makefile_text =~ s/sandbox/$name/g;
        	print $out $makefile_text unless ($makefile_text);
        	close($out);
	   	print "Done.\n";
	}
}


sub do_src {
        my $lang = shift;
	my $name = shift;
	my $ext;
	$ext = "asm" if ($lang =~ /^asm$/);
	$ext = "c" if ($lang =~ /^c$/);
	$ext = "pl" if ($lang =~ /^perl$/);
        print "Writing template... ";
        open(my $out, ">", "$name/$name.$ext");
        print $out $sandbox_text;
        close($out);
	#chmod 0755, "$name/$name.$ext" if ($ext =~ /^pl$/);
        print "Done.\n";
}

sub do_all {
	my $lang = shift;
        my $name = shift;
        create_dir($name);
        do_makefile($lang,$name);
        do_src($lang,$name);
}

