# air-conditioner-computer-language

## EBNF

```
BLOCK = { STATEMENT };

STATEMENT = ( "lambda" | ASSIGNMENT | CHANGE | GET | AUTO | IF ), "\n";

ASSIGNMENT = "SET", IDENTIFIER, EXPRESSION;
CHANGE = "CHANGE", ENTITY, PARAMETER, EXPRESSION;
GET = "GET", IDENTIFIER;
AUTO = "AUTO", BOOL_EXP, "DO", "\n", "lambda", { ( STATEMENT ), "lambda" }, "END";
IF = "IF", BOOL_EXP, "THEN", "\n", "lambda", { ( STATEMENT ), "lambda" }, ( "lambda" | ( "ELSE", "\n", "lambda", { ( STATEMENT ), "lambda" } ) ), "END";

EXPRESSION = TERM, { ( "+" | "-" ), TERM };
TERM = FACTOR, { ( "*" | "/" ), FACTOR };
FACTOR = ( ( "+" | "-" | "not" ), FACTOR ) | NUMBER | "(", EXPRESSION, ")" | IDENTIFIER;
BOOL_EXP = BOOL_TERM, { "or", BOOL_TERM };
BOOL_TERM = REL_EXP, { "and", REL_EXP };
REL_EXP = EXPRESSION, { ( "==" | ">" | "<" ), EXPRESSION };

IDENTIFIER = LETTER, { LETTER | DIGIT | "_" };
NUMBER = DIGIT, { DIGIT };
LETTER = ( "a" | "..." | "z" | "A" | "..." | "Z" );
DIGIT = ( "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" | "0" );

```
