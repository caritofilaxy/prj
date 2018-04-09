# indirect addressing

.section .data
outtext:
    .ascii "this is a line of text\n"

.section .text
.globl _start
_start:
    nop
# use "$" to get address of outtext label insead of its value
    movl $outtext, %edi
    movl $4, %eax
    movl $1, %ebx
    movl %edi, %ecx
    movl $23, %edx
    int $0x80
    movb $0x46, 10(%edi)
    movb $0x49, 11(%edi)
    movb $0x4c, 12(%edi)
    movb $0x45, 13(%edi)
    movl $4, %eax
    movl $1, %ebx
    movl %edi, %ecx
    movl $23, %edx
    int $0x80
    movl $1, %eax
    movl $0, %ebx
    int $0x80
