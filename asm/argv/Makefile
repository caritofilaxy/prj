.PHONY: make
make: as ld

.PHONY: as
as:
	as argv.s -o argv.o

.PHONY: ld
ld:
	ld argv.o -o argv

.PHONY: debug
debug:
	as argv.s -g -o argv.o
