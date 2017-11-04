#include<stdio.h>
#include<stdlib.h>

struct fraction {
	int num;
	int denum;
};

int main(void) {
/*
		char c = 'f';
		printf("stack addr: %p\n", &c);

		char *p = malloc(1);
		printf("heap addr: %p\n", p);

		printf("main addr: %p\n", &main);
*/

/*
 *
 *
 *							    ---------					^
 *							   |    33   |					| memory higher addresses
 *	 non allocated space --->   ---------					|
 *	  		   			       | 7 -> 12 |	int (4 bytes) 	|
 *	 pi.denum -------------->   ---------					|
 *	  		   				   |    22   |	int (4 bytes)	|
 *	 pi.num ---------------->   ---------					| memory lower addresses
 *
 *
 *
 *
 *
 *
 *
 *
		struct fraction pi;
		pi.num = 22;
		pi.denum = 7;

		((struct fraction *)&(pi.denum))->num = 12;
		((struct fraction *)&(pi.num))->num = 33;

		printf("%i\n", pi.denum);
		

		return 0;
}
