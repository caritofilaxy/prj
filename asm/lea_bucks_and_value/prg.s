.section .data
r:
	.int 42, 64, 38

.section .text
.globl _start
_start:

	nop
# movin value in r to eax
	movl r, %eax
#movin addr of r to %ebxx
	movl $r, %ebx
# same, movin addr of r to 
	leal r, %ecx
	
# presenting indexed memory locations
# moving index to %edi
	movl $1, %edi
#movin value with addr r, offset 0, index %edi and size 4 to %esi
	movl r(,%edi,4), %esi

	movl $0, %ebx
	movl $1, %eax
	int $0x80

