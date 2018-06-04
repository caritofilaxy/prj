#include<stdio.h>

unsigned espreg;

int main(void) {

	unsigned v1=0xdeadbeef;



	__asm__ __volatile__ ("movl %esp, espreg");

	printf("stack pointer: 0x%x\n", espreg);
	printf("0x%x %p\n", v1, (void*)&v1);

	return 0;
}
