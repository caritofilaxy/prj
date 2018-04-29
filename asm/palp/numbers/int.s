.section .data
val:
    .int 0x225

.section .text
.globl _start
_start:
    nop
    movl $val, %eax
    movl val, %ecx
    movl (val), %edx
    movl $1, %ebx
    int $0x80
    
