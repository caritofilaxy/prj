#include<stdio.h>

int main(void) {
	
	long array[] = {1,2,3};

/*
        unsigned short i0 = 0xDD;
        unsigned int i1 = 0xDD;
        unsigned long i2 = 0xDD;
*/      
	printf("%zu \n", sizeof(array));
	printf("%zu \n", sizeof(array[0]));


        return 0;
}
