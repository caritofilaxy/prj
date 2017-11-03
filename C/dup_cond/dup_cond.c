/*
* gcc -Wall -Wextra -pedantic -std=c89 -Wduplicated-cond -o runme
*/

#include<stdio.h>

#define MSG "Hello world"

int main(void) {
        int a = 0, b;

		if (a == 0) 
			b = 42;
		else if (a == 0)
			b = 43;


        return 0;
}
