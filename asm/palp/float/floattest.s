.section .data
value1:
    .float 12.34
value2:
    .double 2353.16

.section .bss
    .lcomm data, 8

.section .text
.globl _start
_start:
    nop
    flds value1
    flds value2
    fstl data

    movl $1, %eax
    movl $0, %ebx
    int $0x80
