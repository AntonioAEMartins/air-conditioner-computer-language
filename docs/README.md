# air-conditioner-computer-language

## EBNF

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
    | "init", "(", IDENTIFIER, ",", IDENTIFIER, ",", IDENTIFIER, ")"), "\n" ;

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
