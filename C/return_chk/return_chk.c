int sum(int *,int *);

int main(void) {
		
		int m=2, n=3, l;

		l = sum(&m,&n);

		l += 2;	

        return 0;
}

int sum(int *k, int *l) {
	return (*k)*(*l);
}
