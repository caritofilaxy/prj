#include <stream.h>

int a = 1;

void f() {
	int b = 1;
	static int c = a;
	cout << "a = " << a++
		 << "b = " << b++
		 << "c = " << c++ << '\n';
}

int main(void) {
	while(a < 4)
		f();
}
	
