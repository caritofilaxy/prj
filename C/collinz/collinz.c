#include<stdio.h>

#define MSG "Hello world"

int magic(int x) {
    int c=0;
    while   ( x != 1 && x != 0 ) {
        if (x%2 == 0)
            x/=2;
        else
            x = 3*x+1;
/*        printf("%i ", x);     */   
        c++;
    }
/*   printf("\n"); */

    return c;
}

int main(void) {
    
    int i;

    for (i = 1000; i < 10000; i += 753)
        printf("%i\n", magic(i));

	return 0;
}
