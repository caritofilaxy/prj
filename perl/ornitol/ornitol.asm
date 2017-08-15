section .data
section .text

global _start

_start:
        nop
        mov eax, 0xabcd
        mov ebx, 0xff
        jmp 0x8048093
        add eax,1
        shr eax,2
        nop

section .bss
