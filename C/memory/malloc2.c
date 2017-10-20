#include<stdio.h>
#include<stdlib.h>

#define A_MB (1024*1024)
#define FCTR 16
#define MEM_16_MB (A_MB*FCTR) 

int main(void) {

	char *mem_ptr;
	size_t sz_to_alloc = MEM_16_MB;
	int got_mbs = 0;

	while((mem_ptr = (char *)malloc(sz_to_alloc)) != NULL) {
			got_mbs += FCTR;
			sprintf(mem_ptr, "Kawabanga");
			printf("%s − now allocated %d Megabytes\n", mem_ptr, got_mbs);
		}
		
	printf("boo boo!\n");

	return 0;
}
