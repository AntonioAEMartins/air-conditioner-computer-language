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
%token <sval> IDENTIFIER SET CHANGE GET AUTO IF THEN ELSE END DO OR AND ABOVE BELOW EQUAL PLUS MINUS MULT DIV OPEN_PAREN CLOSE_PAREN

%type <ival> expression term factor
%type <sval> program statement set_statement change_statement get_statement auto_statement if_statement do_statement

%%

program: statement
    | program statement
    ;

statement: set_statement
    | change_statement
    | get_statement
    | auto_statement
    | if_statement
    | do_statement
    ;

expression:
    term
    | expression PLUS term { printf("Add\n"); }
    | expression MINUS term { printf("Subtract\n"); }
    ;

term:
    factor
    | term MULT factor { printf("Multiply\n"); }
    | term DIV factor { printf("Divide\n"); }
    ;

factor:
    NUMBER
    | IDENTIFIER
    | OPEN_PAREN expression CLOSE_PAREN { printf("Nested Expression\n"); }
    ;

set_statement: SET IDENTIFIER NUMBER END
    {
        printf("SET %s %d\n", $2, $3);
    }
    ;

change_statement: CHANGE IDENTIFIER NUMBER END
    {
        printf("CHANGE %s %d\n", $2, $3);
    }

get_statement: GET IDENTIFIER END
    {
        printf("GET %s\n", $2);
    }

auto_statement: AUTO IDENTIFIER IF IDENTIFIER THEN NUMBER ELSE NUMBER END
    {
        printf("AUTO %s IF %s THEN %d ELSE %d\n", $2, $4, $6, $8);
    }

if_statement: IF IDENTIFIER THEN NUMBER ELSE NUMBER END
    {
        printf("IF %s THEN %d ELSE %d\n", $2, $4, $6);
    }

do_statement: DO IDENTIFIER OR IDENTIFIER AND IDENTIFIER ABOVE NUMBER BELOW NUMBER END
    {
        printf("DO %s OR %s AND %s ABOVE %d BELOW %d\n", $2, $4, $6, $8, $10);
    }

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