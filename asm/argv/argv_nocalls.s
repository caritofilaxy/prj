.section .data
	args:
		.int 1
	len:
		.int 1
.section .bss
	.lcomm output, 10


.section .text
.globl _start
_start:

# save number of args
# if 0 - exit
	movl (%esp), %ebp
	movl %ebp, %ebx
	dec %ebx
	movl %ebx, args
	cmp $0, %ebx  
	je exit

# put address of first arg's char to ebp
	movl 8(%esp), %ebp
	

another_arg:
#get length of current argmnt
	movl %ebp, %ebx

	xor %eax, %eax
	xor %ecx, %ecx
get_len:
# copy first char to al 
	movb (%ebx), %al
# if al = 0 jump to proceed
	cmp $0, %al
	je proceed
# else
	inc %ebx
	inc %ecx
	jmp get_len

proceed:
#setup for string processing
# put address of first arg's char to source index
	movl %ecx, len
# put address of source to source index
	movl %ebp, %esi
# put address of destination in memory arg's char to destination index
	leal output, %edi
# set direction flag to increment esi
	cld
# trrrrrrrram.... copy from esi to edi until esi = 0
	rep movsb
# add 0 to the end of string
	push %eax
	movl $output, %eax
	addl len, %eax
	movl $0, (%eax)
	popl %eax

# write to stdout
	movl $len, %ecx
	movl $output, %edx
	movl $1, %ebx
	movl $4, %eax
	int $0x80


# if args = 1
	movl args, %eax
	cmp $1, %eax
# exit
	je exit
# else
	dec %eax
	movl %eax, args
	addl len, %ebp
	inc %ebp
	jmp another_arg

exit:
# exit with $? = 0
	movl $1, %eax
	movl $0, %ebx
	int $0x80

