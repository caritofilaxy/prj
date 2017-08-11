#include<stdio.h> 
#include<stdlib.h> 

typedef unsigned long goo;
//typedef int goo;

goo gcd(goo, goo);

int main(int argc, char *argv[]) {

	if (argc != 3) {
		printf("gcd int int\n");
		return -1;
	}

	

	goo d1, d2;
	d1=atoi(argv[1]); 
	d2=atoi(argv[2]);
	printf("GDC of %lu and %lu is %lu\n", d1, d2, gcd(d1,d2));

}

//int gcd(goo v1, goo v2) {
//
//	int r = v1 % v2;
//	while (r != 0) {
//		v1 = v2;
//		v2 = r;
//		r = v1 % v2;
//	}
//	return v2;
//}

// recursion
goo gcd(goo v1, goo v2) {
	
	if (v2 != 0) 
		return gcd(v2, v1%v2);
	else
		return v1;
}

