char case_switch(char c) {
	char m = 0x20;
	(c | m) == c ? (c &= ~m) : (c |= m);
	return c;
}
