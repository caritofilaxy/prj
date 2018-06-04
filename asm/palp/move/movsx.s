 .section .data
 value:
#    .byte 42, 255
    .int 42, 65535
    .long 42, 4294967294

# .section .bss
#    .comm arr_size, 8
#    .lcomm biffer, 10000

.section .text
.globl _start
_start:
    nop
    xor %eax, %eax
    mov $3, %edi
    mov value(, %edi, 4), %eax
    movw value, %bx
    movsx %bx, %eax

    mov $1, %eax
    mov $18, %ebx
    int $0x80
