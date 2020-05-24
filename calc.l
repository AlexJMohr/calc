%{
#include "calc.tab.h"
void yyerror(char *s);
int yylex();
%}

%%

"print"     {return PRINT;}
"exit"      {return EXIT;}
[a-zA-Z]    {yylval.id = yytext[0]; return IDENTIFIER;}
[1-9][0-9]* {yylval.num = atoi(yytext); return NUM;}
[ \t\r\n]+  ;
[-+=;]      {return yytext[0];}
.           {ECHO; yyerror("Unexpected character");}

%%

int yywrap(void)
{
    return 1;
}

