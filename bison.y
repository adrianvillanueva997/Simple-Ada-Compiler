%{

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern FILE *yyout;

int line_num = 1;

int size = 52;

int elementosOcupados = 0;

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

void yyerror(const char* s);
%}

%union {
	int ival;
	float fval;
	char* sval;
}

%error-verbose

// TIPOS
%token<ival> INT
%token<fval> FLOAT
%token<sval> VAR
%token<sval> STR
%token<sval> CHAR
%token<sval> PLUS
%token<sval> MINUS
%token<sval> MULTIPLY
%token<sval> DIVIDE


// TOKENS GENERALES
%token LEFT RIGHT OPEN CLOSE // parentesis/llaves
%token WHILE BOOL FOR CASE  AND OR PROC IS END BEG INTEGERDEC FLOATDEC CHARDEC STRINGDEC IF THEN DOT LOOP_ IN ELSE ELSIF   // palabras reservadas
%token LESS MORE EQUAL GREATER_THAN LESSER_THAN NOT_EQUAL  // operadores logicos
%token COMMENT COLON SEMICOLON QUOTE //simbolos reservados
%token NEWLINE //cosas de flex
%token TRUE FALSE // operadores booleanos

// PRIORIDADES
%left PLUS MINUS
%left MULTIPLY DIVIDE

//RESERVADOS
%type<sval> PR

//OPERACIONES
%type<ival> OPERATION
%type<fval> OPERATION2
%type<sval> SOP
%type<sval> DECL

// Booleanos
%type<sval> BOOLEAN_OP
%type<sval> IF_COND 
%type<sval> BOOLEAN_OPERATORS
// %type<sval> BOOLEAN_MIX
%type<sval> BOOLEAN_VAR
%type<sval> COM
%type<sval> LOOP
%type<sval> BEGIN
%type<sval> VAR_NAME




%start calculation

%%

calculation:
	   | calculation line
;

line:
	IF_COND {  printf("Linea %d ",line_num); printf("%s", $1);}
	| PR { printf("Linea %d ",line_num); printf("%s", $1);}
	| LOOP { printf("Linea %d ",line_num); printf("%s", $1);}
	| DECL { printf("Linea %d ",line_num); printf("%s",$1);}
	| COM  { printf("Linea %d ",line_num); printf("%s",$1);}
	| error {yyerror; printf("Linea %d ",line_num); printf("Error en esta linea\n");}
	| BEGIN  { printf("Linea %d ",line_num); printf("%s",$1);}
;
	
DECL: VAR_NAME COLON INTEGERDEC SEMICOLON { $$ = "Declaracion de integer\n";}
	| VAR_NAME COLON STRINGDEC SEMICOLON { $$ = "Declaracion de string\n";}
	| VAR_NAME COLON FLOATDEC SEMICOLON { $$ = "Declaracion de float\n";}
	| VAR_NAME COLON CHARDEC SEMICOLON { $$ = "Declaracion de char\n";}
	| VAR_NAME COLON BOOL SEMICOLON {$$="Declaracion de boolean\n";}
	| VAR_NAME COLON INTEGERDEC COLON EQUAL OPERATION SEMICOLON {$$ = "Declaracion y asignacion de int\n" ;
	insertarElemento(tabla, &size, $6, "", 0.0, $1, &elementosOcupados, "integer" );}

	| VAR_NAME COLON FLOATDEC COLON EQUAL OPERATION2 SEMICOLON {$$ = "Declaracion y asignacion de float\n" ;
	insertarElemento(tabla, &size, 0, "", $6, $1, &elementosOcupados, "float" );}

	| VAR_NAME COLON EQUAL OPERATION SEMICOLON { $$ = "Asignacion de int\n";
	insertarElemento(tabla, &size, $4, "", 0.0, $1, &elementosOcupados, "integer" );}
	
	| VAR_NAME COLON EQUAL OPERATION2 SEMICOLON { $$ = "Asignacion de float\n";
	insertarElemento(tabla, &size, 0, "", $4, $1, &elementosOcupados, "float" );}	
	
	| VAR_NAME COLON STRINGDEC COLON EQUAL SOP SEMICOLON { $$ = "Asignacion y declaracion de string\n";
	insertarElemento(tabla, &size, 0, $6, 0.0, $1, &elementosOcupados, "string" );}
	
	| VAR_NAME COLON EQUAL STR SEMICOLON { $$ = "Asignacion de string\n";
	insertarElemento(tabla, &size, 0, $4, 0.0, $1, &elementosOcupados, "string" );}
	
	| VAR_NAME COLON FLOATDEC COLON EQUAL OPERATION SEMICOLON { $$ = "Asignacion y declaracion de float\n";}
	
	| VAR_NAME COLON CHARDEC COLON EQUAL CHAR SEMICOLON { $$ = "Asignacion y declaracion de char\n";
	insertarElemento(tabla, &size, 0, $6, 0.0, $1, &elementosOcupados, "string" );}
	
	| VAR_NAME COLON EQUAL CHAR SEMICOLON { $$ = "Asignacion de char\n";
	insertarElemento(tabla, &size, 0, $4, 0.0, $1, &elementosOcupados, "string" );}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL VAR_NAME PLUS OPERATION SEMICOLON {$$ = "Declaracion y asignacion de variable mas int\n" ;}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL VAR_NAME MINUS OPERATION SEMICOLON {$$ = "Declaracion y asignacion de variable menos int\n" ;}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL VAR_NAME MULTIPLY OPERATION SEMICOLON {$$ = "Declaracion y asignacion de variable por int\n" ;}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL VAR_NAME DIVIDE OPERATION SEMICOLON {$$ = "Declaracion y asignacion de variable entre int\n" ;}

	| VAR_NAME COLON EQUAL VAR_NAME PLUS OPERATION SEMICOLON { $$ = "Asignacion de variable mas int\n" ;}

	| VAR_NAME COLON EQUAL VAR_NAME MINUS OPERATION SEMICOLON { $$ = "Asignacion de variable menos int\n" ;}

	| VAR_NAME COLON EQUAL VAR_NAME MULTIPLY OPERATION SEMICOLON { $$ = "Asignacion de variable por int\n" ;}

	| VAR_NAME COLON EQUAL VAR_NAME DIVIDE OPERATION SEMICOLON { $$ = "Asignacion de variable entre int\n" ;}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL OPERATION PLUS VAR_NAME SEMICOLON {$$ = "Declaracion y asignacion de int mas variable \n" ;}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL OPERATION MINUS VAR_NAME SEMICOLON {$$ = "Declaracion y asignacion de int menos variable \n" ;}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL OPERATION MULTIPLY VAR_NAME SEMICOLON {$$ = "Declaracion y asignacion de int por variable \n" ;}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL OPERATION DIVIDE VAR_NAME SEMICOLON {$$ = "Declaracion y asignacion de int entre variable \n" ;}

	| VAR_NAME COLON EQUAL OPERATION PLUS VAR_NAME SEMICOLON { $$ = "Asignacion de int mas variable\n" ;}

	| VAR_NAME COLON EQUAL OPERATION MINUS VAR_NAME SEMICOLON { $$ = "Asignacion de int menos variable\n" ;}

	| VAR_NAME COLON EQUAL OPERATION MULTIPLY VAR_NAME SEMICOLON { $$ = "Asignacion de int por variable\n" ;}

	| VAR_NAME COLON EQUAL OPERATION DIVIDE VAR_NAME SEMICOLON { $$ = "Asignacion de int entre variable\n" ;}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL VAR_NAME PLUS OPERATION2 SEMICOLON {$$ = "Declaracion y asignacion de variable mas float\n" ;}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL VAR_NAME MINUS OPERATION2 SEMICOLON {$$ = "Declaracion y asignacion de variable menos float\n" ;}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL VAR_NAME MULTIPLY OPERATION2 SEMICOLON {$$ = "Declaracion y asignacion de variable por float\n" ;}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL VAR_NAME DIVIDE OPERATION2 SEMICOLON {$$ = "Declaracion y asignacion de variable entre float\n" ;}	

	| VAR_NAME COLON EQUAL VAR_NAME PLUS OPERATION2 SEMICOLON { $$ = "Asignacion de variable mas float\n" ;}

	| VAR_NAME COLON EQUAL VAR_NAME MINUS OPERATION2 SEMICOLON { $$ = "Asignacion de variable menos float\n" ;}

	| VAR_NAME COLON EQUAL VAR_NAME MULTIPLY OPERATION2 SEMICOLON { $$ = "Asignacion de variable por float\n" ;}

	| VAR_NAME COLON EQUAL VAR_NAME DIVIDE OPERATION2 SEMICOLON { $$ = "Asignacion de variable entre float\n" ;}

	| VAR_NAME COLON EQUAL OPERATION2 PLUS VAR_NAME SEMICOLON { $$ = "Asignacion de float mas variable\n" ;}

	| VAR_NAME COLON EQUAL OPERATION2 MINUS VAR_NAME SEMICOLON { $$ = "Asignacion de float menos variable\n" ;}

	| VAR_NAME COLON EQUAL OPERATION2 MULTIPLY VAR_NAME SEMICOLON { $$ = "Asignacion de float por variable\n" ;}

	| VAR_NAME COLON EQUAL OPERATION2 DIVIDE VAR_NAME SEMICOLON { $$ = "Asignacion de float entre variable\n" ;}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL VAR_NAME PLUS VAR_NAME SEMICOLON {$$ = "Declaracion y asignacion de variable mas variable\n" ;}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL VAR_NAME MINUS VAR_NAME SEMICOLON {$$ = "Declaracion y asignacion de variable menos variable\n" ;}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL VAR_NAME MULTIPLY VAR_NAME SEMICOLON {$$ = "Declaracion y asignacion de variable por variable\n" ;}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL VAR_NAME DIVIDE VAR_NAME SEMICOLON {$$ = "Declaracion y asignacion de variable entre variable\n" ;}

	| VAR_NAME COLON EQUAL VAR_NAME PLUS VAR_NAME SEMICOLON { $$ = "Asignacion de variable mas variable\n" ;}

	| VAR_NAME COLON EQUAL VAR_NAME MINUS VAR_NAME SEMICOLON { $$ = "Asignacion de variable menos variable\n" ;}

	| VAR_NAME COLON EQUAL VAR_NAME MULTIPLY VAR_NAME SEMICOLON { $$ = "Asignacion de variable por variable\n" ;}

	| VAR_NAME COLON EQUAL VAR_NAME DIVIDE VAR_NAME SEMICOLON { $$ = "Asignacion de variable entre variable\n" ;}
	
	| VAR_NAME COLON EQUAL BOOLEAN_VAR SEMICOLON {$$="Asignacion de boolean\n";}
	
;

LOOP: FOR VAR_NAME IN INT DOT DOT VAR_NAME LOOP_ {$$="Bucle for\n";}
	| FOR VAR_NAME IN VAR_NAME DOT DOT VAR_NAME LOOP_ {$$="Bucle for\n";}
	| FOR VAR_NAME IN VAR_NAME DOT DOT INT LOOP_ {$$="Bucle for\n";}
	| FOR VAR_NAME IN INT DOT DOT INT LOOP_ {$$="Bucle for\n";}
	| END LOOP_ SEMICOLON {$$="Fin de for\n";}

;
COM:
	COMMENT {$$ = "Comentario\n";}

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
	IF BOOLEAN_OP THEN {$$ = "Sentencia IF\n";}
	| END IF SEMICOLON {$$ = "End IF\n";}
	| ELSE {$$ = "Else\n";}
	| ELSIF {$$ = "Elsif\n";}
;


// Operaciones aritmeticas con int 
OPERATION: INT {$$ = $1;}
	| OPERATION PLUS OPERATION {$$ = $1 + $3;} // 1 + 1
	| OPERATION MINUS OPERATION { $$ = $1 - $3;} // 1 -1
	| OPERATION MULTIPLY OPERATION { $$ = $1 * $3;} // 1 * 1
	| OPERATION DIVIDE OPERATION { $$ = $1 / $3;} // 1 / 1
	//| LEFT OPERATION RIGHT { $$ = "Operacion aritmetica\n";} // operacion entre parentesis

;
// Operaciones aritmeticas con float
OPERATION2: FLOAT {$$ = $1;}
	//| VAR_NAME {$1;}
	| OPERATION2 PLUS OPERATION2 {$$ = $1 + $3;} // 1 + 1
	| OPERATION2 MINUS OPERATION2 { $$ = $1 - $3;} // 1 -1
	| OPERATION2 MULTIPLY OPERATION2 { $$ = $1 * $3;} // 1 * 1
	| OPERATION2 DIVIDE OPERATION2 { $$ = $1 / $3;} // 1 / 1
	//| LEFT OPERATION2 RIGHT { $$ = "Operacion aritmetica\n";} // operacion entre parentesis

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
	VAR_NAME BOOLEAN_OPERATORS VAR_NAME {$$="Operacion booleana variables\n";}
	| VAR_NAME BOOLEAN_OPERATORS INT {$$="Operacion booleana variable - numero\n";}
	| VAR_NAME BOOLEAN_OPERATORS STR {$$="Operacion booleana variable - string\n";}
	| VAR_NAME BOOLEAN_OPERATORS FLOAT {$$="Operacion booleana variable - float\n";}
	| INT BOOLEAN_OPERATORS INT {$$="Operacion booleana numero - numero\n";}
	| STR BOOLEAN_OPERATORS STR {$$="Operacion booleana string - string\n";}
	| FLOAT BOOLEAN_OPERATORS FLOAT {$$="Operacion booleana float - float\n";}
	| VAR_NAME EQUAL BOOLEAN_VAR {$$="Variable igual a True/False\n";}

;


%%
/*
void operacion_variables(struct TablaSimbolos *tabla, int *size, char *varname, char *type, char *varname2, char *type2,
                         char *varname3, char operation, int ival1, int ival2, float fval1, float fval2) {
    int index_1 = -1;
    int index_2 = -1;
    int val3 = 0;
    int val4 = 0;
    float val1 = 0;
    float val2 = 0;
    if ((strcmp(type, "var") == 0) && (strcmp(type2, "var") == 0)) {
        index_1 = buscarValor(tabla, varname, type, size);
        index_2 = buscarValor(tabla, varname2, type2, size);
    } else if ((strcmp(type, "var") == 0)) {
        index_1 = buscarValor(tabla, varname, type, size);
    } else if ((strcmp(type2, "var") == 0)) {
        index_2 = buscarValor(tabla, varname2, type2, size);
    }

    if (index_1 == -1 && ival1 != 0) {
        val3 = ival1;
    } else if (index_1 == -1 && fval1 != 0) {
        val1 = fval1;
    }
    if (index_2 == -1 && ival2 != 0) {
        val4 = ival2;
    } else if (index_2 == -1 && fval2 != 0) {
        val2 = fval2;
    }
    if (index_1 != -1 && index_2 != -1) {
        if (strcmp(tabla[index_1].tipo, "FLOAT") == 0 && strcmp(tabla[index_2].tipo, "FLOAT") == 0) {
            if (operation == '+') {
                float result = tabla[index_1].valor + tabla[index_2].valor;
                actualizarVariable(tabla, size, 0, result, varname3);
            } else if (operation == '-') {
                float result = tabla[index_1].valor - tabla[index_2].valor;
                actualizarVariable(tabla, size, 0, result, varname3);
            } else if (operation == '*') {
                float result = tabla[index_1].valor * tabla[index_2].valor;
                actualizarVariable(tabla, size, 0, result, varname3);
            } else if (operation == '/') {
                float result = tabla[index_1].valor / tabla[index_2].valor;
                actualizarVariable(tabla, size, 0, result, varname3);
            }
        } else if (strcmp(tabla[index_1].tipo, "INT") == 0 && strcmp(tabla[index_2].tipo, "INT") == 0) {
            if (operation == '+') {
                int result = tabla[index_1].valor + tabla[index_2].valor;
                actualizarVariable(tabla, size, result, 0, varname3);
            } else if (operation == '-') {
                int result = tabla[index_1].valor - tabla[index_2].valor;
                actualizarVariable(tabla, size, result, 0, varname3);
            } else if (operation == '*') {
                int result = tabla[index_1].valor * tabla[index_2].valor;
                actualizarVariable(tabla, size, result, 0, varname3);
            } else if (operation == '/') {
                int result = tabla[index_1].valor / tabla[index_2].valor;
                actualizarVariable(tabla, size, result, 0, varname3);
            }
        }
    }

}*/

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

	
	
