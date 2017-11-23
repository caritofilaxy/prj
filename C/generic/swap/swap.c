#include<string.h>

void swap(void *vp1, void *vp2, int bsize) {
    char buffer[bsize];
    memcpy(buffer,vp1, bsize);
    memcpy(vp1, vp2, bsize);
    memcpy(vp2, buffer, bsize);
}
