#include<stdio.h> 
#include<stdlib.h> 

int gcd(int, int);

int main(int argc, char *argv[]) {

	if (argc != 3) {
		printf("gcd int int\n");
		return -1;
	}

	

	int d1, d2;
	d1=atoi(argv[1]); 
	d2=atoi(argv[2]);
	printf("GDC of %i and %i is %i\n", d1, d2, gcd(d1,d2));

}

//int gcd(int v1, int v2) {
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
int gcd(int v1, int v2) {
	
	if (v2 != 0) 
		return gcd(v2, v1%v2);
	else
		return v1;
}

