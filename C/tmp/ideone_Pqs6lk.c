#include <stdio.h>

int main(void) {
    double x=0, y=0;
    int check;
    
    do{
        printf("\nL\x84 \bge eines Rechtecks: ");
        check = scanf("%lf",&x);
        fflush(stdin);
        if(check == 0){
            printf("Test!");
        }else if(x <= 0){
            printf("Eingabe nicht negativ oder Null!\n");
        }
    }while(x <= 0);

	return 0;
}
