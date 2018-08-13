#include<stdio.h>
#include "dec2bin.h"
#include "size.h"

int main(int argc, char **argv) {

/*
        if (argc != 2) {
            printf("Usage: dec2bin decimal_number\n");
            return -1;
        }
*/

	int d;
	char vec[SZ];

        d = argv[0];

	init(vec);
	fill(vec,d);
	reverse(vec);
	echo(vec);

	return 0;
}
