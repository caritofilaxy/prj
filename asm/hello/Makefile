sandbox: sandbox.o
	ld -o sandbox sandbox.o
sandbox.o: sandbox.asm
	nasm -f elf -o sandbox.o sandbox.asm
