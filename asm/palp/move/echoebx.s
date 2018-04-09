# echo $?
.section .data
out:
    .int 0x4c 

.section .text
.globl _start
_start:
    nop
    movl out, %ebx
    movl $1, %eax
    int $0x80
