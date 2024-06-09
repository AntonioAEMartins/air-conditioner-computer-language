# Linguagem de Programação - Ar Condicionado

## Descrição

Após a presentação deste projeto na matéria de Lógica da Computação, minitrada pelo professo Raul Ikeda, dei início a um processo de análise buscando itens de uso diário que poderiam ser transformados em uma linguagem, mesmo que de maneira simples. Investiguei geladeiras, televisões, computadores... até chegar ao controle de ar condicionado.

A ideia é criar uma linguagem de programação que permita construir e/ou simular o funcionamento de um controle de ar condicionado, para isso, está linguagem conta com:

1. Definição de variáveis
2. Operações matemáticas
3. Operações lógicas
4. Estruturas de controle, a partir da criação de classes
5. Estruturas de repetição, a partir da criação de While loops

Abaixo está a EBNF da linguagem, que será utilizada para a construção do analisador léxico e sintático, como também seu diagrama sintático.

```
BLOCK = { STATEMENT } ;

BOOL_EXP = BOOL_TERM, { ("or"), BOOL_TERM } ;

BOOL_TERM = REL_EXP, { ("and"), REL_EXP } ;

REL_EXP = EXPRESSION, { ("below" | "above" | "equal" ) , EXPRESSION,  };

EXPRESSION = TERM, { ("+" | "-" ), TERM } ;

TERM = FACTOR, { ("*" | "/"), FACTOR } ;

STATEMENT = 
    (IDENTIFIER, "=", BOOL_EXP
    | "set", IDENTIFIER, ( | ("=", BOOL_EXP))
    | "show", "(", BOOL_EXP, ")"
    | "check", BOOL_EXP, "if", "\n", { ( STATEMENT ) }, [ "else", "\n", { ( STATEMENT ) } ], "done"
    | "auto", BOOL_EXP, "do", "\n", { ( STATEMENT ) }, "done"
    | "init",IDENTIFIER, "(", IDENTIFIER, ",", IDENTIFIER, ",", IDENTIFIER, ")"), "\n" ;

FACTOR = NUMBER  
    | IDENTIFIER,
    | ("+" | "-" | "not"), FACTOR 
    | "(", BOOL_EXP, ")" ;

IDENTIFIER = LETTER, { LETTER | DIGIT | "_" };
NUMBER = DIGIT, { DIGIT };
LETTER = ( "a" | "..." | "z" | "A" | "..." | "Z" );
DIGIT = ( "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" | "0" );
```

![Diagrama Sintático](./imgs/diagrama-sintatico.png)

## Flex e Bison

O primeiro passo do projeto foi a criação do analisador léxico e sintático, utilizando Flex e Bison, mesmo que ambas etapas/ferramentas não fossem utilizadas posteriormente, uma vez que foi utilizado para compilar esta linguagem `.air`, uma versão modificada do compilador desenvolvido ao decorrer da matéria.

Para a construção do Flex, foi preciso imaginar como a etapa de tokenização, etapa léxica, seria feita, principalmente quais os tokens necessários, com base na EBNF. O arquivo `lex.l` no diretório `flex_bison/code` foi criado com base nessa análise.

```flex
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

```

O arquivo `bison.y` foi criado para a etapa sintática, onde a gramática foi definida e as regras de produção foram implementadas.

```bison
...

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

...
```

Neste bloco de código, foi dada enfase a estrutura da EBNF construia a partir das classes factor, term, expression, relation_expression, bool_term, bool_expression,statement, statement_list e block. Cada regra de produção foi implementada de acordo com a EBNF, e a cada regra de produção foi adicionado um `printf` para que fosse possível visualizar o processo de análise sintática.

Para compilar o código, foi construido um `Makefile` no diretório `flex_bison/` com as seguintes instruções, com o nome `compile.sh`:

```bash
#!/bin/bash

# Verifica se um argumento de arquivo foi fornecido
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input file>"
    exit 1
fi

# Atribui o argumento para a variável inputFile
inputFile=$1

# Comandos para processar os arquivos Bison e Flex
bison -d code/bison.y
flex code/lex.l
clang -o parser bison.tab.c lex.yy.c -ll

# Executa o parser com o arquivo de entrada fornecido
./parser < "$inputFile"
```

Para executar o código, basta rodar o comando `./compile.sh <arquivo_de_entrada>`, onde `<arquivo_de_entrada>` é o arquivo que contém o código a ser analisado.

## Compilador

Como mencionado anteriormente, o compilador foi desenvolvido ao decorrer da matéria de Lógica da Computação, ministrada pelo professor Raul Ikeda. O compilador foi modificado para que fosse possível compilar a linguagem `.air`, que foi desenvolvida para este projeto.

As modificações foram feitas nos seguintes arquivos e classes:

1. Parser
2. Tokenizer
3. SymbolTable
4. Operands

Estas mudanças representam mudanças nas etapas de análise léxica, sintática e semântica. Classes que tiveram, apenas o nome alterado, para melhorar a leitura do código, como a PrintOp que se tornou ShowOp não serão tratadas neste documento.

Como a funcionalidade init, representa a criação de classes, houve a necessidade de alteração da SymbolTable:

```dart
class SymbolTable {
  SymbolTable._privateConstructor();

  static final SymbolTable _instance = SymbolTable._privateConstructor();

  static SymbolTable get instance => _instance;

  static SymbolTable getNewInstance() {
    return SymbolTable._privateConstructor();
  }

  final Map<String, Map<String, dynamic>> _table = {};
  final Map<String, Map<String, dynamic>> _classes = {};

  void set({
    required String key,
    required dynamic value,
    required dynamic type,
    required bool isLocal
  }) {
    if (!isLocal) {
      // Permitir redefinição de variáveis
      _table[key] = {'value': value, 'type': type};
    } else {
      if (_table[key] == null) {
        _table[key] = {'value': value, 'type': type};
      } else {
        throw Exception('Variable already defined: $key (local)');
      }
    }
  }

  void setClass(String className, Map<String, dynamic> attributes) {
    if (_classes[className] == null) {
      _classes[className] = attributes;
    } else {
      throw Exception('Class already defined: $className');
    }
  }

  Map<String, dynamic>? getClass(String className) {
    return _classes[className];
  }

  ({dynamic value, String type}) get(String key) {
    final value = _table[key];
    if (value == null) {
      throw Exception('Undefined variable: $key');
    }
    return (value: value['value'], type: value['type']);
  }
}
```

Para ser possível declarar classes com parametros, e requisitar elas, quando necessário, como por exemplo, no momento de realizar uma operação de declaração e/ou aritmética, em conjunto com esta alteração foi necessário adicionar 3 novas classes advindas de Node:

```dart
class ClassInitOp extends Node {
  final Identifier className;
  final List<Identifier> attributes;
  ClassInitOp(this.className, this.attributes) : super(null);

  @override
  dynamic Evaluate(SymbolTable _table, FuncTable _funcTable) {
    final Map<String, dynamic> classAttributes = {};
    for (final attribute in attributes) {
      classAttributes[attribute.name] = null;
    }
    _table.set(
      key: className.name,
      value: classAttributes,
      type: 'class',
      isLocal: false,
    );
  }
}
```
```dart
class AttributeAccessOp extends Node {
  final Identifier className;
  final Identifier attribute;
  AttributeAccessOp(this.className, this.attribute) : super(null);

  @override
  dynamic Evaluate(SymbolTable _table, FuncTable _funcTable) {
    var classInstance = _table.get(className.name).value;
    if (classInstance is Map<String, dynamic>) {
      if (classInstance.containsKey(attribute.name)) {
        return {'value': classInstance[attribute.name], 'type': 'integer'};
      } else {
        throw Exception('Undefined attribute: ${attribute.name}');
      }
    } else {
      throw Exception('Undefined class: ${className.name}');
    }
  }
}
```
```dart
class ClassAttributeAssignOp extends Node {
  final Identifier className;
  final Identifier attribute;
  final Node expr;
  ClassAttributeAssignOp(this.className, this.attribute, this.expr)
      : super(null);

  @override
  dynamic Evaluate(SymbolTable _table, FuncTable _funcTable) {
    var classInstance = _table.get(className.name).value;
    if (classInstance is Map<String, dynamic>) {
      var exprResult = expr.Evaluate(_table, _funcTable);
      classInstance[attribute.name] = exprResult['value'];
    } else {
      throw Exception('Undefined class: ${className.name}');
    }
  }
}
```

Estas alterações foram refletidas no tokenizer, que necessitou da alteração dos tokens reconhecidos como adição de `dot`, `init`, `done`, `check`, `auto`, entre outros tokens já citados na EBNF.

Para `testar` a linguagem e o compilador foi criado um arquivo `test.air`, com todas as operações aritméticas, lógicas, de repetição e de controle, que a linguagem suporta.