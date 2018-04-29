# push values to fpu stack
# info all

.section .text
.globl _start
_start:
    nop
# push pi
    fldpi
# push log (base 10) 2
    fldlg2
# push log (base e) 2
    fldln2

    movl $1, %eax
    movl $0, %ebx
    int $0x80

