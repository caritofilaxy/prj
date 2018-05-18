#include<stdio.h>

/*
47 produces overflow of unsigned int and im just a lazy piece of crap to make it long, 
moreover its just an example 
*/

#define F 46 

/* array for fibo numbers */
unsigned fibos[F];
/* counter value to pass into asm */
unsigned c=F;


int main(void) {
	unsigned *p;
	
	__asm__ __volatile__ ("movl $1, %eax\n\t"
				"movl $1, %ebx\n\t"
				"movl $2, %ecx\n\t"
				"movl %eax, fibos(, %edi, 4)\n\t"
				"inc %edi\n\t"
				"movl %eax, fibos(, %edi, 4)\n\t"
				"inc %edi\n\t"
				"loop: movl %eax, %edx\n\t"
				"addl %ebx, %eax\n\t"
				"movl %eax, fibos(, %edi, 4)\n\t"
				"cmp c, %ecx\n\t"
				"je exit\n\t"
				"movl %edx, %ebx\n\t"
				"inc %edi\n\t"
				"inc %ecx\n\t"
				"jmp loop\n\t"
				"exit:");

	*(fibos+F) = '\0';

	p = fibos;
	
	while (*p != '\0') {
		printf("%i\n", *p);
		*p++;
	}

	return 0;
}
