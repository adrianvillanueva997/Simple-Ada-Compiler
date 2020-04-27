%{

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
	int ival;
	float fval;
	char* sval;
}
// TIPOS
%token<ival> INT
%token<fval> FLOAT
%token<sval> VAR_NAME
// TOKENS GENERALES
%token PLUS MINUS MULTIPLY DIVIDE // operadores
%token LEFT RIGHT OPEN CLOSE // parentesis/llaves
%token WHILE BOOL FOR CASE // palabras reservadas
%token LESS MORE EQUAL GREATER_THAN LESSER_THAN NOT_EQUAL COMPARE AND OR// operadores logicos
%token COMMENT //simbolos reservados
%token NEWLINE QUIT //cosas de flex
%token TRUE FALSE // operadores booleanos
// PRIORIDADES
%left PLUS MINUS
%left MULTIPLY DIVIDE
//%type<ival> expression
//%type<fval> mixed_expression
%type<sval> OPERATION
%type<sval> BOOLEAN_VAR
%type<sval> BOOLEAN_OP
%type<sval> BOOLEAN_MIX

%start calculation

%%

calculation:
	   | calculation line
;
// Esto es lo que se ejecuta primero
line: 
	NEWLINE {printf("Just a newline");}
	| OPERATION NEWLINE { printf("%s", $1); } // comprobacion de operaciones
	| BOOLEAN_VAR NEWLINE {printf("%s", $1);} // creacion de variables booleanas
	| BOOLEAN_OP NEWLINE {printf("%s",$1);} // operaciones booleanas
	| BOOLEAN_MIX NEWLINE {printf("%s",$1);} // operaciones booleanas and y or 
    //| mixed_expression NEWLINE { printf("\tResult: %f\n", $1);}
    //| expression NEWLINE { printf("\tResult: %i\n", $1); }
    | QUIT NEWLINE { printf("bye!\n"); exit(0); } // salida del programa
;
// Operaciones aritmeticas
OPERATION: 
	INT {$$ = "INTEGER";}
	| FLOAT {$$ = "FLOAT";}
	| OPERATION PLUS OPERATION { $$ = "Operacion aritmetica\n";} // 1 + 1
	| OPERATION MINUS OPERATION { $$ = "Operacion aritmetica\n";} // 1 -1 
	| OPERATION MULTIPLY OPERATION { $$ = "Operacion aritmetica\n";} // 1 * 1
	| OPERATION DIVIDE OPERATION { $$ = "Operacion aritmetica\n";} // 1 / 1
	| LEFT OPERATION RIGHT { $$ = "Operacion aritmetica\n";} // operacion entre parentesis

;
// Declaracion de variables booleanas
BOOLEAN_VAR:  
	BOOL VAR_NAME EQUAL TRUE {$$ = "Declaracion de variable booleana True";} // bool patata = true
	| BOOL VAR_NAME EQUAL FALSE {$$ = "Declaracion de variable booleana False";} // bool patata = false
;
// Operaciones booleanas
BOOLEAN_OP: 
	VAR_NAME COMPARE VAR_NAME {$$ = "Variable igualdad a variable";} // patata == patata
	| VAR_NAME MORE VAR_NAME {$$ = "Variable mayor que variable";} // patata > patata
	| VAR_NAME LESS VAR_NAME {$$ = "Variable menor que variable";} // patata < patata
	| VAR_NAME GREATER_THAN VAR_NAME {$$ = "Variable mayor o igual que variable";} // patata >= patata
	| VAR_NAME LESSER_THAN VAR_NAME {$$ = "Variable menor o igual que variable";} //  patata <= patata
	| VAR_NAME NOT_EQUAL VAR_NAME {$$ = "Variable desigual a variable";} // patata != patata
	| VAR_NAME COMPARE INT {$$ = "Variable igual a numero";} // patata == 1
	| VAR_NAME MORE INT {$$ = "Variable mayor que numero";} // patata > 1
	| VAR_NAME LESS INT {$$ = "Variable menor que numero";} // patata < 1
	| VAR_NAME GREATER_THAN INT {$$ = "Variable mayor o igual que numero";} // patata >= 1
	| VAR_NAME LESSER_THAN INT {$$ = "Variable menor o igual que numero";} // patata <= 1
	| VAR_NAME NOT_EQUAL INT {$$ = "Variable no igual a numero";} // patata != 1
	| INT COMPARE VAR_NAME {$$ = "Numero igual a variable";} // 1 == patata
	| INT MORE VAR_NAME {$$ = "Numero mayor que variable";} // 1 > patata
	| INT LESS VAR_NAME {$$ = "Numero menor que variable";} // 1 < patata
	| INT GREATER_THAN VAR_NAME {$$ = "Numero mayor o igual que variable";} // 1 >= patata
	| INT LESSER_THAN VAR_NAME {$$ = "Numero menor o igual que variable";} // 1 <= patata
	| INT NOT_EQUAL VAR_NAME {$$ = "Numero no igual a variable";} // 1 != patata
	| INT COMPARE INT {$$ = "Numero igual a numero";} // 1 == 1
	| INT MORE INT {$$ = "Numero mayor que numero";} // 1 > 0
	| INT LESS INT {$$ = "Numero menor que numero";} // 1 < 2
	| INT GREATER_THAN INT {$$ = "Numero mayor o igual que numero";} // 1 >= 1
	| INT LESSER_THAN INT {$$ = "Numero menor o igual que numero";} // 1 <= 1
	| INT NOT_EQUAL INT {$$ = "Numero no igual a numero";} // 1 != 0
;

BOOLEAN_MIX:
	BOOLEAN_OP AND BOOLEAN_OP {$$ = "Operacion booleana Y operacion booleana";} // patata > 1 and patata < 2
	| BOOLEAN_OP OR BOOLEAN_OP {$$ = "Operacion booleana O operacion booleana";} // patata > 1 or patata < 2
	// | RIGHT BOOLEAN_MIX LEFT {$$ = "Muchas operaciones booleanas";}  // ESTO PETA Y TENGO QUE REVISARLO

;

%%

int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}