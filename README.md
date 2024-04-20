# air-conditioner-computer-language

## Commands

SET {}
GET
CHANGE
TURN_ON
TURN_OFF

## Example of the language
Input:
```
SET ROOM_TEMPERTURE 80
GET ROOM_TEMPERATURE
CHANGE AIR_CONDITIONER TEMPERATURE 50°F
TURN_ON AIR_CONDITIONER COLD (Speed: 4, Target: 50) THEN TURN_OFF AIR_CONDITIONER
TURN_ON AIR_CONDITIONER AUTO IF ROOM_TEMPERATURE BELOW 60 SPEED 1 ELSE SPEED 3
```

Output:
```
Room Temperature: 80 °F
Cannot Change A/C Temperature, because it is OFF
A/C ON, Target 50°F with Speed 4
Room Temperature: 79 °F
Room Temperature: 78 °F
Room Temperature: 77 °F
Room Temperature: ... °F
Room Temperature: 50 °F
A/C OFF, Target Reached 
```

## EBNF of the Language

```
BLOCK = { STATEMENT };

STATEMENT = ( &lambda;
```
