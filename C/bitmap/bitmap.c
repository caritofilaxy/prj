#include<stdio.h>

int find_first_set(unsigned bitmap, unsigned start) {
	unsigned mask = (1 << start);

	while (mask) {
		if (bitmap & mask) return start;
		++start;
		mask <<= 1;
	}

	return -1;
}

int find_first_clr(unsigned bitmap, unsigned start) {
	return find_first_set(~bitmap, start);
}

unsigned setbit(unsigned bitmap, unsigned position) {
	return bitmap | (1 << position);
}

unsigned clrbit(unsigned bitmap, unsigned position) {
	return bitmap & ~(1 << position);
}

int main(void) {
	unsigned m = 0xf000;
	unsigned s = 0x2;
	
	printf("%d\n", find_first_set(m, s));

	m = 0x0fff;
	printf("%d\n", find_first_clr(m, s));

	printf("%x\n", setbit(m, 13));
	printf("%x\n", clrbit(m, 8));

	return 0;
}
