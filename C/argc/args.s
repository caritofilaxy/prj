	.file	"args.c"
	.comm	p,4,4
	.comm	arg,100,64
	.section	.rodata
.LC0:
	.string	"argc: %i\n"
.LC1:
	.string	"argv[0]: %s\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	leal	4(%esp), %ecx
	.cfi_def_cfa 1, 0
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	.cfi_escape 0x10,0x5,0x2,0x75,0
	movl	%esp, %ebp
	pushl	%edi
	pushl	%ecx
	.cfi_escape 0xf,0x3,0x75,0x78,0x6
	.cfi_escape 0x10,0x7,0x2,0x75,0x7c
#APP
# 8 "args.c" 1
	nop
# 0 "" 2
#NO_APP
	movl	%eax, p
	movl	p, %eax
	subl	$8, %esp
	pushl	%eax
	pushl	$.LC0
	call	printf
	addl	$16, %esp
	movl	$arg, %eax
	movl	%eax, %edi
#APP
# 11 "args.c" 1
	pusha
	movl 4(%ecx), %ebx
	movl (%ebx), %esi
	cld
	rep movsb
	popa
# 0 "" 2
#NO_APP
	subl	$8, %esp
	pushl	$arg
	pushl	$.LC1
	call	printf
	addl	$16, %esp
	movl	$0, %eax
	leal	-8(%ebp), %esp
	popl	%ecx
	.cfi_restore 1
	.cfi_def_cfa 1, 0
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_restore 5
	leal	-4(%ecx), %esp
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Debian 4.9.2-10+deb8u1) 4.9.2"
	.section	.note.GNU-stack,"",@progbits
