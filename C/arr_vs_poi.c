#include <stdio.h>
 void func(char subarray[100],char* pointer)
 {
       printf("sizeof subarray=%zd\n", sizeof(subarray));
       printf("address of subarray=%p\n", (void *)subarray);
       printf("pointer            =%p\n", (void *)pointer);
 }
 int main()
 {
       char array[100];
       printf("sizeof of array=%zd\n", sizeof(array));
       printf("address of array=%p\n", (void *)array);
       printf("address of array[0]=%p\n", (void *)&array[0]);
       func(array,array);
 }
        
