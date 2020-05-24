%{
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex(void);

int syms[52] = {0};
int symVal(char sym);
void putSym(char sym, int val);
%}

%union {int num; char id;}
%start commands
%token PRINT EXIT
%token <num> NUM
%token <id> IDENTIFIER
%type <num> line exp term
%type <id> assignment

%%

commands
    : commands line
    | %empty
    ;

line
    : assignment ';'    {;}
    | EXIT ';'          {exit(EXIT_SUCCESS);}
    | PRINT exp ';'     {printf("%d\n", $2);}
    ;

assignment
    : IDENTIFIER '=' exp {putSym($1, $3);}
    ;

exp : term          {$$ = $1;}
    | exp '+' term  {$$ = $1 + $3;}
    | exp '-' term  {$$ = $1 - $3;}
    ;

term: NUM           {$$ = $1;}
    | IDENTIFIER    {$$ = symVal($1);}
    ;

%%

int symIdx(char sym)
{
    if (islower(sym))
        return sym - 'a' + 26;
    if (isupper(sym))
        return sym - 'A';
    return -1;
} 

int symVal(char sym)
{
    return syms[symIdx(sym)];
}

void putSym(char sym, int val)
{
    syms[symIdx(sym)] = val;
}

void yyerror(const char *s)
{
    fprintf(stderr, "%s\n", s);
}

int main(void)
{
    return yyparse();
}

