#include<stdio.h>

int compare(const void *p1, const void *p2, size_t size) {
    while (*p1 == *p2) {
        p1+=size;
        p2+=size;
    }

    return p2 - p1;
}

int main(void) {
	printf("%s\n", MSG);

	return 0;
}
