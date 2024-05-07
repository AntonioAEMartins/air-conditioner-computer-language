%{
#include "bison.tab.h"
%}

%%


[ \t]+                      ;  // Ignora espaços em branco, tabulações e quebras de linha
"\n"                         { return '\n'; }

[0-9]+                       {
    yylval.ival = atoi(yytext);   // Converte a string numérica para int e armazena em yylval
    return NUMBER;
}
[a-zA-Z_][a-zA-Z0-9_]*       {
    // Verifica palavras-chave e retorna os tokens apropriados
    if(strcmp(yytext, "SET") == 0) return SET;
    if(strcmp(yytext, "CHANGE") == 0) return CHANGE;
    if(strcmp(yytext, "GET") == 0) return GET;
    if(strcmp(yytext, "AUTO") == 0) return AUTO;
    if(strcmp(yytext, "IF") == 0) return IF;
    if(strcmp(yytext, "THEN") == 0) return THEN;
    if(strcmp(yytext, "ELSE") == 0) return ELSE;
    if(strcmp(yytext, "END") == 0) return END;
    if(strcmp(yytext, "DO") == 0) return DO;
    if(strcmp(yytext, "OR") == 0) return OR;
    if(strcmp(yytext, "AND") == 0) return AND;
    if(strcmp(yytext, "ABOVE") == 0) return ABOVE;
    if(strcmp(yytext, "BELOW") == 0) return BELOW;
    if(strcmp(yytext, "EQUAL") == 0) return EQUAL;
    // Se não for uma palavra-chave, trata como identificador
    yylval.sval = strdup(yytext); // Aloca memória e copia a string para yylval
    return IDENTIFIER;
}

"("                          { return '('; }
")"                          { return ')'; }
"+"                          { return '+'; }
"-"                          { return '-'; }
"*"                          { return '*'; }
"/"                          { return '/'; }


%%
