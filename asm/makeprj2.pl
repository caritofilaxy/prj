#!/usr/bin/perl
#
use strict;
use warnings;

my $makefile_text = <<'MAKE_END';
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

.PHONY: clean
clean:
	rm -f $(OBJFILE) $(NAME)
MAKE_END

my $sandbox_text = <<'SANDBOX_END';
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



my $argc = @ARGV;
my $prj = $ARGV[0];

die "Name, sister" unless $argc == 1;

do_all($prj);


sub create_dir {
	print "Making directory... ";
	my $name = shift;
	mkdir $name;
	print "Done.\n";
}


sub do_makefile {
	my $name = shift;
	print "Writing Makefile... ";
	open(my $out, ">", "$name/Makefile");
	$makefile_text =~ s/sandbox/$name/g;
	print $out $makefile_text;
	close($out);
	print "Done.\n";
}


sub do_src {
	my $name = shift;
	print "Writing template... ";
	open(my $out, ">", "$name/$name.asm");
	print $out $sandbox_text;
	close($out);
	print "Done.\n";
}

sub do_all {
	my $name = shift;
	create_dir($name);
	do_makefile($name);
	do_src($name);
}

