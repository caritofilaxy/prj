#include<stdio.h>
#include<string.h>

void swap(void *vp1, void *vp2, int bsize) {
    char buffer[bsize];
    memcpy(buffer,vp1, bsize);
    memcpy(vp1, vp2, bsize);
    memcpy(vp2, buffer, bsize);
}
 
int main(void) {

    int a = 4;
    int b = 2;
    printf("%i %i\n", a, b);
    swap(&a,&b,sizeof(int));
    printf("%i %i\n", a, b);

    double c = 3.14;
    double d = 2.71;
    printf("%.2f %.2f\n", c, d);
    swap(&c, &d, sizeof(double));
    printf("%.2f %.2f\n", c, d);
}
