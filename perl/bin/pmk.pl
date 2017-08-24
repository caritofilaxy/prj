#!/usr/bin/env perl
#
use strict;
use warnings;
use v5.22;

############### TEMPLATES ##################
### C ###
my $sandbox_c = <<"SANDBOX_C";
\#include<stdio.h>

\#define MSG \"Hello world\"

int main(void) {
	printf("\%s\\n", MSG);

	return 0\;
}
SANDBOX_C

my $makefile_c = <<"MKFILE_C";
NAME := sandbox
SOURCE := \$\(NAME\).c
OBJFILE := \$\(NAME\).o

make:
	gcc -o \$(NAME) \$(SOURCE)

MKFILE_C

### ASM ###
my $sandbox_asm = <<"SANDBOX_ASM";
section .data
section .text

	global _start

_start:
	nop

	nop

section .bss
SANDBOX_ASM

my $makefile_asm = <<"MKFILE_ASM";
NAME := sandbox
SOURCE := \$(NAME).asm
OBJFILE := \$(NAME).o

.PHONY: make
make: as ld

.PHONY: debug
debug: as_d ld

.PHONY: as
as:
	nasm -f elf -o \$(OBJFILE) \$(SOURCE)

.PHONY: as_d
as_d:
	nasm -f elf -g -F stabs \$(SOURCE)

.PHONY: ld
ld:
	ld -m32 -o \$(NAME) \$(OBJFILE)

.PHONY: clean
clean:
	rm -f \$(OBJFILE) \$(NAME)
MKFILE_ASM

#### PERL ####
my $sandbox_perl = <<"SANDBOX_PERL";
#!/usr/bin/env perl

use strict;
use warnings;
use v5.22;

SANDBOX_PERL

############### TEMPLATES ##################3

my ($name, $lang) = @ARGV;
mkdir $name;

my $sandbox;
my $makefile;
my $ext;

if ($lang eq 'c') {
	$sandbox = $sandbox_c;
	$makefile = $makefile_c;
	$ext = 'c';
} elsif ($lang eq 'asm') {
	$sandbox = $sandbox_asm;
	$makefile = $makefile_asm;
	$ext = 'asm';
} elsif ($lang eq 'perl') {
	$sandbox = $sandbox_perl;
	$makefile = '';
	$ext = 'pl';
} else {
	say "Wrong lang";
}

if ($makefile) {
	$makefile =~ s#sandbox#$name#g;
	open(my $mkfl, ">", "$name/Makefile") || die "cant open $name/Makefile";
	print $mkfl $makefile;
	close($mkfl);
}

open(my $sb, ">", "$name/$name.$ext") || die "cant open $name/$name.$ext";
print $sb $sandbox;
close($sb);
chmod 0755, "$name/$name.$ext" if ($lang eq 'perl') ;
exec "vim $name/$name.$ext";

