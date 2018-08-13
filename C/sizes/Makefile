NAME := sizes
SOURCE := $(NAME).c
OBJFILE := $(NAME).o

make:
	#gcc -Wall -Wextra -std=c89 -ansi -pedantic -o $(NAME) $(SOURCE)
	gcc -Wall -Wextra -Werror -o $(NAME) $(SOURCE)

clang:
	clang -o $(NAME) $(SOURCE)

debug:
	gcc -g -o $(NAME) $(SOURCE)

