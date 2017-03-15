section .data
section .text

	global _start

_start:
	mov eax, 0x00000000
	cpuid
	nop

section .bss
