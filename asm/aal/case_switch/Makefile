NAME := case_switch
SOURCE := $(NAME).s
OBJFILE := $(NAME).o

.PHONY: make
make: as ld

.PHONY: debug
debug: as_d ld

.PHONY: as
as:
	as -o $(OBJFILE) $(SOURCE)

.PHONY: as_d
as_d:
	as -gstabs -o $(OBJFILE) $(SOURCE)

.PHONY: ld
ld:
	ld -o $(NAME) $(OBJFILE)

.PHONY: clean
clean:
	rm -f $(OBJFILE) $(NAME)
