# i receive a char as an argument and switch case.

.section .data
argerr:
	.ascii "Usage: me char\n"
argerrlen:
	.equ len, argerrlen - argerr

.section .bss
	.lcomm out, 2

.section .text
.globl _start
_start:
	movl (%esp), %eax
	cmp $0x00000002, %eax
	jnz err
	nop
	xor %eax, %eax
	movl 8(%esp), %ebp
	movb (%ebp), %al
	movb $0x20, %bl
	test %bl, %al
	jz l
	not %bl
	andb %bl, %al
	movb %al, (out)
	movb $0xA, (out+1)
	call write
	call exit
l:
	or %bl, %al
	movb %al, (out)
	movb $0xA, (out+1)
	call write
	call exit
err:
	movl $4, %eax
        movl $1, %ebx
        movl $argerr, %ecx
        movl $len, %edx
	int $0x80
	call exit

write:
	push %ebp
	movl %esp, %ebp
	movl $4, %eax
	movl $1, %ebx
	movl $out, %ecx
	movl $2, %edx
	int $0x80
	popl %ebp
	ret

exit:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
