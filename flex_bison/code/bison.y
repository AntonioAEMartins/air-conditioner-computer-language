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
%token <sval> IDENTIFIER SET CHANGE GET AUTO IF THEN ELSE END DO OR AND ABOVE BELOW EQUAL PLUS MINUS MULT DIV OPEN_PAREN CLOSE_PAREN ENTITY PARAMETER LAMBDA PRINT

%type <ival> expression term factor
%type <sval> block statement assignment_statement change_statement get_statement auto_statement if_statement print_statement

%%


block: block statement '\n'
    | statement '\n'
    | block statement
    | statement
    ;

lambda_block:
    statement_list
|   LAMBDA
;

statement_list:
    statement_list statement
|   statement
;

statement: 
    assignment_statement
    | change_statement
    | get_statement
    | auto_statement
    | if_statement
    | print_statement
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

assignment_statement: SET IDENTIFIER NUMBER
    {
    }
    ;
    

change_statement: CHANGE IDENTIFIER NUMBER
    {
    }
    ;

get_statement: GET IDENTIFIER
    {
        printf("Get\n");
    }

auto_statement: AUTO bool_expression DO lambda_block END
    {
    }
    ;

if_statement: IF bool_expression THEN lambda_block END
    {
    }

print_statement: PRINT IDENTIFIER
    {
        printf("Print\n");
    }

bool_expression:
    bool_expression OR bool_term
    | bool_term;

bool_term:
    bool_term AND relation_expression
    | relation_expression;

relation_expression:
    expression ABOVE expression
    | expression BELOW expression
    | expression EQUAL expression;


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