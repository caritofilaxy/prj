# .section .data
out:
    .asciz "It is a good day to die\n"
outend:
    .equ len, outend - out

.section .text
.globl _start
_start:
    nop

    movl $4, %eax
    movl $1, %ebx
    movl $out, %ecx
    movl $len, %edx
    int $0x80

    movl $1, %eax
    movl $0, %ebx
    int $0x80
