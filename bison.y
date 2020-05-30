%{

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <values.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern FILE *yyout;

int line_num = 1;

int size = 52;

int elementosOcupados = 0;

//Declaraciones del AST

struct ast {
 char* nodetype;
 struct ast *l;
 struct ast *r;
};

struct asign {
 char* nodetype;
 struct ast *as;
};

struct numval {
	char* nodetype;
	double number;
};

//Declaraciones de la tabla de simbolos

struct symb{    
	char* vname;    
	int vvali;   
	float vvalf;
	char* vvals;
	char* type; 
};

struct symb tabla[52];


//Inicialización de funciones
void insertarElemento(struct symb *tabla, int *size, int valor, char* svalor, float fvalor, char *variable, int *elementosOcupados, char* type );
void inicializarArray(struct symb *tabla, int inicio, int fin);
int buscarValor(struct symb *tabla, char *nombre, char *tipo, int *size);
struct ast *createAST(char* nodetype, struct ast *l, struct ast *r);
struct ast *createNum(double d);
struct ast *createASG(char* nodetype, struct ast *op);
void printAST(struct ast *a);

void yyerror(const char* s);

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

%}

%union { 	
	int ival;
	float fval;
	char* sval;

	struct attributes{
	int i;
	float f;
	char* s;
	struct ast *a;
	struct asign *as;
	}st;
}

%error-verbose

// TIPOS
%token<st> INT
%token<st> FLOAT
%token<sval> VAR
%token<sval> STR
%token<sval> CHAR
%token<sval> PLUS
%token<sval> MINUS
%token<sval> MULTIPLY
%token<sval> DIVIDE
%token<sval> EQUAL


// TOKENS GENERALES
%token LEFT RIGHT OPEN CLOSE // parentesis/llaves
%token WHILE BOOL FOR CASE  AND OR PROC IS END BEG INTEGERDEC FLOATDEC CHARDEC STRINGDEC IF THEN DOT LOOP_ IN ELSE ELSIF   // palabras reservadas
%token LESS MORE GREATER_THAN LESSER_THAN NOT_EQUAL  // operadores logicos
%token COMMENT COLON SEMICOLON QUOTE //simbolos reservados
%token NEWLINE //cosas de flex
%token TRUE FALSE // operadores booleanos

// PRIORIDADES
%left PLUS MINUS
%left MULTIPLY DIVIDE

//RESERVADOS
%type<sval> PR

//OPERACIONES
%type<st> OPERATION
%type<st> OPERATION2
%type<sval> SOP
%type<st> DECL
%type<st> DECL2
%type<st> OPER

// Booleanos
%type<st> BOOLEAN_OP
%type<st> IF_COND 
%type<sval> BOOLEAN_OPERATORS
// %type<sval> BOOLEAN_MIX
%type<sval> BOOLEAN_VAR
%type<st> COM
%type<sval> LOOP
%type<sval> BEGIN
%type<sval> VAR_NAME



%start calculation

%%

calculation:
	   | calculation line
;

line:
	IF_COND {  printf("Linea %d ",line_num); printf("%s", $1.s);}
	| PR { printf("Linea %d ",line_num); printf("%s", $1);}
	| LOOP { printf("Linea %d ",line_num); printf("%s", $1);}
	| DECL2 { printf("Linea %d ",line_num); printf("%s",$1.s); printAST($1.a);}
	| DECL { printf("Linea %d ",line_num); printf("%s",$1.s);}
	| COM  { printf("Linea %d ",line_num); printf("%s",$1.s);}
	| error {yyerror; printf("Linea %d ",line_num); printf("Error en esta linea\n");}
	| BEGIN  { printf("Linea %d ",line_num); printf("%s",$1);}
;

DECL2: VAR_NAME COLON EQUAL OPERATION SEMICOLON { $$.s = "Asignacion de int\n";
	insertarElemento(tabla, &size, $4.i, "", 0.0, $1, &elementosOcupados, "integer" ); $$.a = createASG($3,$4.a); }
	
DECL: VAR_NAME COLON INTEGERDEC SEMICOLON { $$.s = "Declaracion de integer\n";/* printf("%s: .word \n ",$1);*/}
	| VAR_NAME COLON STRINGDEC SEMICOLON { $$.s = "Declaracion de string\n";/* printf("%s: .ascii \n ",$1);*/}
	| VAR_NAME COLON FLOATDEC SEMICOLON { $$.s = "Declaracion de float\n";/* printf("%s: .float \n ",$1);*/}
	| VAR_NAME COLON CHARDEC SEMICOLON { $$.s = "Declaracion de char\n";/* printf("%s: .byte \n ",$1);*/}
	| VAR_NAME COLON BOOL SEMICOLON {$$.s="Declaracion de boolean\n";/* printf("%s: .word \n ",$1);*/}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL OPERATION SEMICOLON {$$.s = "Declaracion y asignacion de int\n" ;
	insertarElemento(tabla, &size, $6.i, "", 0.0, $1, &elementosOcupados, "integer" ); /*printf("%s: .word %i \n",$1,$6.i);*/}

	| VAR_NAME COLON FLOATDEC COLON EQUAL OPERATION2 SEMICOLON {$$.s = "Declaracion y asignacion de float\n" ;
	insertarElemento(tabla, &size, 0, "", $6.f, $1, &elementosOcupados, "float" ); /*printf("%s: .float %f \n",$1,$6);*/}

	/*| VAR_NAME COLON EQUAL OPERATION SEMICOLON { $$.s = "Asignacion de int\n";
	insertarElemento(tabla, &size, $4.i, "", 0.0, $1, &elementosOcupados, "integer" ); $$.a = createASG($3,$4.a); }*/
	
	| VAR_NAME COLON EQUAL OPERATION2 SEMICOLON { $$.s = "Asignacion de float\n";
	insertarElemento(tabla, &size, 0, "", $4.f, $1, &elementosOcupados, "float" );}	
	
	| VAR_NAME COLON STRINGDEC COLON EQUAL SOP SEMICOLON { $$.s = "Asignacion y declaracion de string\n";
	insertarElemento(tabla, &size, 0, $6, 0.0, $1, &elementosOcupados, "string" );}
	
	| VAR_NAME COLON EQUAL STR SEMICOLON { $$.s = "Asignacion de string\n";
	insertarElemento(tabla, &size, 0, $4, 0.0, $1, &elementosOcupados, "string" );}
	
	| VAR_NAME COLON FLOATDEC COLON EQUAL OPERATION SEMICOLON { $$.s = "Asignacion y declaracion de float\n";}
	
	| VAR_NAME COLON CHARDEC COLON EQUAL CHAR SEMICOLON { $$.s = "Asignacion y declaracion de char\n";
	insertarElemento(tabla, &size, 0, $6, 0.0, $1, &elementosOcupados, "string" );}
	
	| VAR_NAME COLON EQUAL CHAR SEMICOLON { $$.s = "Asignacion de char\n";
	insertarElemento(tabla, &size, 0, $4, 0.0, $1, &elementosOcupados, "string" );}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL VAR_NAME OPER OPERATION SEMICOLON {$$.s = "Declaracion y asignacion de operacion entre variable e int\n" ;}

	| VAR_NAME COLON EQUAL VAR_NAME OPER OPERATION SEMICOLON { $$.s = "Asignacion de de operacion entre variable e int\n" ;}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL OPERATION OPER VAR_NAME SEMICOLON {$$.s = "Declaracion y asignacion de operacion entre int y variable\n" ;}

	| VAR_NAME COLON EQUAL OPERATION OPER VAR_NAME SEMICOLON { $$.s = "Asignacion de operacion entre int y variable\n" ;}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL VAR_NAME OPER OPERATION2 SEMICOLON {$$.s = "Declaracion y asignacion de operacion entre variable y float\n" ;}

	| VAR_NAME COLON EQUAL VAR_NAME OPER OPERATION2 SEMICOLON { $$.s = "Asignacion de operacion entre float y variable\n" ;}

	| VAR_NAME COLON EQUAL OPERATION2 OPER VAR_NAME SEMICOLON { $$.s = "Asignacion de operacion entre variable y float\n" ;}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL VAR_NAME OPER VAR_NAME SEMICOLON {$$.s = "Declaracion y asignacion de operacion entre variable y variable\n" ;}

	| VAR_NAME COLON EQUAL VAR_NAME OPER VAR_NAME SEMICOLON { $$.s = "Asignacion de operacion entre variable y variable\n" ;}
	
	| VAR_NAME COLON EQUAL BOOLEAN_VAR SEMICOLON {$$.s="Asignacion de boolean\n";}
	
;

OPER: PLUS {$$.s = "+";}
	| MINUS {$$.s = "-";}
	| DIVIDE {$$.s = "/";}
	| MULTIPLY {$$.s = "*";}

LOOP: FOR VAR_NAME IN INT DOT DOT VAR_NAME LOOP_ {$$="Bucle for\n";}
	| FOR VAR_NAME IN VAR_NAME DOT DOT VAR_NAME LOOP_ {$$="Bucle for\n";}
	| FOR VAR_NAME IN VAR_NAME DOT DOT INT LOOP_ {$$="Bucle for\n";}
	| FOR VAR_NAME IN INT DOT DOT INT LOOP_ {$$="Bucle for\n";}
	| END LOOP_ SEMICOLON {$$="Fin de for\n";}

;
COM:
	COMMENT {$$.s = "Comentario\n";}

;

VAR_NAME:
	VAR {$$ = $1;}
;

BEGIN:
	BEG {$$ = "Begin\n";}
	| END SEMICOLON {$$ = "End begin\n";}

PR:
	PROC VAR_NAME IS {$$ = "Procedure\n";}
	| END VAR_NAME SEMICOLON {$$ = "End procedure";}
;

IF_COND: 
	IF BOOLEAN_OP THEN {$$.s = "Sentencia IF\n";}
	| END IF SEMICOLON {$$.s = "End IF\n";}
	| ELSE {$$.s = "Else\n";}
	| ELSIF {$$.s = "Elsif\n";}
;


// Operaciones aritmeticas con int 
OPERATION: INT {$$.i = $1.i; $$.a = createNum($1.i);}
	| OPERATION PLUS OPERATION {$$.i = $1.i + $3.i; $$.a = createAST($2,$1.a,$3.a);} // 1 + 1
	| OPERATION MINUS OPERATION { $$.i = $1.i - $3.i;} // 1 -1
	| OPERATION MULTIPLY OPERATION { $$.i = $1.i * $3.i;} // 1 * 1
	| OPERATION DIVIDE OPERATION { $$.i = $1.i / $3.i;} // 1 / 1
	//| LEFT OPERATION RIGHT { $$.i = "Operacion aritmetica\n";} // operacion entre parentesis

;
// Operaciones aritmeticas con float
OPERATION2: FLOAT {$$.f = $1.f;}
	| OPERATION2 PLUS OPERATION2 {$$.f = $1.f + $3.f;} // 1 + 1
	| OPERATION2 MINUS OPERATION2 { $$.f = $1.f - $3.f;} // 1 -1
	| OPERATION2 MULTIPLY OPERATION2 { $$.f = $1.f * $3.f;} // 1 * 1
	| OPERATION2 DIVIDE OPERATION2 { $$.f = $1.f / $3.f;} // 1 / 1
	//| LEFT OPERATION2 RIGHT { $$.f = "Operacion aritmetica\n";} // operacion entre parentesis

;

SOP: STR {$$ = $1;}

;

// Expresiones booleanas
BOOLEAN_OPERATORS:
	EQUAL {$$ = "==\n";}
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
	VAR_NAME BOOLEAN_OPERATORS VAR_NAME {$$.s="Operacion booleana variables\n";}
	| VAR_NAME BOOLEAN_OPERATORS INT {$$.s="Operacion booleana variable - numero\n";}
	| VAR_NAME BOOLEAN_OPERATORS STR {$$.s="Operacion booleana variable - string\n";}
	| VAR_NAME BOOLEAN_OPERATORS FLOAT {$$.s="Operacion booleana variable - float\n";}
	| INT BOOLEAN_OPERATORS INT {$$.s="Operacion booleana numero - numero\n";}
	| STR BOOLEAN_OPERATORS STR {$$.s="Operacion booleana string - string\n";}
	| FLOAT BOOLEAN_OPERATORS FLOAT {$$.s="Operacion booleana float - float\n";}
	| VAR_NAME EQUAL BOOLEAN_VAR {$$.s="Variable igual a True/False\n";}

;

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

%%

void inicializarArray(struct symb *tabla, int inicio, int fin) {
    for (int i = inicio; i < fin; i++) {
        tabla[i].vname = "._empty";
    }
}

int buscarValor(struct symb *tabla, char *nombre, char *tipo, int *size) {
    int i = 0;
    int status = -1;
    while (i < *size && status == -1) {
        if (strcmp(tabla[i].vname, nombre) == 0 && (strcmp(tabla[i].type, tipo) == 0 )) {
            status = i;
        } else {
            i++;
        }
    }
    return status;
}

void insertarElemento(struct symb *tabla, int *size, int valor, char* svalor, float fvalor, char *variable, int *elementosOcupados, char* type ) {
    int status = 0;
    status = buscarValor(tabla, variable, type, size);

    if(status != -1){
    	if (strcmp(type, "integer") == 0){
	        		tabla[status].vname = variable;
	        		tabla[status].vvali = valor;
	        		tabla[status].type = type;
	            } else if (strcmp(type, "float") == 0) {
	                tabla[status].vname = variable;
	                tabla[status].vvalf = fvalor;
	                tabla[status].type = type;
	            } else if (strcmp(type, "string") == 0) {
	                tabla[status].vname = variable;
	                tabla[status].vvals = svalor;
	                tabla[status].type = type;
	            }        	
    }else{

	    int i = 0;
	    int encontrado = 0;

	    while (i < *size && encontrado == 0) {

	        if (strcmp(tabla[i].vname, "._empty") == 0) {
	        	if (strcmp(type, "integer") == 0){
	        		tabla[i].vname = variable;
	        		tabla[i].vvali = valor;
	        		tabla[i].type = type;
	        		*elementosOcupados = *elementosOcupados + 1;
	        		encontrado = 1;
	            } else if (strcmp(type, "float") == 0) {
	                tabla[i].vname = variable;
	                tabla[i].vvalf = fvalor;
	                tabla[i].type = type;
	                *elementosOcupados = *elementosOcupados + 1;
	                encontrado = 1;
	            } else if (strcmp(type, "string") == 0) {
	                tabla[i].vname = variable;
	                tabla[i].vvals = svalor;
	                tabla[i].type = type;
	                *elementosOcupados = *elementosOcupados + 1;
	                encontrado = 1;
	            }        	
	            
	            *elementosOcupados = *elementosOcupados + 1;
	            encontrado = 1;
	        } else {
	            i++;
	        }
	    }
    }
     
}

struct ast *createASG(char* nodetype, struct ast *op){

	struct asign *a = malloc(sizeof(struct asign));
	if(!a) {
		yyerror("out of space");
		exit(0);
	}
	a->nodetype = "=";
	a->as = op;
	//printf("%s",a->nodetype);
	return (struct ast *)a;
}

struct ast *createAST(char* nodetype, struct ast *l, struct ast *r)
{
 struct ast *a = malloc(sizeof(struct ast));

 if(!a) {
 yyerror("out of space");
 exit(0);
 }
 a->nodetype = nodetype;
 a->l = l;
 a->r = r;
 return a;
}

struct ast *createNum(double d)
{
 	struct numval *a = malloc(sizeof(struct numval));
  	if(!a) {
 		yyerror("out of space");
 		exit(0);
 	}
 	a->nodetype = "K";
 	a->number = d;
 	return (struct ast *)a;
}

void printAST(struct ast *a){

	printf("%s",a->nodetype);

	//printf("llego bien");
}




int main(int argc, char *argv[]) {

		inicializarArray(tabla, 0, size);

		if (argc == 1) {

             yyparse();

		}

		if (argc == 2) {
             yyin = fopen(argv[1], "rt");
             yyout = fopen(argv[2], "wt" );

             yyparse();

		}
		for(int b = 0; b < 52; b++){
			printf("\n");		
			printf("Nombre %s ",tabla[b].vname);
			printf("INT %i ",tabla[b].vvali);
			printf("FLOAT %f ",tabla[b].vvalf);
			printf("STRING %s ",tabla[b].vvals);
			printf("TIPO %s ",tabla[b].type);
			printf("\n");
		}		


}


void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
}

	
	
