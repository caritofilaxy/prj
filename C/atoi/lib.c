int myatoi(char *p) {
	
	int r, mask;
	r = 0;
	mask = 0x30;

	while (*(p+1) != 0) {
		r += *p & ~mask;
		r *= 10;
		*p++;
	}

	r += *p & ~mask;

	return r;
}
