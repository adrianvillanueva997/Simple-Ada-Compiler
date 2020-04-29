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
// TOKENS GENERALES
%token PLUS MINUS MULTIPLY DIVIDE // operadores
%token LEFT RIGHT OPEN CLOSE // parentesis/llaves
%token WHILE BOOL FOR CASE INTEGERDEC FLOATDEC CHARDEC STRINGDEC STR VAR_NAME CHAR // palabras reservadas
%token LESS MORE EQUAL GREATER_THAN LESSER_THAN NOT_EQUAL COMPARE  // operadores logicos
%token COMMENT COLON SEMICOLON QUOTE //simbolos reservados
%token NEWLINE QUIT //cosas de flex
%token TRUE FALSE
// PRIORIDADES
%left PLUS MINUS
%left MULTIPLY DIVIDE

%type<sval> OPERATION
%type<sval> DECL
//%type<sval> ASIG
%type<sval> BOOLEAN_VAR

%start calculation

%%

calculation:
	   | calculation line
;

line: NEWLINE {printf("Just a newline");}
	| OPERATION NEWLINE { printf("%s", $1); }
	| BOOLEAN_VAR NEWLINE {printf("%s", $1);}
	| DECL NEWLINE {printf("%s",$1);}
	//| ASIG NEWLINE {printf("%s",$1);}
    | QUIT NEWLINE { printf("bye!\n"); exit(0); }
;

DECL: VAR_NAME COLON INTEGERDEC SEMICOLON { $$ = "Declaracion de integer\n";}
	| VAR_NAME COLON STRINGDEC SEMICOLON { $$ = "Declaracion de string\n";}
	| VAR_NAME COLON FLOATDEC SEMICOLON { $$ = "Declaracion de float\n";}
	| VAR_NAME COLON CHARDEC SEMICOLON { $$ = "Declaracion de char\n";}
	| VAR_NAME COLON INTEGERDEC COLON EQUAL OPERATION SEMICOLON { $$ = "Asignacion y declaracion de integer\n";}
	| VAR_NAME COLON EQUAL OPERATION SEMICOLON { $$ = "Asignacion de int/float\n";}
	| VAR_NAME COLON STRINGDEC COLON EQUAL STR SEMICOLON { $$ = "Asignacion y declaracion de string\n";}
	| VAR_NAME COLON EQUAL STR SEMICOLON { $$ = "Asignacion de string\n";}
	| VAR_NAME COLON FLOATDEC COLON EQUAL OPERATION SEMICOLON { $$ = "Asignacion y declaracion de float\n";}
	| VAR_NAME COLON CHARDEC COLON EQUAL CHAR SEMICOLON { $$ = "Asignacion y declaracion de char\n";}
	| VAR_NAME COLON EQUAL CHAR SEMICOLON { $$ = "Asignacion de char\n";}
	

;
OPERATION: INT {$$ = "INTEGER";}
	| FLOAT {$$ = "FLOAT";}
	| OPERATION PLUS OPERATION { $$ = "Operacion aritmetica\n";}
	| OPERATION MINUS OPERATION { $$ = "Operacion aritmetica\n";}
	| OPERATION MULTIPLY OPERATION { $$ = "Operacion aritmetica\n";}
	| OPERATION DIVIDE OPERATION { $$ = "Operacion aritmetica\n";}
	| LEFT OPERATION RIGHT { $$ = "Operacion aritmetica\n";}


;
BOOLEAN_VAR:  BOOL VAR_NAME EQUAL TRUE {$$ = "Declaracion de variable booleana True";}
	| BOOL VAR_NAME EQUAL FALSE {$$ = "Declaracion de variable booleana False";}

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