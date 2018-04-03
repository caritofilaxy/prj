/* Cipher block chaining 
plaintext 'hello'     
initialization vector (iv) 'J' (0x4a hex);

first char xored with iv
next xored with previous and so on

checkout results with ./a.out | hexdump -C
*/

#include<stdio.h>

int main(void) {

    char c1,c2,c3,c4,c5;
    char k = '\x4a';

    /* calculating c1 = 'h' ^ 0x4a = 0x68 ^ 0x4a = 01101000 ^ 01001010 = 00100010 = 0x22  */
    c1 = 'h' ^ k; /* c1 = 0x22                 01001010 */

    /* calculating c2 = 'e' ^ 0x22 = 0x65 ^ 0x22 = 01100101 ^ 00100010 = 01000111 = 0x47 */
    c2 = 'e' ^ c1; /* c2 = 0x47                   00100010 */

    /* calculating c3 = 'l' ^ 0x47 = 0x6c ^ 0x47 = 01101100 ^ 01000111 = 00101011 = 0x2b */
    c3 = 'l' ^ c2; /* c3 = 0x2b                   01000111 */ 

    /* calculating c4 = 'l' ^ 0x2b = 0x6c ^ 0x2b = 01101100 ^ 00101011 = 01000111 = 0x47 */
    c4 = 'l' ^ c3; /* c4 = 0x47                   00101011 */

    /* calculating c5 = 'o' ^ 0x47 = 0x6f ^ 0x47 = 01101111 ^ 01000111 = 00101000 = 0x28 */
    c5 = 'o' ^ c4; /* c5 = 0x28                   01000111 */

    printf("%c%c%c%c%c", c1,c2,c3,c4,c5);

    return 0;
}

/* decrypt

    d1 = c1 ^ k  = 00100010 ^ 01001010 = 01101000 = \x68 = 'h'
    d2 = c2 ^ c1 = 01000111 ^ 00100010 = 01100101 = \x65 = 'e'
    d3 = c3 ^ c2 = 00101011 ^ 01000111 = 01101100 = \x6c = 'l'
    d4 = c4 ^ c3 = 01000111 ^ 00101011 = 01101100 = \x6c = 'l'
    d5 = c5 ^ c4 = 00101000 ^ 01000111 = 01101111 = \x6f = 'o'

*/
