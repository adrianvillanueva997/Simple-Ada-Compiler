#!/bin/bash
flex flex.l
bison -dy bison.y
gcc lex.yy.c y.tab.c -o programa.exe &&
./programa.exe ada.txt > salida.txt
cat data.txt text.txt >mips.txt