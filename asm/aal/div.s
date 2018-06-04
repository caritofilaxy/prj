.section .data
d:
	.int 2543	
dsor:
	.int 10

.section .bss
	.lcomm pid, 4

.section .text
.globl _start
_start:
	nop
	movw d, %ax
	movw d+2, %dx
	divl dsor
	movw %dx, pid+3  

	movw %ax, %dx
	divl dsor

	movw %dx, pid+2  

	divl dsor
	movb %al, pid+1  

	movb %ah, pid
	

	movl $1, %eax
	movl $0, %ebx
	int $0x80 
