#include<errno.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int main(int argc, char **argv) {

    char *target;

    if (argc == 1)
        target = strdup("/boot/vmlinuz-3.16.0-4-686-pae");
    else if (argc == 2)
        target = strdup(argv[1]);
    else {
      fprintf(stderr, "Usage: runme {opt_file}\n");
      exit(EXIT_FAILURE);
    }

    FILE *f;

    f = fopen(target, "w");
    if (f == NULL) {
        fprintf(stderr, "Cant open %s for writing: %s\n", 
                                    target, strerror(errno));
        exit(EXIT_FAILURE);
    } else {
        printf("Fuck me!!! I can write directly to %s!!!\n", target);
    }

    return 0;
}
        
