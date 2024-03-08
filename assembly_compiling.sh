#!bin/bash

gcc -m32  -c $1.c -o $1.o
nasm -f elf32 $2.s -o $2.o
gcc -m32 $1.o $2.o -o $2
./$2

rm $2
