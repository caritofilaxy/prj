.section .bss
	.lcomm fibos, 100

.section .text
.globl _start
_start:
	
	nop
	xor %edi, %edi
	xor %ebx, %ebx

	movl $1, %eax
	movl $1, %ebx
	movl $2, %ecx

	movl %eax, fibos(, %edi, 4)
	inc %edi
	movl %eax, fibos(, %edi, 4)
	inc %edi

loop:
	movl %eax, %edx
	addl %ebx, %eax
	movl %eax, fibos(, %edi, 4)
	cmp $0xff, %ecx
	je exit
	movl %edx, %ebx
	inc %edi
	inc %ecx
	jmp loop

exit:
	movl $0, %ebx 
	movl $1, %eax 
	int $0x80 
