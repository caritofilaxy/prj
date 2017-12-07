void *lsearch(void *base, void *p, int size) {
    
    int i, count = 0;
    int *ip;
    
    ip = base;

    *ip != *p ? ip += size : while (*ip++ == *p++ && count < size) {
