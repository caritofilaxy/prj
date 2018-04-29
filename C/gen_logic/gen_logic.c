#include<stdio.h>

/*
short generic(short func, short a, short b, short c, short d) {
	return (func >> (a + b*2 + c*4 + d*8) & 1);
}
*/

short generic(short func, short a, short b) {
	return (func >> (a + b*2) & 1);
}

int main(void) {
	
	short func, a, b;
	func = 0x02;
	a = 1;
	b = 0;

	printf("%i\n", generic(func, a, b));

	return 0;
}
