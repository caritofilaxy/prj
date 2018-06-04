.section .data
out:
	.int '8'

.section .text
.globl _start
_start:
	nop
	xor %eax, %eax
	xor %ebx, %ebx
	movb out, %al
	movb %al, %bl
	shl $4, %bl
	shr $4, %bl
	andb %bl, %al
	movl %eax, out
	

	movl $1, %eax
	movl $0, %ebx
	int $0x80
