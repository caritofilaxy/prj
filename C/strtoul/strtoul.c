#include<stdlib.h>
#include <stdio.h>

int main (int argc, char *argv[])
{

    unsigned long int id = 0;
	
	if (argc != 2) {
		printf("Usage: ./prg number\n");
		return -1;
	}


    id = strtoul(argv[1], NULL, 16);
    printf("value: %lx\n", id);

    return 0;
}
