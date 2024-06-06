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