#include<stdio.h>

void assign(char *v, int i) {
	if (i > 63)
		*v = i&~63;

	*v = i;
}

int main(void) {
		char v, *v_ptr;
		v_ptr = &v;
		assign(v_ptr, 65);
        return v;
}
