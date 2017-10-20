#include <stdio.h>

#define DEBUG 4

#ifdef DEBUG
  #if DEBUG >= 1
   #define dprintf1(s, ...) fprintf(stderr, s, __VA_ARGS__)
  #else
   #define dprintf1(...)
  #endif

  #if DEBUG >= 2
   #define dprintf2(s, ...) fprintf(stderr, s, __VA_ARGS__)
  #else
   #define dprintf2(...)
  #endif

  #if DEBUG >= 3
   #define dprintf3(s, ...) fprintf(stderr, s, __VA_ARGS__)
  #else
   #define dprintf3(...)
  #endif
#else
  #define dprintf1(...)
  #define dprintf2(...)
  #define dprintf3(...)
#endif

int main(int argc, char **argv) {
    int flag = 42;

    dprintf2("flag: %d\n", flag);

    return 0;
}
 
