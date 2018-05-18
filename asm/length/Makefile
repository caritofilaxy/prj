NAME := length_in_place
SRC := $(NAME).s
OBJ := $(NAME).o

.PHONY: make
make:	as ld

.PHONY: debug
debug:	as_d ld

.PHONY: as
as:
	as $(SRC) -o $(OBJ)

.PHONY: as_d
as_d:
	as $(SRC) -g -o $(OBJ)


.PHONY: ld 
ld:
	ld $(OBJ) -o $(NAME)

.PHONY: clean 
clean:
	rm -f $(OBJ) $(NAME)
