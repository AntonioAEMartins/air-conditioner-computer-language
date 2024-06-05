%{
#include "bison.tab.h"
#include <string.h>
%}

%%

[ \t]+                      ;  // Ignora espaços em branco e tabulações
"\n"                         { printf("Token: NEWLINE\n"); return '\n'; }

[0-9]+                       {
    yylval.ival = atoi(yytext);   // Converte a string numérica para int e armazena em yylval
    printf("Token: NUMBER, Value: %d\n", yylval.ival);
    return NUMBER;
}
[a-zA-Z_][a-zA-Z0-9_]*       {
    // Verifica palavras-chave e retorna os tokens apropriados
    // printf("Token: IDENTIFIER/PALAVRA-CHAVE, Text: %s\n", yytext);
    if(strcmp(yytext, "set") == 0) { printf("Token: SET\n"); return SET; }
    if(strcmp(yytext, "show") == 0) { printf("Token: SHOW\n"); return SHOW; }
    if(strcmp(yytext, "check") == 0) { printf("Token: CHECK\n"); return CHECK; }
    if(strcmp(yytext, "auto") == 0) { printf("Token: AUTO\n"); return AUTO; }
    if(strcmp(yytext, "if") == 0) { printf("Token: IF\n"); return IF; }
    if(strcmp(yytext, "else") == 0) { printf("Token: ELSE\n"); return ELSE; }
    if(strcmp(yytext, "done") == 0) { printf("Token: DONE\n"); return DONE; }
    if(strcmp(yytext, "do") == 0) { printf("Token: DO\n"); return DO; }
    if(strcmp(yytext, "or") == 0) { printf("Token: OR\n"); return OR; }
    if(strcmp(yytext, "and") == 0) { printf("Token: AND\n"); return AND; }
    if(strcmp(yytext, "above") == 0) { printf("Token: ABOVE\n"); return ABOVE; }
    if(strcmp(yytext, "below") == 0) { printf("Token: BELOW\n"); return BELOW; }
    if(strcmp(yytext, "equal") == 0) { printf("Token: EQUAL\n"); return EQUAL; }
    if(strcmp(yytext, "not") == 0) { printf("Token: NOT\n"); return NOT; }
    if(strcmp(yytext, "init") == 0) { printf("Token: INIT\n"); return INIT; }
    // Se não for uma palavra-chave, trata como identificador
    yylval.sval = strdup(yytext); // Aloca memória e copia a string para yylval
    printf("Token: IDENTIFIER, Value: %s\n", yylval.sval);
    return IDENTIFIER;
}

"("                          { printf("Token: OPEN_PAREN\n"); return OPEN_PAREN; }
")"                          { printf("Token: CLOSE_PAREN\n"); return CLOSE_PAREN; }
"+"                          { printf("Token: PLUS\n"); return PLUS; }
"-"                          { printf("Token: MINUS\n"); return MINUS; }
"*"                          { printf("Token: MULT\n"); return MULT; }
"/"                          { printf("Token: DIV\n"); return DIV; }
"="                          { printf("Token: EQUALS\n"); return '='; }
","                          { printf("Token: COMMA\n"); return ','; }


%%

int yywrap() {
    return 1;
}
