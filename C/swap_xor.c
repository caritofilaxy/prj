#include<stdio.h>

int main(void) {
	int a1=16, a2=32;
	
	printf("%i %i\n", a1, a2);

	a1 = a1 ^ a2;
	a2 = a2 ^ a1;
	a1 = a1 ^ a2;

	printf("%i %i\n", a1, a2);
}	
