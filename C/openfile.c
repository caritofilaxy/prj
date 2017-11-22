#include<stdio.h>
#include<stdlib.h>

int main(void) {

    FILE *fp = fopen("openfile.conf", "r");

    if (!fp) {
        printf("can not open file\n");
        exit(EXIT_FAILURE);
    } else {
        printf("File opened!\n");
        fclose(fp);
        }

	return 0;
}
