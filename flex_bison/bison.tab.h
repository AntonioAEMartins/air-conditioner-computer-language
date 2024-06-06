/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     NUMBER = 258,
     IDENTIFIER = 259,
     SET = 260,
     SHOW = 261,
     CHECK = 262,
     AUTO = 263,
     IF = 264,
     THEN = 265,
     ELSE = 266,
     DONE = 267,
     DO = 268,
     OR = 269,
     AND = 270,
     ABOVE = 271,
     BELOW = 272,
     EQUAL = 273,
     PLUS = 274,
     MINUS = 275,
     MULT = 276,
     DIV = 277,
     OPEN_PAREN = 278,
     CLOSE_PAREN = 279,
     INIT = 280,
     NOT = 281
   };
#endif
/* Tokens.  */
#define NUMBER 258
#define IDENTIFIER 259
#define SET 260
#define SHOW 261
#define CHECK 262
#define AUTO 263
#define IF 264
#define THEN 265
#define ELSE 266
#define DONE 267
#define DO 268
#define OR 269
#define AND 270
#define ABOVE 271
#define BELOW 272
#define EQUAL 273
#define PLUS 274
#define MINUS 275
#define MULT 276
#define DIV 277
#define OPEN_PAREN 278
#define CLOSE_PAREN 279
#define INIT 280
#define NOT 281




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 10 "code/bison.y"
{
    int ival;
    char *sval;
}
/* Line 1529 of yacc.c.  */
#line 106 "bison.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

