flex lexique.l
bison -d syntaxique.y
gcc lex.yy.c syntaxique.tab.c -o projet.exe