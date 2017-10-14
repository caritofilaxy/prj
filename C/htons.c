#include<arpa/inet.h>

int main(void) {
	uint i, a, b;
	i=0xABCD;
	htonl(i);
	a=i;

	return 0;
}
