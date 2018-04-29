#include<stdio.h>

int main(int argc, char **argv) {
	
	int i;

	printf("argc: %i\n", argc);

	for (i=0; i<argc; i++)
		printf("arg %i: %s\n", i, argv[i]);

	return 0;
}
