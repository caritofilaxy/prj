.section .text
.globl _start
_start:
	nop
	xor %al, %al
	xor %bl, %bl
	movb $0xfe, %al
	movb $0xfe, %bl
	shr %al
	sar %bl


	movl $1, %eax
	movl $0, %ebx
	int $0x80
