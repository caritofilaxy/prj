#include<stdio.h>
#include<stdlib.h>

#define A_MB (1024*1024)

int main(void) {

	char *mem_ptr;
	size_t sz_to_alloc = A_MB;
	int got_mbs = 0;

	while(got_mbs < 512) {
		mem_ptr = (char *)malloc(sz_to_alloc);
		if (mem_ptr != NULL) {
			got_mbs++;
			sprintf(mem_ptr, "Kawabanga");
			printf("%s − now allocated %d Megabytes\n", mem_ptr, got_mbs);
		} else {
			exit(EXIT_FAILURE);
		}
	}

	return 0;
}
