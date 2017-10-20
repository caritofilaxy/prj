#include<stdio.h>
#include<string.h>
#include<stdlib.h>

int main(void) {
	int len;
	char *name;
	name = malloc(sizeof(name)*10);
	
	scanf("%s", name);

	len = strlen(name);

	printf("Hello %s %d\n", name, len);

	return 0;
}
