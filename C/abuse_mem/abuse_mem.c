#include<stdlib.h>

#define ONE_K 1024

int main(void) {

		char *mem_ptr, *scan_ptr;

		mem_ptr = (char *)malloc(ONE_K);
		scan_ptr = mem_ptr;
		
		for(;;) {
			*scan_ptr = '\0';
			scan_ptr++;
		}

		exit(EXIT_SUCCESS);

        return 0;
}
