section .data

	from	dd	0;

section .text

	global _start

_start:
	nop
	mov [from], dword 0xdeadbeef
	nop
	mov eax, [from]
	nop

section .bss
