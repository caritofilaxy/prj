cpuid: cpuid.o
	ld -o cpuid cpuid.o
cpuid.o: cpuid.asm
#	nasm -f elf -g -F stabs cpuid.asm -l cpuid.lst
	nasm -f elf -g cpuid.asm 
