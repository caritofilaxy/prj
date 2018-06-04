.section .data
line:
	.ascii "i am a line with ascii text"
line_len:
#	.equ linelen, .-line

.section .text
.globl _start
_start:
	nop
	movl $line, %ebx
	movl $line_len, %eax
	subl %ebx, %eax

	movl $0, %ebx
	movl $1, %eax
	int $0x80
