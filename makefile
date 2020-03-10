all: main

main: main.o functions.o
	ld -melf_i386 -o main main.o ./functions.o

main.o: main.asm functions.inc
	nasm -g -f elf32 -F dwarf main.asm -l main.lst

clean:
	rm -f ./main.o || true
	rm -f ./main.lst || true
	rm -f ./main || true
