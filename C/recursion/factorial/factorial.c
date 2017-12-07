#include<stdio.h>

int fact(int n) {
    if (n == 0) 
        return 1;
     else
        return n*fact(n-1);
}

int main(void) {
    int i;
    for (i=0;i<=10;i++)
        printf("%i\n",fact(i));

	return 0;
}
