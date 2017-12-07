#include<stdio.h>

int compare(const void *p1, const void *p2, size_t size) {
    if (1 == size) 
        if ((char *)p1 == (char *)p2)
            return 0;
        else
            return *p1 - *p2;

    if (2 == size)
        if ((short *)p1 == (short *)p2)
            return 0;
        else
            return *p1 - *p2;

    if (4 == size)
        if ((int *)p1 == (int *)p2)
            return 0;
        else
            return *p1 - *p2;

    if (8 == size)
        if ((double *)p1 == ( *)p2)
            return 0;
        else
            return *p1 - *p2;

}

int main(void) {
	printf("%s\n", MSG);

	return 0;
}
