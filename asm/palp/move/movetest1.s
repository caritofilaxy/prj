.section .data
val:
    .int 1

.section .text
.globl _start
_start:
    nop
    movl val, %ecx
    movl $1, %eax
    movl $0, %ebx
    int $0x80
