#include<stdio.h>

typedef double(proc)(int);

int main(void) {
	
	proc myproc;

	printf("%f\n", myproc(4));

	return 0;


double myproc(int x) { return 42.0 + x; } 

	
	
