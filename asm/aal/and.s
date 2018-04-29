.section .text
.globl _start
_start:

	nop
	movw $0x0FF00, %ax
	movw $0x00FF0, %bx
	andw %ax, %bx

	movl $1, %eax
	movl $0, %ebx
	int $0x80
