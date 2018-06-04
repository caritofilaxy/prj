.section .data
line:
	.ascii "i am a line with ascii text"
	.equ linelen, .-line

.section .text
.globl _start
_start:
	nop
	movl $linelen, %ebx

	movl $0, %ebx
	movl $1, %eax
	int $0x80
