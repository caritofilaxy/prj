#include<stdio.h>
#include<stdlib.h>
#include<string.h>

void swap(void *p1, void *p2, size_t el_size) {
	char *b = malloc(el_size);
	memcpy(b, p1, el_size);
	memcpy(p1, p2, el_size);
	memcpy(p2, b, el_size);
	free(b);
}

int main(void) {

	char **arr;

	char *a0 = strdup("a1a1a1a1");
	char *a1 = strdup("b2b2b2b2");


	*(arr) = a1;	
	*(arr+4) = a0;	

	puts(*arr);
	puts(*(arr+4));



	swap(a1, a0, strlen(a1));

	puts(*arr);
	puts(*(arr+4));

	return 0;
}
