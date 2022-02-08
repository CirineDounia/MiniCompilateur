#include <stdio.h>
#include <string.h>
/****************CREATION DE LA TABLE DES SYMBOLES ******************/
/*** Definition des structures de données ***/

typedef struct
{
    char nom[12];
    char type[12];
    char code[12];
    char valeur[20];
    int nature;
} TS;

TS TableS[100] = {};
TS Tablesm[100] = {};
int cmpt = 0;

/*** La fonction Rechercher permet de verifier  si l'entité existe dèja dans la table des symboles */
int rechercher(char entite[])
{
    int i = 0;
    while (i < cmpt)
    {
        if (strcmp(entite, TableS[i].nom) == 0)
            return i;
        i++;
    }
    return -1;
}

/*** insertion des entititées lexicales dans les tables des symboles ***/
void insert(char nom[12], char code[20], int nature)
{
    if (rechercher(nom) == -1)
    {
        strcpy(TableS[cmpt].nom, nom);
        strcpy(TableS[cmpt].code, code);
        TableS[cmpt].nature = nature;
        cmpt++;
    }
}

/*** la fonction insertType permet d'ajouter un type aux entités de la table ***/
void insertType(char entite[12], char type[12])
{
    int i = rechercher(entite);
    if (i != -1)
    {
        strcpy(TableS[i].type, type);
    }
}

/*** la fonction insertvype permet d'ajouter une valeur aux entités de la table ***/
void insertval(char entite[12], char val[20])
{
    int i = rechercher(entite);
    if (i != -1)
    {
        strcpy(TableS[i].valeur, val);
    }
}

/*** la fonction doubledeclaration permet de verifier si une entité existe déja dans la table ***/
int doubledeclaration(char entite[12])
{
    // int i = rechercher(entite);
    if (rechercher(entite) == -1)
        return 0;
    else
        return -1;
}

/*** la fonction getnature permet de recuperer la nature d'une entité ***/
int getnature(char entite[12])
{
    int pos = rechercher(entite);
    return TableS[pos].nature;
}

/*** la fonction getnature permet de recuperer le type d'une entité ***/
char *gettype(char entite[12])
{
    int pos = rechercher(entite);
    return TableS[pos].type;
}
/*** la fonction getvaleur permet de recuperer la valeur d'une entité ***/

char *getvaleur(char entite[])
{
    int pos = rechercher(entite);
    return TableS[pos].valeur;
}

/*** On a pas utilisé cette fonction car elle donne le même résultat que la fonction rechercher ***/
/*int nondeclarer(char entite[12])
{
    return rechercher(entite);
}*/

/*** la fonction compartype permet de comparer le type de deux entité ***/
int compartype(char e1[20], char e2[20])
{
    if (strcmp(e1, e2) != 0)
        return -1;
    return 0;
}

/*** L'affichage du contenue de la table des symboles ***/
void afficher()
{
    printf("\n\t *********** Tables de Symboles ********** \t\t\n");
    printf("\n+--------------------------------------------------------------------------------+\n");
    printf("|\tNom\t |\tNature\t |\tCode\t |\tType\t |\tValeur\t |\n");
    printf("+--------------------------------------------------------------------------------+\n");
    int i = 0;
    while (i < cmpt)
    {
        printf("| %12s\t | %12i\t | %12s\t | %12s\t | %12s\t |\n", TableS[i].nom, TableS[i].nature, TableS[i].code, TableS[i].type, TableS[i].valeur);
        i++;
    }
    printf("+--------------------------------------------------------------------------------+\n");
}
