%{
#include <stdio.h>
#include<string.h>
#include "syntaxique.tab.h"
int ligne=1;
int col=0;
extern YYSTYPE yylval;

%}
%option noyywrap
lettre [a-zA-Z]
chiffre [0-9]
kint [+-]?{chiffre}+
kfloat {kint}.{chiffre}+
idf {lettre}({lettre}|{chiffre}|_)*({lettre}|{chiffre})*
comparison_expression >|<|==|>=|<=|!=
cdl \/\/
cdpl \/\*
cf \*\/
text ({chiffre}|{lettre}|[ \t])*
commentl {cdl}{text}
commentpl {cdpl}({text}([\n])?)*{cf}

%%
Program {col=col+yyleng; return mc_program; }
PDEC {col=col+yyleng; return mc_pdec; }
PINST {col=col+yyleng; return mc_pinst; }
ENDIF {col=col+yyleng; return mc_endif; }
Begin {col=col+yyleng; return mc_begin; }
End {col=col+yyleng; return mc_end; }
@define {col=col+yyleng; return mc_define; }
FOR {col=col+yyleng; return mc_for; }
WHILE {col=col+yyleng; return mc_while; }
DO { col=col+yyleng; return mc_do;}
ENDFOR { col=col+yyleng; return mc_endfor;}
ELSE {col=col+yyleng; return mc_else; }
Pint {yylval.str=strdup("entier"); col=col+yyleng; return mc_pint;}
Pfloat {yylval.str=strdup("reel"); col=col+yyleng; return mc_pfloat;}
IF {col=col+yyleng; return mc_if; }
& { col=col+yyleng; return and;}
; {col=col+yyleng; return pvg;}
: { col=col+yyleng; return dp;}
\| {col=col+yyleng; return barre; }
= {col=col+yyleng; return egale; }
"+" {yylval.str=strdup(yytext); col=col+yyleng; return op_plus;}
"-" {yylval.str=strdup(yytext); col=col+yyleng; return op_moins;}
"/" {yylval.str=strdup(yytext); col=col+yyleng; return op_div;}
"*" {yylval.str=strdup(yytext); col=col+yyleng; return op_fois;}
[\(\)] {col=col+yyleng; return yytext[0];}
{idf} {if(yyleng<=12){ yylval.str=strdup(yytext); 
						  col=col+yyleng;
						   return idf;}
    else printf("erreur lexical: ligne %d et colonne %d: IDF trop long ",ligne,col);
}
{commentl} {col=col+yyleng;}
{commentpl} {col=col+yyleng;}
{comparison_expression} {
	col = col + yyleng;
	if(strcmp(yytext,">")==0)
		return '>';
	else if(strcmp(yytext,"<")==0)
			return '<';
		else if(strcmp(yytext,"<=")==0)
				return infEgal;
			else if(strcmp(yytext,">=")==0)
					return subEgal;
				else if(strcmp(yytext,"==")==0)
						return doubleEgal;
					else if(strcmp(yytext,"!=")==0)
							return notEgal;
}
{kint} {if((atoi(yytext)<= 32767) && (atoi(yytext)>= -32768) ){yylval.num=atoi(yytext); col=col+yyleng; return kint;}
		else printf("entier trop long");}
{kfloat} {yylval.reel=atof(yytext); col=col+yyleng; return kfloat;}
[ \t] {col=col++;}
\n {ligne++;col=0;}
. {printf("Erreur lexical sur la ligne %d et la colonne %d\n", ligne, col);}

%%
