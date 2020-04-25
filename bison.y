%{

#include <stdio.h>
#include <stdlib.h>

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

%token<ival> INT
%token<fval> FLOAT
%token<sval> STRING
%token<sval> PLUS
%token MINUS MULTIPLY DIVIDE LEFT RIGHT WHILE BOOLEAN FOR CASE OPEN CLOSE LESS MORE EQUAL COMMENT
%token NEWLINE QUIT
%left PLUS MINUS
%left MULTIPLY DIVIDE

%type<ival> expression
%type<sval> mixed_expression
%type<sval> STMTS

%start calculation

%%

calculation:
	   | calculation line
;

line: NEWLINE {printf("Just a newline");}
	| STMTS NEWLINE { printf("%s", $1); }
    | PLUS NEWLINE { printf("The string is: %c", $1);}
    | mixed_expression NEWLINE { printf("\tResult: %s\n", $1);}
    | expression NEWLINE { printf("\tResult: %i\n", $1); }
    | QUIT NEWLINE { printf("bye!\n"); exit(0); }
;

STMTS: STRING STRING EQUAL expression { $$ = "declaracion";}


mixed_expression: FLOAT PLUS FLOAT	 { $$ = "operacion de suma con reales"; }


expression: INT				{ $$ = $1; }
	  | expression PLUS expression	{ $$ = $1 + $3; }
	  | expression MINUS expression	{ $$ = $1 - $3; }
	  | expression MULTIPLY expression	{ $$ = $1 * $3; }
	  | LEFT expression RIGHT		{ $$ = $2; }
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