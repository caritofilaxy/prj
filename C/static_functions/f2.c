#include<stdio.h>

void demo(void) {
	static int a = 42;
	printf("%i\n", a++);
}

int main(void) {
	demo();
	demo();
	demo();

	return 0;
}
