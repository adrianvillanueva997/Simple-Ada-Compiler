%option noyywrap

%{
#include <stdio.h>
#include "y.tab.h"
// #include "bison.tab.h"

%}

variable_name ([a-zA-Z])+([a-zA-Z]|[0-9]|[_])*
string (\".+\")
char (\".{1}\")
fnum ([0-9])+[\,|\.]([0-9])+
inum ([0-9])+
bool (bool|boolean)
int (integer)
stringd (String)
character (character)
float (float)
while (while|WHILE)
for (for|FOR)
case (case|CASE)
false (false|FALSE)
true (true|TRUE)
and (and|AND)
or (or|OR)


%%

[ \t]	; // ignore all whitespace
{true}  {return TRUE;} //funciona por algun motivo, hay que poner esto arriba del todo
{false} {return FALSE;}
{char}  {return CHAR;}
{bool}  {return BOOL;}
{int} {return INTEGERDEC;}
{float} {return FLOATDEC;}
{character} {return CHARDEC;}
{stringd} {return STRINGDEC;}
{fnum}	{yylval.fval = atof(yytext); return FLOAT;}
{inum}	{yylval.ival = atoi(yytext); return INT;}
{string}  {return STR;}
{variable_name}  {return VAR_NAME;}

\n		{return NEWLINE;}
":"		{return COLON;}
";"		{return SEMICOLON;}
"{"		{return OPEN;}
"}"		{return CLOSE;}
"+"		{return PLUS;}
"-"		{return MINUS;}
"*"		{return MULTIPLY;}
"/"		{return DIVIDE;}
"("		{return LEFT;}
")"		{return RIGHT;}
"<"		{return LESS;}
">"		{return MORE;}
"="		{return EQUAL;}
"--"	{return COMMENT;}
">="    {return GREATER_THAN;}
"<="    {return LESSER_THAN;}
"!="    {return NOT_EQUAL;}
"=="    {return COMPARE;}
%%