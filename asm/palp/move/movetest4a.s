# indirect addressing

.section .data
out:
    .int 2, 2048, 512, 8192, 64

.section .text
.globl _start
_start:
    nop
# use "$" to get address of outtext label insead of its value
    movl $out, %edi
    movl $128, 8(%edi)
    movl $1, %eax
    movl 8(%edi), %ebx
    int $0x80
