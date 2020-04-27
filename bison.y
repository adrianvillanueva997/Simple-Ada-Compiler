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
%token<sval> STRING
// TOKENS GENERALES
%token PLUS MINUS MULTIPLY DIVIDE // operadores
%token LEFT RIGHT OPEN CLOSE // parentesis/llaves
%token WHILE BOOL FOR CASE // palabras reservadas
%token LESS MORE EQUAL GREATER_THAN LESSER_THAN NOT_EQUAL COMPARE  // operadores logicos
%token COMMENT //simbolos reservados
%token NEWLINE QUIT //cosas de flex
%token TRUE FALSE
// PRIORIDADES
%left PLUS MINUS
%left MULTIPLY DIVIDE
//%type<ival> expression
//%type<fval> mixed_expression
%type<sval> OPERATION
%type<sval> BOOLEAN_VAR
%type<sval> BOOLEAN_OP

%start calculation

%%

calculation:
	   | calculation line
;

line: NEWLINE {printf("Just a newline");}
	| OPERATION NEWLINE { printf("%s", $1); }
	| BOOLEAN_VAR NEWLINE {printf("%s", $1);}
    //| mixed_expression NEWLINE { printf("\tResult: %f\n", $1);}
    //| expression NEWLINE { printf("\tResult: %i\n", $1); }
    | QUIT NEWLINE { printf("bye!\n"); exit(0); }
;

OPERATION: INT {$$ = "INTEGER";}
	| FLOAT {$$ = "FLOAT";}
	| OPERATION PLUS OPERATION { $$ = "Operacion aritmetica\n";}
	| OPERATION MINUS OPERATION { $$ = "Operacion aritmetica\n";}
	| OPERATION MULTIPLY OPERATION { $$ = "Operacion aritmetica\n";}
	| OPERATION DIVIDE OPERATION { $$ = "Operacion aritmetica\n";}
	| LEFT OPERATION RIGHT { $$ = "Operacion aritmetica\n";}

;
BOOLEAN_VAR:  BOOL STRING EQUAL TRUE {$$ = "Declaracion de variable booleana True";}
	| BOOL STRING EQUAL FALSE {$$ = "Declaracion de variable booleana False";}
	
	

;
/*OPERATIONS: OPERATION { $$ = "Operacion aritmetica\n";}
	|OPERATION PLUS OPERATION { $$ = "Operacion aritmetica\n";}*/

/*mixed_expression: FLOAT                 		 { $$ = $1; }
	  | mixed_expression PLUS mixed_expression	 { $$ = $1 + $3; }
	  | mixed_expression MINUS mixed_expression	 { $$ = $1 - $3; }
	  | mixed_expression MULTIPLY mixed_expression { $$ = $1 * $3; }
	  | mixed_expression DIVIDE mixed_expression	 { $$ = $1 / $3; }
	  | LEFT mixed_expression RIGHT		 { $$ = $2; }
	  | expression PLUS mixed_expression	 	 { $$ = $1 + $3; }
	  | expression MINUS mixed_expression	 	 { $$ = $1 - $3; }
	  | expression MULTIPLY mixed_expression 	 { $$ = $1 * $3; }
	  | expression DIVIDE mixed_expression	 { $$ = $1 / $3; }
	  | mixed_expression PLUS expression	 	 { $$ = $1 + $3; }
	  | mixed_expression MINUS expression	 	 { $$ = $1 - $3; }
	  | mixed_expression MULTIPLY expression 	 { $$ = $1 * $3; }
	  | mixed_expression DIVIDE expression	 { $$ = $1 / $3; }
	  | expression DIVIDE expression		 { $$ = $1 / (float)$3; }
*/
/*expression: INT				{ $$ = $1; }
	  | expression PLUS expression	{ $$ = $1 + $3; }
	  | expression MINUS expression	{ $$ = $1 - $3; }
	  | expression MULTIPLY expression	{ $$ = $1 * $3; }
	  | LEFT expression RIGHT		{ $$ = $2; }
;
*/
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