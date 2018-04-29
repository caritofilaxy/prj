#include<stdio.h>
#include "lib.h"

int main(int argc, char **argv) {
	
	char c;
	c = *argv[1];

	printf("%c\n", case_switch(c));

	return 0;
}

