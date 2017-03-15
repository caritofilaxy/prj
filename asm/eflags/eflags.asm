section .data
section .text

	global _start

_start:
	nop
	mov eax, 0x80000000
	shl eax, 1
	nop

section .bss
