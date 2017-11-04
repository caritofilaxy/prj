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
 */

/*		int val; */
		struct fraction pi;
		pi.num = 22;
		pi.denum = 7;

		((struct fraction *)&(pi.denum))->num = 12;
		((struct fraction *)&(pi.denum))->denum = 33;

		printf("%i\n", pi.denum);



		
		printf("%i\n", (&pi)[1].num); /*  we can look at it as array of blocks with size equal to 
										 struct fraction. this is 2nd block and num is 1st value */
		
		(&pi.num)[2] = 44;

		printf("%i\n", (&pi)[1].num); 
		

/* 		val = ((struct fraction *)(&pi.denum))[0].denum;
 *		printf("should be 33: %i\n", val);
 */

		return 0;
}
