#include<stdio.h>

int main(void) {

    if (__builtin_cpu_is("atom") && __builtin_cpu_supports("mmx"))
        printf("Im atom with mmx\n");

	return 0;
}
