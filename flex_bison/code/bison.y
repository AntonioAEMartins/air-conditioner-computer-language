%{
#include <stdio.h>
#include <stdlib.h>
#include "bison.tab.h"

void yyerror(const char *s);
extern int yylex();
%}

%union {
    int ival;
    char *sval;
}

%token <ival> NUMBER
%token <sval> IDENTIFIER
%token SET SHOW CHECK AUTO IF THEN ELSE DONE DO OR AND ABOVE BELOW EQUAL PLUS MINUS MULT DIV OPEN_PAREN CLOSE_PAREN INIT NOT

%type <sval> block statement statement_list
%type <ival> bool_expression bool_term relation_expression expression term factor

%%

block:
    statement_list
    ;

statement_list:
    statement_list statement '\n'
    | statement '\n'
    ;

statement: 
    IDENTIFIER '=' bool_expression { printf("Assignment\n"); }
    | SET IDENTIFIER { printf("Set without assignment\n"); }
    | SET IDENTIFIER '=' bool_expression { printf("Set with assignment\n"); }
    | SHOW OPEN_PAREN bool_expression CLOSE_PAREN { printf("Show\n"); }
    | CHECK bool_expression IF '\n' statement_list DONE { printf("Check If\n"); }
    | CHECK bool_expression IF '\n' statement_list ELSE '\n' statement_list DONE { printf("Check If Else\n"); }
    | AUTO bool_expression DO '\n' statement_list DONE { printf("Auto\n"); }
    | INIT IDENTIFIER OPEN_PAREN IDENTIFIER ',' IDENTIFIER ',' IDENTIFIER CLOSE_PAREN { printf("Init\n"); }
    ;

bool_expression:
    bool_term { printf("Bool Expression\n");}
    | bool_expression OR bool_term { printf("Or\n"); }
    ;

bool_term:
    relation_expression { printf("Bool Term\n"); }
    | bool_term AND relation_expression { printf("And\n"); }
    ;

relation_expression:
    expression { printf("Relation Expression\n"); }
    | expression ABOVE expression { printf("Above\n"); }
    | expression BELOW expression { printf("Below\n"); }
    | expression EQUAL expression { printf("Equal\n"); }
    ;

expression:
    term { printf("Expression\n"); }
    | expression PLUS term { printf("Add\n"); }
    | expression MINUS term { printf("Subtract\n"); }
    ;

term:
    factor { printf("Term\n"); }
    | term MULT factor { printf("Multiply\n"); }
    | term DIV factor { printf("Divide\n"); }
    ;

factor:
    NUMBER { printf("Number\n"); }
    | IDENTIFIER { printf("Identifier\n"); }
    | PLUS factor { printf("Positive\n"); }
    | MINUS factor { printf("Negative\n"); }
    | NOT factor { printf("Not\n"); }
    | OPEN_PAREN bool_expression CLOSE_PAREN { printf("Nested Expression\n"); }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro: %s\n", s);
}

int main() {
    printf("Digite o programa:\n");
    if (yyparse() == 0) {
        printf("Análise concluída com sucesso.\n");
    } else {
        printf("Análise falhou.\n");
    }
    return 0;
}
