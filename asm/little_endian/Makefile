NAME := sandbox
SOURCE := $(NAME).asm
OBJFILE := $(NAME).o

.PHONY: make
make: as ld

.PHONY: debug
debug: as_d ld

.PHONY: as
as:
	nasm -f elf -o $(OBJFILE) $(SOURCE)

.PHONY: as_d
as_d:
	nasm -f elf -g -F stabs $(SOURCE)

.PHONY: ld
ld:
	ld -o $(NAME) $(OBJFILE)

.PHONY: clean
clean:
	rm -f $(OBJFILE) $(NAME)
