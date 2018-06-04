.section .data
data:
    .int -45

.section .text
.globl _start
_start:
    nop
    movl $-345, %eax
