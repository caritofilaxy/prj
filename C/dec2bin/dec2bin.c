#include "dec2bin.h"
#include "size.h"

int main(void) {
/*	int d = 42; */
	int d = -65;
	char vec[SZ];

	init(vec);
	fill(vec,d);
	reverse(vec);
	echo(vec);

	return 0;
}
