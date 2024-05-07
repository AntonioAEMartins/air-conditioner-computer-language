# air-conditioner-computer-language

## EBNF

```
BLOCK = { STATEMENT };

STATEMENT = ( &Lambda | ASSIGNMENT | CHANGE | GET | AUTO | IF ) "\n";

ASSIGNMENT = "SET", IDENTIFIER, EXPRESSION;
CHANGE = "CHANGE", ENTITY, PARAMETER, EXPRESSION;
GET = "GET", IDENTIFIER;
AUTO = "AUTO", BOOL EXPRESSION, "DO", "\n", STATEMENT, END;
IF = "IF", BOOL EXPRESSION, "THEN", "\n", STATEMENT, ( ( ELSE, STATEMENT ) | END );
EXPRESSION = TERM, { ( "+" | "-" ), TERM };
TERM = FACTOR, { ( "*" | "/" ), FACTOR };
FACTOR = ( ( "+" | "-" ), FACTOR ) | NUMBER | "(", BOOL EXPRESSION, ")" | IDENTIFIER;
BOOL EXPRESSION = BOOL TERM, { "OR", BOOL TERM };
BOOL TERM = REL EXP, { "AND", REL EXP };
REL EXP = EXPRESSION, { ( "EQUAL", "ABOVE", "BELOW" ), EXPRESSION };
IDENTIFIER = LETTER, { LETTER | DIGIT | "_" };
NUMBER = DIGIT, { DIGIT };
LETTER = (a | ... | z | A | ... | Z );
DIGIT= ( 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 0 );
```

## Como Executar o Parser

Para compilar e testar o parser gerado com Bison e Flex, você pode usar o script `compile.sh`. Este script automatiza o processo de compilação e execução do parser com um arquivo de entrada especificado.

### Pré-requisitos

Antes de executar o script, certifique-se de que as seguintes ferramentas estão instaladas no seu sistema:
- Bison
- Flex
- Clang

Você pode instalar estas ferramentas no macOS com o Homebrew usando o comando:

```bash
brew install bison flex llvm
```

### Estrutura de Diretórios

Certifique-se de que seus arquivos `bison.y` e `lex.l` estão localizados no diretório `flex_bison/code/` relativamente ao script `compile.sh`.

### Executando o Script

Para usar o script `compile.sh`, siga os passos abaixo:

1. Abra o terminal.
2. Navegue até o diretório onde o `compile.sh` está localizado.
3. Tornar o script executável (se ainda não for):

    ```bash
    chmod +x compile.sh
    ```

4. Execute o script passando o caminho para o arquivo de entrada como argumento:

    ```bash
    ./compile.sh caminho/para/seu/arquivo/test1.txt
    ```

    Substitua `caminho/para/seu/arquivo/test1.txt` pelo caminho real do arquivo de teste que você deseja usar.

### Output

O script compilará os arquivos Bison e Flex encontrados no diretório especificado, linkará o código com o Clang e executará o parser. A saída do parser será mostrada no terminal, baseada no conteúdo do arquivo de entrada fornecido.