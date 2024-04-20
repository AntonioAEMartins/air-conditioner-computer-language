# air-conditioner-computer-language

## Commands

SET {}
GET
CHANGE
TURN_ON (CHANGE ... STATE)
TURN_OFF (Change ... STATE)

## EBNF of the Language

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
