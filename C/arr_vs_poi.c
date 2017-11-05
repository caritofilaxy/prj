#include <stdio.h>

/*
void func(char subarray[100],char* pointer) {
       printf("sizeof subarray=%zd\n", sizeof(subarray));
       printf("address of subarray=%p\n", (void *)subarray);
       printf("pointer            =%p\n", (void *)pointer);
}


int main() {
       char array[100];
       printf("sizeof of array=%zd\n", sizeof(array));
       printf("address of array=%p\n", (void *)array);
       printf("address of array[0]=%p\n", (void *)&array[0]);
       func(array,array);

	   printf("%c %d\n", array[3], arr[3]);
} 
*/


int main(void) {

	   short arr[5];
	   

	   *(arr) = 16;
	   *(arr+1) = 32;
	   *(arr+2) = 64;
	   *(arr+3) = 128;
	   *(arr+4) = 255;

		printf("%i\n", arr[3]);

		*((char *)arr+7) = 0x2;

		printf("%i\n", *((short *)arr+3));

		return 0;
}
		
