#include<stdio.h>
#include<stdlib.h>
#include<error.h>

char *encrypt(char *s, char k) {

        char *t;

        int c = 0;
        int d = 0;

        while (*(s+c) != '\0') {
            c++;
        }

        t = malloc(c);

        *(t+d) = *(s+d) ^ k;
        d++;
        while (d < c) {
          *(t+d) = *(s+d) ^ *(t+d-1);
          d++;
        }

        *(t+d+1) = '\0';

        return t;
}

char *decrypt(char *s, char k) {

        char *t;
        int c = 0;
        int d = 0;

        while (*(s+c) != '\0') {
            c++;
        }

        t = malloc(c);

        *(s+d) = *(s+d) ^ k;
        d++;
        while (d < c) {
          *(t+d) = *(s+d) ^ *(s+d-1);
          d++;
        }

        *(t+d+1) = '\0';

        return t;
}


void usage(void) {
	printf("\tencrypt: cbc4e -e file\n");
	printf("\tdecrypt: cbc4e -d file\n");
}




int main(int argc, char **argv) {

	int errno = 0;
	FILE *fp;

	if (argc != 3) {
		fprintf(stderr, "Bad arguments quantity. want %i, you give %i\n", 2, argc);
		return 1;
	}

	if (argv[1][1] != 'd' && argv[1][1] != 'e') {
		fprintf(stderr, "Bad key. -e or -d allowed\n");
		return 2;
	}

	
	fp = fopen(argv[2], "r") ;

	if (fp == NULL) {
		fprintf(stderr, "toasty: %s\n", strerror(errno));
		return 3;
	} else {
		fclose(fp);
	}
	
	return 0;
}
