%{

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern FILE *yyout;

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
// TOKENS GENERALES
%token PLUS MINUS MULTIPLY DIVIDE // operadores
%token LEFT RIGHT OPEN CLOSE // parentesis/llaves
%token WHILE BOOL FOR CASE STR VAR_NAME CHAR AND OR PROC IS END BEG INTEGERDEC FLOATDEC CHARDEC STRINGDEC IF THEN // palabras reservadas
%token LESS MORE EQUAL GREATER_THAN LESSER_THAN NOT_EQUAL COMPARE  // operadores logicos
%token COMMENT COLON SEMICOLON QUOTE //simbolos reservados
%token NEWLINE QUIT //cosas de flex
%token TRUE FALSE // operadores booleanos

// PRIORIDADES
%left PLUS MINUS
%left MULTIPLY DIVIDE

//RESERVADOS
%type<sval> PR

//OPERACIONES
%type<sval> OPERATION
%type<sval> DECL

// Booleanos
%type<sval> BOOLEAN_OP
%type<sval> IF_COND 
%type<sval> BOOLEAN_OPERATORS
// %type<sval> BOOLEAN_MIX
%type<sval> BOOLEAN_VAR

%start calculation

%%

calculation:
	   | calculation line
;

line: OPERATION { printf("%s", $1); }
	| IF_COND {printf("%s", $1);}
	| BOOLEAN_OP {printf("%s", $1);}
	| PR {printf("%s", $1);}
	// | BOOLEAN_MIX {printf("%s",%1);}
	| DECL {printf("%s",$1);}
    | QUIT { printf("bye!\n"); exit(0); }
;
// Declaracion y asignacion de variables
DECL: VAR_NAME COLON INTEGERDEC SEMICOLON { $$ = "Declaracion de integer\n";}
	| VAR_NAME COLON STRINGDEC SEMICOLON { $$ = "Declaracion de string\n";}
	| VAR_NAME COLON FLOATDEC SEMICOLON { $$ = "Declaracion de float\n";}
	| VAR_NAME COLON CHARDEC SEMICOLON { $$ = "Declaracion de char\n";}
	| VAR_NAME COLON BOOL SEMICOLON {$$="Declaracion de boolean\n";}
	| VAR_NAME COLON INTEGERDEC COLON EQUAL OPERATION SEMICOLON { $$ = "Asignacion y declaracion de integer\n";}
	| VAR_NAME COLON EQUAL OPERATION SEMICOLON { $$ = "Asignacion de int/float\n";}
	| VAR_NAME COLON STRINGDEC COLON EQUAL STR SEMICOLON { $$ = "Asignacion y declaracion de string\n";}
	| VAR_NAME COLON EQUAL STR SEMICOLON { $$ = "Asignacion de string\n";}
	| VAR_NAME COLON FLOATDEC COLON EQUAL OPERATION SEMICOLON { $$ = "Asignacion y declaracion de float\n";}
	| VAR_NAME COLON CHARDEC COLON EQUAL CHAR SEMICOLON { $$ = "Asignacion y declaracion de char\n";}
	| VAR_NAME COLON EQUAL CHAR SEMICOLON { $$ = "Asignacion de char\n";}
	| VAR_NAME COLON EQUAL BOOLEAN_VAR SEMICOLON {$$="Asignacion de boolean\n";}
	
;

PR:
	PROC VAR_NAME IS {$$ = "Procedure\n";}
	| END VAR_NAME SEMICOLON {$$ = "End procedure";}
;

IF_COND: 
	IF BOOLEAN_OP THEN {$$ = "Sentencia IF\n";}

;


// Operaciones aritmeticas
OPERATION: INT {$$ = "INTEGER";}
	| FLOAT {$$ = "FLOAT";}
	| OPERATION PLUS OPERATION { $$ = "Operacion aritmetica\n";} // 1 + 1
	| OPERATION MINUS OPERATION { $$ = "Operacion aritmetica\n";} // 1 -1
	| OPERATION MULTIPLY OPERATION { $$ = "Operacion aritmetica\n";} // 1 * 1
	| OPERATION DIVIDE OPERATION { $$ = "Operacion aritmetica\n";} // 1 / 1
	| LEFT OPERATION RIGHT { $$ = "Operacion aritmetica\n";} // operacion entre parentesis

;

// Expresiones booleanas
BOOLEAN_OPERATORS:
	COMPARE {$$ = "==\n";}
	| MORE {$$=">\n";}
	| LESS {$$== "<\n";}
	| GREATER_THAN {$$=">=\n";}
	| LESSER_THAN {$$="<=\n";}
	| NOT_EQUAL {$$="!=\n";}
;
// VARIABLES BOOLEANAS
BOOLEAN_VAR:
	TRUE {$$="True\n";}
	| FALSE {$$="False\n";}
;
/*
// Operaciones booleanas con and y or
BOOLEAN_MIX:
	BOOLEAN_OP AND BOOLEAN_OP {$$="Expresiones booleanas con AND\n";}
	BOOLEAN_OP OR BOOLEAN_OP {$$="Expresiones booleanas con OR\n";}

;
*/
// Operaciones booleanas
BOOLEAN_OP:
	VAR_NAME BOOLEAN_OPERATORS VAR_NAME {$$="Operacion booleana variables\n";}
	| VAR_NAME BOOLEAN_OPERATORS INT {$$="Operacion booleana variable - numero\n";}
	| VAR_NAME BOOLEAN_OPERATORS STR {$$="Operacion booleana variable - string\n";}
	| VAR_NAME BOOLEAN_OPERATORS FLOAT {$$="Operacion booleana variable - float\n";}
	| INT BOOLEAN_OPERATORS INT {$$="Operacion booleana numero - numero\n";}
	| STR BOOLEAN_OPERATORS STR {$$="Operacion booleana string - string\n";}
	| FLOAT BOOLEAN_OPERATORS FLOAT {$$="Operacion booleana float - float\n";}
	| VAR_NAME COMPARE BOOLEAN_VAR {$$="Variable igual a True/False\n";}
;


%%

int main(int argc, char *argv[]) {


		if (argc == 1) {

             yyparse();

		}

		if (argc == 2) {
             yyin = fopen(argv[1], "rt");
             yyout = fopen(argv[2], "wt" );

             yyparse();

		}

}


void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
