#include<stdio.h>
#include<string.h>
#include<stdlib.h>

void swap(void *vp1, void *vp2, int size) {
	char *buffer = malloc(size);
	memcpy(buffer,vp2,size);
	memcpy(vp2,vp1,size);
	memcpy(vp1,buffer,size);
}

int main(void) {

	char *husband = strdup("Fred");
	char *wife = strdup("Wilma");		

	swap(&husband, &wife, sizeof(char(*)));
/*	swap(husband, wife, sizeof(char(*))); */

	printf("h: %s\tw: %s\n", husband, wife);
		
    return 0;
}
