%{

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <values.h>
#include "mips.c"

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern FILE *yyout;

//Declaraciones del AST

char* ast_text = "ast.txt";

struct ast {
 char* nodetype;
 struct ast *l;
 struct ast *r;
};

struct boo {
 char* nodetype;
 struct ast *l;
 struct ast *r;
};

struct flow {
	char* nodetype; /* type I or W */
	struct ast *cond; /* condition */
};

struct asign {
 	char* nodetype;
 	struct ast *as;
};

struct numval {
	char* nodetype;
	double number;
};

struct strval {
	char* nodetype;
	char* str;
};

//Declaraciones de la tabla de simbolos

struct symb{    
	char* vname;    
	int vvali;   
	float vvalf;
	char* vvals;
	char* type; 
};

//Declaraciones MIPS

struct MipsVariables mipsVariables[100];
struct MipsValores mipsValores[100];
char *filename_data = "data.txt";
char *filename_text = "text.txt";

//Variables globales
int line_num = 1;

int size = 52;

int elementosOcupados = 0;

int numnodo = 0;

struct ast nodos[52];

struct symb tabla[52];


//Inicialización de funciones

//Funciones de MIPS
                  

//Funciones tabla de simbolos
void insertarElemento(struct symb *tabla, int *size, int valor, char* svalor, float fvalor, char *variable, int *elementosOcupados, char* type );
void realizarOperacion(struct symb *tabla, int *size, int valor, int valor2, int valor3, float fvalor, float fvalor2, float fvalor3, char *variable, char *variable2, char *variable3,int *elementosOcupados, char* type , char* type2, char* type3, char* oper);
void inicializarArray(struct symb *tabla, int inicio, int fin);
int buscarValor(struct symb *tabla, char *nombre, char *tipo, int *size);


//Funciones AST
struct ast *createAST(char* nodetype, struct ast *l, struct ast *r);
struct ast *createBOO(char* nodetype, struct ast *l, struct ast *r);
struct ast *createFlow(struct ast *cond);
struct ast *createFlow2(struct ast *cond);
struct ast *createNum(double d);
struct ast *createSTR(char* s);
struct ast *createBOOVAR(char* s);
struct ast *createASG(struct ast *op);
void evalAST(struct ast a, int *size);
void printAST(struct ast nodos[], int i, int encontrado, int salida);

//Funciones auxiliares
void yyerror(const char* s);
void inicializarArray2(struct ast *nodos, int inicio, int fin);

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

%}

%union { 	
	int ival;
	float fval;
	char* sval;

	struct attributes{
	int i;
	float f;
	int i2;
	float f2;
	char* s;
	char *temp1;
	char *temp2;
	char *temp3;
	char* type;
	struct ast *a;
	struct asign *as;
	}st;
}

// %error-verbose

// TIPOS
%token<st> INT
%token<fval> FLOAT
%token<sval> VAR
%token<sval> STR
%token<sval> CHAR
%token<sval> PLUS
%token<sval> MINUS
%token<sval> MULTIPLY
%token<sval> DIVIDE
%token<sval> EQUAL
%token<sval> TRUE
%token<sval> FALSE


// TOKENS GENERALES
// parentesis/llaves
%token LEFT RIGHT OPEN CLOSE 

// palabras reservadas
%token ARR OF RET WHILE FUNC BOOL FOR CASE  AND OR PROC IS END BEG INTEGERDEC FLOATDEC CHARDEC STRINGDEC IF THEN DOT LOOP_ IN ELSE ELSIF  

// operadores logicos
%token LESS MORE GREATER_THAN LESSER_THAN NOT_EQUAL  

//simbolos reservados
%token COMMENT COLON SEMICOLON QUOTE 

//cosas de flex
%token NEWLINE 

// PRIORIDADES
%left PLUS MINUS
%left MULTIPLY DIVIDE

// TYPES DE BISON
%type<sval> PR
%type<st> OPERATION
%type<st> OPERATION2
%type<st> SOP
%type<st> DECL
%type<st> OPER
%type<st> BOOLEAN_OP
%type<st> IF_COND 
%type<sval> BOOLEAN_OPERATORS
// %type<sval> BOOLEAN_MIX
%type<st> BOOLEAN_VAR
%type<st> COM
%type<sval> BEGIN
%type<sval> FUNCDECL
%type<sval> DECTYPE
%type<st> VAR_NAME
%type<st> STMT
%type<st> WLOOP



%start calculation

%%

calculation:
	   | calculation line
;

line:
	STMT

;

STMT: 
	IF_COND {  printf("Linea %d ",line_num); printf("%s", $1.s);if(!$1.a){ ;} else {evalAST(*$1.a, &size);}}
	| PR { printf("Linea %d ",line_num); printf("%s", $1);}
	| WLOOP { printf("Linea %d ",line_num); printf("%s", $1.s);if(!$1.a){ ;} else {evalAST(*$1.a, &size);}}
	| DECL { printf("Linea %d ",line_num); printf("%s",$1.s); if(!$1.a){ ;} else {evalAST(*$1.a, &size);}}
	| FUNCDECL { printf("Linea %d ",line_num); printf("%s", $1);}
	| COM  { printf("Linea %d ",line_num); printf("%s",$1.s);}
	| error {yyerror; printf("Linea %d ",line_num); printf("Error en esta linea\n");}
	| BEGIN  { printf("Linea %d ",line_num); printf("%s",$1);}
;

	
DECL: VAR_NAME COLON INTEGERDEC SEMICOLON { $$.s = "Declaracion de integer\n";}
	| VAR_NAME COLON STRINGDEC SEMICOLON { $$.s = "Declaracion de string\n";}
	| VAR_NAME COLON FLOATDEC SEMICOLON { $$.s = "Declaracion de float\n";}
	| VAR_NAME COLON CHARDEC SEMICOLON { $$.s = "Declaracion de char\n";}
	| VAR_NAME COLON BOOL SEMICOLON {$$.s="Declaracion de boolean\n";}
	| VAR_NAME COLON ARR LEFT OPERATION DOT DOT OPERATION RIGHT OF DECTYPE SEMICOLON {$$.s="Declaracion de array\n";}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL VAR_NAME SEMICOLON {$$.s = "Declaracion de int y asignacion de variable \n"; $$.a = createASG($6.a);}

	| VAR_NAME COLON FLOATDEC COLON EQUAL VAR_NAME SEMICOLON {$$.s = "Declaracion de float y asignacion de variable \n"; $$.a = createASG($6.a);}

	| VAR_NAME COLON STRINGDEC COLON EQUAL VAR_NAME SEMICOLON {$$.s = "Declaracion de string y asignacion de variable \n"; $$.a = createASG($6.a);}

	| VAR_NAME COLON CHARDEC COLON EQUAL VAR_NAME SEMICOLON {$$.s = "Declaracion de char y asignacion de variable \n"; $$.a = createASG($6.a);}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL OPERATION SEMICOLON {$$.s = "Declaracion y asignacion de int\n" ;
	insertarElemento(tabla, &size, $6.i, "", 0.0, $1.s, &elementosOcupados, "integer" ); $$.a = createASG($6.a);
	mipsVar_insert_mips_variable_declaration(mipsVariables, "integer", $1.s,$6.i, NULL, -500,-500,filename_text);}

	| VAR_NAME COLON FLOATDEC COLON EQUAL OPERATION2 SEMICOLON {$$.s = "Declaracion y asignacion de float\n" ;
	insertarElemento(tabla, &size, 0, "", $6.f, $1.s, &elementosOcupados, "float" ); $$.a = createASG($6.a);
	mipsVar_insert_mips_variable_declaration(mipsVariables, "float", $1.s,-500, NULL, $6.f,-500,filename_text);}

	| VAR_NAME COLON EQUAL OPERATION SEMICOLON { $$.s = "Asignacion de int\n";
	insertarElemento(tabla, &size, $4.i, "", 0.0, $1.s, &elementosOcupados, "integer" ); $$.a = createASG($4.a); 
	mipsIns_asign_val_to_var(filename_text, mipsVariables, mipsValores,
                              $1.s, "integer", $4.i, -500);}
	
	| VAR_NAME COLON EQUAL OPERATION2 SEMICOLON { $$.s = "Asignacion de float\n";
	insertarElemento(tabla, &size, 0, "", $4.f, $1.s, &elementosOcupados, "float" ); $$.a = createASG($4.a);
	mipsIns_asign_val_to_var(filename_text, mipsVariables, mipsValores,
                              $1.s, "float", -500, $4.f);}	
	
	| VAR_NAME COLON STRINGDEC COLON EQUAL SOP SEMICOLON { $$.s = "Asignacion y declaracion de string\n";
	insertarElemento(tabla, &size, 0, $6.s, 0.0, $1.s, &elementosOcupados, "string" ); $$.a = createASG($6.a);}
	
	| VAR_NAME COLON EQUAL SOP SEMICOLON { $$.s = "Asignacion de string\n";
	insertarElemento(tabla, &size, 0, $4.s, 0.0, $1.s, &elementosOcupados, "string" ); $$.a = createASG($4.a);}
	
	| VAR_NAME COLON CHARDEC COLON EQUAL CHAR SEMICOLON { $$.s = "Asignacion y declaracion de char\n";
	insertarElemento(tabla, &size, 0, $6, 0.0, $1.s, &elementosOcupados, "string" );}
	
	| VAR_NAME COLON EQUAL CHAR SEMICOLON { $$.s = "Asignacion de char\n";
	insertarElemento(tabla, &size, 0, $4, 0.0, $1.s, &elementosOcupados, "string" );}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL VAR_NAME OPER OPERATION SEMICOLON {$$.s = "Declaracion y asignacion de operacion entre variable e int\n" ;}

	| VAR_NAME COLON EQUAL VAR_NAME OPER OPERATION SEMICOLON { $$.s = "Asignacion de de operacion entre variable e int\n" ;
	mipsIns_simpleOperations(mipsVariables, filename_text, *$5.s, $1.s,"integer", $6.i, -500);}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL VAR_NAME OPER OPERATION2 SEMICOLON {$$.s = "Declaracion y asignacion de operacion entre variable y float\n" ;}

	| VAR_NAME COLON EQUAL VAR_NAME OPER OPERATION2 SEMICOLON { $$.s = "Asignacion de operacion entre variable y float\n" ;
	mipsIns_simpleOperations(mipsVariables, filename_text, *$5.s, $1.s,"float", -500, $6.f);}

	| VAR_NAME COLON INTEGERDEC COLON EQUAL VAR_NAME OPER VAR_NAME SEMICOLON {$$.s = "Declaracion y asignacion de operacion entre variable y variable\n" ;}

	| VAR_NAME COLON EQUAL VAR_NAME OPER VAR_NAME SEMICOLON { $$.s = "Asignacion de operacion entre variable y variable\n" ;
	mipsIns_math_operations_ASG(mipsVariables, filename_text, *$5.s, $1.s,
                                 $4.s, $6.s);}
	
	| VAR_NAME COLON EQUAL BOOLEAN_VAR SEMICOLON {$$.s="Asignacion de boolean\n";}
	
;


DECTYPE:
	INTEGERDEC {$$ = "";}
	|STRINGDEC {$$ = "";}
	|FLOATDEC {$$ = "";}
	|CHARDEC {$$ = "";}
	|BOOL {$$ = "";}
;

FUNCDECL: 
	FUNC VAR_NAME LEFT VAR_NAME COLON DECTYPE RIGHT RET DECTYPE IS{$$ = "Funcion\n";}

;

OPER: PLUS {$$.s = "+";}
	| MINUS {$$.s = "-";}
	| DIVIDE {$$.s = "/";}
	| MULTIPLY {$$.s = "*";}
;



WLOOP:
	WHILE BOOLEAN_OP LOOP_ {$$.s = "Bucle while\n";

	if((strcmp($2.temp2, "") != 0) && (strcmp($2.temp3, "") != 0)){mipsIns_while_var_var(mipsVariables, filename_text, $2.temp2, $2.temp3, $2.temp1);}
	else if((strcmp($2.temp2, "") != 0) && (strcmp($2.temp3, "") == 0) && (strcmp($2.type, "integer") == 0)){mipsIns_while_var_num(mipsVariables, mipsValores, filename_text,$2.temp2,"integer" ,$2.i ,-500 ,$2.temp1);}
	else if((strcmp($2.temp2, "") != 0) && (strcmp($2.temp3, "") == 0) && (strcmp($2.type, "float") == 0)){mipsIns_while_var_num(mipsVariables, mipsValores, filename_text,$2.temp2,"float" ,-500 ,$2.f ,$2.temp1);}
	if(!$2.a){ ;} else {$$.a = createFlow2($2.a);}
	}
	| END LOOP_ SEMICOLON {$$.s="Fin de bucle\n";mipsIns_endWhile(filename_text);}
;

COM:
	COMMENT {$$.s = "Comentario\n";}

;

VAR_NAME:
	VAR {$$.s = $1; $$.a = createSTR($1);}
;



BEGIN:
	BEG {$$ = "Begin\n";}
	| END SEMICOLON {$$ = "End begin\n";}

PR:
	PROC VAR_NAME IS {$$ = "Procedure\n";}
	| END VAR_NAME SEMICOLON {$$ = "Fin de procedure/funcion\n";}
;

IF_COND: 
	
	IF BOOLEAN_OP THEN {$$.s = "Sentencia IF\n"; 
	if((strcmp($2.temp2, "") != 0) && (strcmp($2.temp3, "") != 0)){mipsIns_if_var_var(mipsVariables,filename_text,$2.temp1,$2.temp2,$2.temp3);}
	else if((strcmp($2.temp2, "") != 0) && (strcmp($2.temp3, "") == 0) && (strcmp($2.type, "integer") == 0)){mipsIns_if_var_num(mipsVariables, mipsValores, filename_text,$2.temp1, $2.temp2, "integer", $2.i, -500);}
	else if((strcmp($2.temp2, "") != 0) && (strcmp($2.temp3, "") == 0) && (strcmp($2.type, "float") == 0)){mipsIns_if_var_num(mipsVariables, mipsValores, filename_text,$2.temp1, $2.temp2, "float", -500, $2.f);}
	if(!$2.a){ ;} else {$$.a = createFlow($2.a);}}

	| END IF SEMICOLON {$$.s = "End IF\n"; mipsIns_endIf(filename_text);}
	| ELSE {$$.s = "Else\n";}
	| ELSIF BOOLEAN_OP THEN {$$.s = "Elsif\n";}
;


// Operaciones aritmeticas con int 
OPERATION: INT {$$.i = $1.i; $$.a = createNum($1.i);}
	| OPERATION PLUS OPERATION {$$.i = $1.i + $3.i; $$.a = createAST($2,$1.a,$3.a);} // 1 + 1
	| OPERATION MINUS OPERATION { $$.i = $1.i - $3.i; $$.a = createAST($2,$1.a,$3.a);} // 1 -1
	| OPERATION MULTIPLY OPERATION { $$.i = $1.i * $3.i; $$.a = createAST($2,$1.a,$3.a);} // 1 * 1
	| OPERATION DIVIDE OPERATION { $$.i = $1.i / $3.i; $$.a = createAST($2,$1.a,$3.a);} // 1 / 1
	//| LEFT OPERATION RIGHT { $$.i = "Operacion aritmetica\n";} // operacion entre parentesis

;
// Operaciones aritmeticas con float
OPERATION2: FLOAT {$$.f = $1; $$.a = createNum($1);}
	| OPERATION2 PLUS OPERATION2 {$$.f = $1.f + $3.f; $$.a = createAST($2,$1.a,$3.a);} // 1 + 1
	| OPERATION2 MINUS OPERATION2 { $$.f = $1.f - $3.f; $$.a = createAST($2,$1.a,$3.a);} // 1 -1
	| OPERATION2 MULTIPLY OPERATION2 { $$.f = $1.f * $3.f; $$.a = createAST($2,$1.a,$3.a);} // 1 * 1
	| OPERATION2 DIVIDE OPERATION2 { $$.f = $1.f / $3.f; $$.a = createAST($2,$1.a,$3.a);} // 1 / 1
	//| LEFT OPERATION2 RIGHT { $$.f = "Operacion aritmetica\n";} // operacion entre parentesis

;

SOP: STR {$$.s = $1; $$.a = createSTR($1);}

;

// Expresiones booleanas
BOOLEAN_OPERATORS:
	EQUAL {$$ = "=";}
	| MORE {$$=">";}
	| LESS {$$= "<";}
	| GREATER_THAN {$$=">=";}
	| LESSER_THAN {$$="<=";}
	| NOT_EQUAL {$$="!=";}

;

// VARIABLES BOOLEANAS
BOOLEAN_VAR:
	TRUE {$$.s="True\n"; $$.a = createBOOVAR($1);}
	| FALSE {$$.s="False\n"; $$.a = createBOOVAR($1);}

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
	VAR_NAME BOOLEAN_OPERATORS VAR_NAME {$$.s="Operacion booleana variables\n"; $$.a = createBOO($2,$1.a,$3.a); $$.temp1 = $2; $$.temp2 = $1.s; $$.temp3 = $3.s;}
	| VAR_NAME BOOLEAN_OPERATORS OPERATION {$$.s="Operacion booleana variable - numero\n"; $$.a = createBOO($2,$1.a,$3.a); $$.temp1 = $2; $$.temp2 = $1.s; $$.temp3 = ""; $$.i = $3.i; $$.type = "integer"; }
	| VAR_NAME BOOLEAN_OPERATORS SOP {$$.s="Operacion booleana variable - string\n"; $$.a = createBOO($2,$1.a,$3.a); $$.temp1 = $2; $$.temp2 = $1.s;}
	| VAR_NAME BOOLEAN_OPERATORS OPERATION2 {$$.s="Operacion booleana variable - float\n"; $$.a = createBOO($2,$1.a,$3.a);$$.temp1 = $2;$$.temp2 = $1.s;
	$$.temp3 = "";$$.f = $3.f; $$.type = "float";}
	| SOP BOOLEAN_OPERATORS SOP {$$.s="Operacion booleana string - string\n"; $$.a = createBOO($2,$1.a,$3.a);$$.temp1 = $2;}
	| VAR_NAME EQUAL BOOLEAN_VAR {$$.s="Variable igual a True/False\n"; $$.a = createBOO($2,$1.a,$3.a);}

;

//----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

%%

void inicializarArray(struct symb *tabla, int inicio, int fin) {
    for (int i = inicio; i < fin; i++) {
        tabla[i].vname = "._empty";
    }
}

void inicializarArray2(struct ast *nodos, int inicio, int fin) {
    for (int i = inicio; i < fin; i++) {
        nodos[i].nodetype = "._empty";
    }
}

//FUNCIONES DE LA TABLA DE SIMBOLOS

int buscarValor(struct symb *tabla, char *nombre, char *tipo, int *size) {
    int i = 0;
    int status = -1;
    while (i < *size && status == -1) {
        if (strcmp(tabla[i].vname, nombre) == 0 && (strcmp(tabla[i].type, tipo) == 0 )) {
            status = i;
        }else if(strcmp(tabla[i].vname, nombre) == 0){ 
        	status = i;
        }else {
            i++;
        }
    }
    return status;
}

void realizarOperacion(struct symb *tabla, int *size, int valor, int valor2, int valor3, float fvalor, float fvalor2, float fvalor3, char *variable, char *variable2, char *variable3,int *elementosOcupados, char* type , char* type2, char* type3, char* oper){

	
	int status1 = buscarValor(tabla, variable, type, size);
	int status2 = buscarValor(tabla, variable2, type2, size);
	int status3 = buscarValor(tabla, variable3, type3, size);

	printf("%i",status1);
	printf("patata");

    if((status1 != -1) && (status2 != -1)){
    	if((strcmp(type, type2) == 0) && (strcmp(type, type3) == 0) && (strcmp(type,"integer") == 0)){
	    	valor = tabla[status1].vvali;
	    	valor2 = tabla[status2].vvali;    	
    		if(strcmp(oper, "+") == 0){
    			valor3 = valor + valor2;
    		}else if(strcmp(oper, "-") == 0){
    			valor3 = valor - valor2;
    		}else if(strcmp(oper, "*") == 0){
    			valor3 = valor * valor2;
    		}else if(strcmp(oper, "/") == 0){
    			valor3 = valor / valor2;
    		}
    		insertarElemento(tabla,size,valor3,"",0.0,variable3,elementosOcupados,type3 ); 	
    	}else if((strcmp(type, type2) == 0) && (strcmp(type,"integer") == 0)){
    		valor = tabla[status1].vvali;
	    	valor2 = tabla[status2].vvali;    	
    		if(strcmp(oper, "+") == 0){
    			valor3 = valor + valor2;
    		}else if(strcmp(oper, "-") == 0){
    			valor3 = valor - valor2;
    		}else if(strcmp(oper, "*") == 0){
    			valor3 = valor * valor2;
    		}else if(strcmp(oper, "/") == 0){
    			valor3 = valor / valor2;
    		}
    		insertarElemento(tabla,size,valor3,"",0.0,variable3,elementosOcupados,"integer" );
    	}else if((strcmp(type, type2) == 0) && (strcmp(type, type3) == 0) && (strcmp(type,"float") == 0)){
	    	fvalor = tabla[status1].vvalf;
	    	fvalor2 = tabla[status2].vvalf;      		
    		if(strcmp(oper, "+") == 0){
    			fvalor3 = fvalor + fvalor2;
    		}else if(strcmp(oper, "-") == 0){
    			fvalor3 = fvalor - fvalor2;
    		}else if(strcmp(oper, "*") == 0){
    			fvalor3 = fvalor * fvalor2;
    		}else if(strcmp(oper, "/") == 0){
    			fvalor3 = fvalor / fvalor2;
    		}
    		insertarElemento(tabla,size,0,"",fvalor3,variable3,elementosOcupados,type3); 	    	
    	}else if((strcmp(type, type2) == 0) && (strcmp(type,"float") == 0)){
	    	fvalor = tabla[status1].vvalf;
	    	fvalor2 = tabla[status2].vvalf;      		
    		if(strcmp(oper, "+") == 0){
    			fvalor3 = fvalor + fvalor2;
    		}else if(strcmp(oper, "-") == 0){
    			fvalor3 = fvalor - fvalor2;
    		}else if(strcmp(oper, "*") == 0){
    			fvalor3 = fvalor * fvalor2;
    		}else if(strcmp(oper, "/") == 0){
    			fvalor3 = fvalor / fvalor2;
    		}
    		insertarElemento(tabla,size,0,"",fvalor3,variable3,elementosOcupados,"float"); 

    	}else{
    		printf("La operacion realizada no es válida");
    	}
    }else if((status1 != -1) && (status2 = -1)){
    	valor = tabla[status1].vvali;

    	if((strcmp(type, type2) == 0) &&  (strcmp(type, type3) == 0) && (strcmp(type,"integer") == 0)){
    		if(strcmp(oper, "+") == 0){
    			valor3 = valor + valor2;
    		}else if(strcmp(oper, "-") == 0){
    			valor3 = valor - valor2;
    		}else if(strcmp(oper, "*") == 0){
    			valor3 = valor * valor2;
    		}else if(strcmp(oper, "/") == 0){
    			valor3 = valor / valor2;
    		}
    		insertarElemento(tabla,size,valor3,"",0.0,variable3,elementosOcupados,type3); 	
    	}else if((strcmp(type, type2) == 0) && (strcmp(type,"integer") == 0)){
    		if(strcmp(oper, "+") == 0){
    			valor3 = valor + valor2;
    		}else if(strcmp(oper, "-") == 0){
    			valor3 = valor - valor2;
    		}else if(strcmp(oper, "*") == 0){
    			valor3 = valor * valor2;
    		}else if(strcmp(oper, "/") == 0){
    			valor3 = valor / valor2;
    		}
    		insertarElemento(tabla,size,valor3,"",0.0,variable3,elementosOcupados,"integer"); 	

    	}else if((strcmp(type, type2) == 0) &&  (strcmp(type, type3) == 0) && (strcmp(type,"float") == 0)){
	    	fvalor = tabla[status1].vvalf;     		
    		if(strcmp(oper, "+") == 0){
    			fvalor3 = fvalor + fvalor2;
    		}else if(strcmp(oper, "-") == 0){
    			fvalor3 = fvalor - fvalor2;
    		}else if(strcmp(oper, "*") == 0){
    			fvalor3 = fvalor * fvalor2;
    		}else if(strcmp(oper, "/") == 0){
    			fvalor3 = fvalor / fvalor2;
    		}    	
    		insertarElemento(tabla,size,0,"",fvalor3,variable3,elementosOcupados,type3); 

    	}else if((strcmp(type, type2) == 0) && (strcmp(type,"float") == 0)){
	    	fvalor = tabla[status1].vvalf;     		
    		if(strcmp(oper, "+") == 0){
    			fvalor3 = fvalor + fvalor2;
    		}else if(strcmp(oper, "-") == 0){
    			fvalor3 = fvalor - fvalor2;
    		}else if(strcmp(oper, "*") == 0){
    			fvalor3 = fvalor * fvalor2;
    		}else if(strcmp(oper, "/") == 0){
    			fvalor3 = fvalor / fvalor2;
    		}    	
    		insertarElemento(tabla,size,0,"",fvalor3,variable3,elementosOcupados,"float"); 

    	}else{
    		printf("La operacion realizada no es válida");
    	}
    }else if((status1 = -1) && (status2 = -1)){
    	if((strcmp(type, type2) == 0) &&  (strcmp(type, type3) == 0) && (strcmp(type,"integer") == 0)){
    		if(strcmp(oper, "+") == 0){
    			valor3 = valor + valor2;
    		}else if(strcmp(oper, "-") == 0){
    			valor3 = valor - valor2;
    		}else if(strcmp(oper, "*") == 0){
    			valor3 = valor * valor2;
    		}else if(strcmp(oper, "/") == 0){
    			valor3 = valor / valor2;
    		}
    		insertarElemento(tabla,size,valor3,"",0.0,variable3,elementosOcupados,type3); 
    	}else if((strcmp(type, type2) == 0) &&  (strcmp(type, type3) == 0) && (strcmp(type,"integer") == 0)){
    		if(strcmp(oper, "+") == 0){
    			valor3 = valor + valor2;
    		}else if(strcmp(oper, "-") == 0){
    			valor3 = valor - valor2;
    		}else if(strcmp(oper, "*") == 0){
    			valor3 = valor * valor2;
    		}else if(strcmp(oper, "/") == 0){
    			valor3 = valor / valor2;
    		}
    		insertarElemento(tabla,size,valor3,"",0.0,variable3,elementosOcupados,"integer"); 

    	}else if((strcmp(type, type2) == 0) &&  (strcmp(type, type3) == 0) && (strcmp(type,"float") == 0)){
	    	fvalor = tabla[status1].vvalf;     		
    		if(strcmp(oper, "+") == 0){
    			fvalor3 = fvalor + fvalor2;
    		}else if(strcmp(oper, "-") == 0){
    			fvalor3 = fvalor - fvalor2;
    		}else if(strcmp(oper, "*") == 0){
    			fvalor3 = fvalor * fvalor2;
    		}else if(strcmp(oper, "/") == 0){
    			fvalor3 = fvalor / fvalor2;
    		}    	
    		insertarElemento(tabla,size,0,"",fvalor3,variable3,elementosOcupados,type3);
    	}else if((strcmp(type, type2) == 0) &&  (strcmp(type, type3) == 0) && (strcmp(type,"float") == 0)){
	    	fvalor = tabla[status1].vvalf;     		
    		if(strcmp(oper, "+") == 0){
    			fvalor3 = fvalor + fvalor2;
    		}else if(strcmp(oper, "-") == 0){
    			fvalor3 = fvalor - fvalor2;
    		}else if(strcmp(oper, "*") == 0){
    			fvalor3 = fvalor * fvalor2;
    		}else if(strcmp(oper, "/") == 0){
    			fvalor3 = fvalor / fvalor2;
    		}    	
    		insertarElemento(tabla,size,0,"",fvalor3,variable3,elementosOcupados,"float");

    	}else{
    		printf("La operacion realizada no es válida");
    	}
    }


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

//FUNCIONES DEL AST

struct ast *createFlow(struct ast *cond){

struct flow *a = malloc(sizeof(struct flow));

if(!a) {
yyerror("out of space");
exit(0);
}

a->nodetype = "IF";
a->cond = cond;

return (struct ast *)a;
}

struct ast *createFlow2(struct ast *cond){

struct flow *a = malloc(sizeof(struct flow));

if(!a) {
yyerror("out of space");
exit(0);
}

a->nodetype = "WHILE";
a->cond = cond;

return (struct ast *)a;
}

struct ast *createASG(struct ast *op){

	struct asign *a = malloc(sizeof(struct asign));
	if(!a) {
		yyerror("out of space");
		exit(0);
	}
	a->nodetype = "=";
	a->as = op;

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

struct ast *createBOO(char* nodetype, struct ast *l, struct ast *r) {

 struct boo *a = malloc(sizeof(struct boo));

 if(!a) {
 yyerror("out of space");
 exit(0);
 }
 a->nodetype = nodetype;
 a->l = l;
 a->r = r;
 return (struct ast *)a;
}

struct ast *createNum(double d)
{
 	struct numval *a = malloc(sizeof(struct numval));
  	if(!a) {
 		yyerror("out of space");
 		exit(0);
 	}
 	a->nodetype = "Constante";
 	a->number = d;
 	return (struct ast *)a;
}

struct ast *createSTR(char* s)
{
 	struct strval *a = malloc(sizeof(struct strval));
  	if(!a) {
 		yyerror("out of space");
 		exit(0);
 	}
 	a->nodetype = "String";
 	a->str = s;
 	return (struct ast *)a;
}

struct ast *createBOOVAR(char* s)
{
 	struct strval *a = malloc(sizeof(struct strval));
  	if(!a) {
 		yyerror("out of space");
 		exit(0);
 	}
 	a->nodetype = "Boolean_var";
 	a->str = s;
 	return (struct ast *)a;
}

void evalAST(struct ast a, int *size){
	
	int i = 0;
	int encontrado = 0;
	while (i < *size && encontrado == 0){

		if((strcmp(nodos[i].nodetype, "._empty") == 0) && (strcmp(a.nodetype, "String") != 0) && (strcmp(a.nodetype, "Constante") != 0) ){
			nodos[i] = a;
			numnodo = numnodo +1;
			encontrado = 1;
		}else{
			i++;
		}
	}
}



void printAST(struct ast nodos[], int i, int encontrado, int salida){
	struct ast temp[52];
	inicializarArray2(temp,0,52);

	while(encontrado == 0 && salida == 0){
		if(strcmp(nodos[i].nodetype, "._empty") == 0){
			encontrado = 1;
			salida=1;
		}else{
			if(strcmp(nodos[i].nodetype, "IF") == 0){
				write_file(ast_text, "\n");
				write_file(ast_text, nodos[i].nodetype);
				write_file(ast_text, "\n");
				temp[0] = *nodos[i].l;
				printAST(temp,0,0,0);

			}else if(strcmp(nodos[i].nodetype, "WHILE") == 0){
					write_file(ast_text, "\n");
					write_file(ast_text, nodos[i].nodetype);
					write_file(ast_text, "\n");
					temp[0] = *nodos[i].l;
					printAST(temp,0,0,0);

			}else if((strcmp(nodos[i].nodetype, ">") == 0) || (strcmp(nodos[i].nodetype, "<") == 0) || (strcmp(nodos[i].nodetype, ">=") == 0) ||
						 (strcmp(nodos[i].nodetype, "<=") == 0) ||  (strcmp(nodos[i].nodetype, "!=") == 0) || (strcmp(nodos[i].nodetype, "==") == 0)){

				write_file(ast_text, nodos[i].nodetype);
				write_file(ast_text, "\n");
				temp[0] = *nodos[i].l; 
				printAST(temp,0,0,0);
				write_file(ast_text, "\n");
				temp[0] = *nodos[i].r; 
				printAST(temp,0,0,0);
				write_file(ast_text, "\n");
				salida = 1;
				

			}else if(strcmp(nodos[i].nodetype, "=") == 0){
				write_file(ast_text, "\n");
				write_file(ast_text, nodos[i].nodetype);
				write_file(ast_text, "\n");
				if((strcmp(nodos[i].l->nodetype, "+") == 0)||(strcmp(nodos[i].l->nodetype, "-") == 0)||(strcmp(nodos[i].l->nodetype, "/") == 0)||
				(strcmp(nodos[i].l->nodetype, "*") == 0)){

					temp[0] = *nodos[i].l;
					printAST(temp,0,0,0);


				}else{
					temp[0] = *nodos[i].l; 
					printAST(temp,0,0,0);

				}


			}else if((strcmp(nodos[i].nodetype, "+") == 0)||(strcmp(nodos[i].nodetype, "-") == 0)||(strcmp(nodos[i].nodetype, "/") == 0)||
				(strcmp(nodos[i].nodetype, "*") == 0)){

				write_file(ast_text, nodos[i].nodetype);
				write_file(ast_text, "\n");
				temp[0] = *nodos[i].l;
				printAST(temp,0,0,0);
				write_file(ast_text, "\n");
				temp[0] = *nodos[i].r;
				printAST(temp,0,0,0);
				write_file(ast_text, "\n");

			}else if(strcmp(nodos[i].nodetype, "String") == 0){

				write_file(ast_text, nodos[i].nodetype);
				write_file(ast_text, "\n");
				salida = 1;

			}else if(strcmp(nodos[i].nodetype, "Constante") == 0){
				write_file(ast_text, nodos[i].nodetype);
				write_file(ast_text, "\n");
				salida = 1;
				encontrado = 1;
			}			

		}
		i++;

	}


}

// FUNCIONES DE MIPS


int main(int argc, char *argv[]) {
		clear_file(filename_data);
	    clear_file(filename_text);
	    clear_file(ast_text);
	    clear_file("mips.txt");
	    mipsVar_create_data(filename_data);
		mipsIns_create_text(filename_text); 
	    mipsVar_initialize_struct(mipsVariables);
	    mipsVar_initialize_valorStruct(mipsValores);
	
                                            
		inicializarArray(tabla, 0, size);
		inicializarArray2(nodos, 0, size);
		if (argc == 1) {

             yyparse();

		}

		if (argc == 2) {
             yyin = fopen(argv[1], "rt");
             yyout = fopen(argv[2], "wt" );

             yyparse();

		}

		printf("\nTabla de simbolos:");
		for(int b = 0; b < 52; b++){
			printf("\n");		
			printf("Nombre %s ",tabla[b].vname);
			printf("INT %i ",tabla[b].vvali);
			printf("FLOAT %f ",tabla[b].vvalf);
			printf("STRING %s ",tabla[b].vvals);
			printf("TIPO %s ",tabla[b].type);
			printf("\n");
		}		

		printAST(nodos,0,0,0);

		mipsVar_write_declarations(mipsVariables, filename_data);

}	


void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
}

	
	
