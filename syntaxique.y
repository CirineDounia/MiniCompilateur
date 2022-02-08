%{
#include<stdio.h>
#include<string.h>
#include "routine.h"
extern int ligne;
extern int col;
int yyparse();
int yylex();
int yyerror(char *s);
int atoi(const char *str);
double atof( const char * theString ); 
char sauvetype[12];
char typeentre[20];
float sauve;
int k;
int nature;
char type[20];
char sauver[20];
char Stype[30];
char x[20];
int vidf;
float lidf;
%}

%union {
int num;
char* str;
float reel;
struct tp{
          int entier;
          float r;
          char* str;
     }tp;
} 


%token <str>mc_program mc_while mc_endfor and mc_if mc_else mc_endif mc_do mc_for mc_pdec mc_pinst mc_begin mc_end mc_define <str>idf pvg dp <str>mc_pint <str>mc_pfloat barre <num>kint <reel>kfloat <str>op_plus <str>op_moins <str>op_div <str>egale <str>'!' <str>op_fois <str>'<' <str>'>' <str>subEgal <str>infEgal <str>doubleEgal <str>notEgal

%type <str>op
%type <tp>VAR
%type <tp>valeur
%type <str>type
%type <tp>exp_ar
%type <tp>EXPAP

%left barre
%left and
%left '!'
%left '<' '>' subEgal infEgal doubleEgal notEgal
%left op_plus op_moins
%left op_fois op_div

%%
S: deb  dec mc_pinst mc_begin bloc_instructions mc_end {printf("programme syntaxiquement correct"); YYACCEPT;}
;

inst:aff
    |boucle
    |cond
;



bloc_instructions: inst bloc_instructions
                    |inst
;

deb: mc_program idf                                                                 {insert($2,"nom_program",1);
                                                                                       }
;

exp: idf '<'op_moins valeur                                                         {if(doubledeclaration($1)==0) printf("\nErreur semantique: %s non d%clar%c\n",$1,136,136);
                                                                                        if(getnature($1)==1) printf("\nErreur semantique: vous ne pouvez pas modifier la constate %s \n",$1);
                                                                                        strcpy(type,gettype($1));
                                                                                       if(compartype(type,Stype)!=0) printf("\nErreur semantique: incompatibilite de type entre %s et %s \n",$1,x);
                                                                                        insertval($1,x);}
    |idf '<'op_moins exp_ar                                                         {if(doubledeclaration($1)==0) printf("\nErreur semantique: %s non d%cclar%c\n",$1,136,136);
                                                                                         if(getnature($1)==1) printf("\nErrur semantique: vous ne pouvez pas modifier la constate %s \n",$1);}
;

valeur: kint                                                                        { k = $1;
                                                                                        sprintf(x,"%d",$1);
                                                                                        strcpy(Stype,"entier");
                                                                                        }                                                                                                                             
        |kfloat                                                                     { sauve = $1;
                                                                                        sprintf(x,"%f",$1);
                                                                                        strcpy(Stype,"reel");
                                                                                        }                                                                                                                                    
;
aff: exp pvg
;

exp_ar: VAR op exp_ar                                                              {if(strcmp($2,"/")==0 && (sauve == 0 || k == 0 || $3.entier == 0 || $3.r == 0)) printf("\nErreur semantique: division par zero impossible\n");
                                               }                                                                    
        | VAR                                                                       
        | EXPAP 
;
VAR: valeur                                                                         {$$.entier=$1.entier;
                                                                                        $$.r=$1.r;}
    | idf                                                                           {if(doubledeclaration($1)==0) printf("\nErreur semantique: %s non declare\n",$1);
                                                                                        else {if(strcmp(gettype($1),"entier")==0){
                                                                                        $$.entier = atoi(getvaleur($1));}
                                                                                        if(strcmp(gettype($1),"reel")==0){
                                                                                            $$.r = atof(getvaleur($1));
                                                                                            }}}
;
EXPAP:'(' exp_ar ')'                                                                 {$$=$2;}
      | '(' exp_ar ')' op exp_ar                                                    {if(strcmp($4,"/")==0 && (sauve == 0 || k == 0 || $5.entier == 0 || $5.r == 0)) printf("\nErreur semantique: division par zero impossible\n");}
;

op: op_moins  {strcpy($$, $1);}
    |op_plus  {strcpy($$, $1);}
    | op_fois  {strcpy($$, $1);}
    | op_div  {strcpy($$, $1);}
;

dec: mc_pdec liste_dec
;
liste_dec: declar liste_dec 
          |declar
;

declar:dec_var
      |dec_cst
;

dec_var: idf barre  dec_var                                                         { if(doubledeclaration($1)==0){
                                                                                        insert($1,"idf",0);
                                                                                        insertType($1,sauvetype);}
                                                                                        else {printf("\nErreur semantique: double declaration de la variable %s : a la ligne %d \n",$1,ligne);}
                                                                                        }                                                
        |idf dp type pvg                                                            {if(doubledeclaration($1)==0){
                                                                                        insert($1,"idf",0);
                                                                                        strcpy(sauvetype,$3);
                                                                                        insertType($1,$3);
                                                                                        }
                                                                                        else {printf("\nErreur semantique: double declaration de la variable %s : a la ligne %d\n",$1, ligne);}
                                                                                        }
;

type: mc_pint                                                                       {strcpy($$,$1);}                                                               
    | mc_pfloat                                                                     {strcpy($$, $1);}                                                      
;
dec_cst: mc_define type idf egale valeur pvg                                        {if(doubledeclaration($3)==0){
                                                                                            insert($3,"idf",1);
                                                                                            insertType($3,$2);
                                                                                            insertval($3,x);}
                                                                                            else {printf("\nErreur semantique: double declaration de la variable %s \n",$3);}
                                                                                            strcpy(type,gettype($3));
                                                                                       if(compartype(gettype($3),Stype)!=0) printf("\nErreur semantique: incompatibilite de type entre %s et %s \n",$3,x);
                                                                                        }                             
;

boucle: mc_for exp mc_while kint mc_do bloc_instructions  mc_endfor
;

cond: mc_do bloc_instructions dp mc_if  '(' condition ')' bloc_else
;
bloc_else: mc_else bloc_instructions mc_endif
            |mc_endif
;
condition: idf expr_ar valeur                                                       {if(doubledeclaration($1)==0) printf("\nErreur semantique: %s non declare\n",$1);
                                                                                        strcpy(type,gettype($1));
                                                                                        if(compartype(type,Stype)!=0) printf("\nErreur semantique: incompatibilite de type entre %s et %s \n",$1,x);}
                                                                                        
            | idf expr_ar valeur op_log condition                                   {if(doubledeclaration($1)==0) printf("\nErreur semantique: %s non declare\n",$1);
                                                                                        strcpy(type,gettype($1));
                                                                                        if(compartype(type,Stype)!=0) printf("\nErreur semantique: incompatibilite de type entre %s et %s \n",$1,x);}
;
expr_ar:'<'
        | '>' 
        | subEgal
        | infEgal 
        | doubleEgal
        | notEgal
;
op_log: and |  barre
;

%%
int yyerror(char* msg)
{printf("%s ligne %d et colonne %d",msg,ligne,col);
return 0;
}
void inserer(char entite[], char code[], char type[]);
void afficher();
int main()  {    
yyparse(); 
afficher();  
return 0;
} 