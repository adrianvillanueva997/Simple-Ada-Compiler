%option noyywrap

%{
#include <stdio.h>
#include "y.tab.h"

extern int line_num;

%}

variable_name ([a-zA-Z])+([a-zA-Z]|[0-9]|[_])*
dot ([\.])
proc (procedure|PROCEDURE)
is (is|IS)
end (end|END)
begin (begin|BEGIN)
string (\".+\")
char (\'.{1}\')
fnum ([0-9])+[\,|\.]([0-9])+
inum ([0-9])+
bool (bool|boolean)
else (else|ELSE)
elsif (elsif|ELSIF)
loop_ (loop|LOOP)
int (integer|Integer)
stringd (string|String)
character (Character|character)
float (Float|float)
linea (\n)
in (in|IN)
while (while|WHILE)
for (for|FOR)
case (case|CASE)
false (false|FALSE)
true (true|TRUE)
and (and|AND)
or (or|OR)
if (if|IF)
then (then|THEN)


%%
{dot}	{return DOT;}
{linea} {line_num += 1;}
[ \0]	; // ignore all null
{true}  {return TRUE;} //funciona por algun motivo, hay que poner esto arriba del todo
{end} 	{return END;}
{else} 	{return ELSE;}
{elsif} {return ELSIF;}
{begin}	{return BEG;}
{then}  {return THEN;}
{proc}  {return PROC;}
{in}   	{return IN;}
{is}  	{return IS;}
{for}  	{return FOR;}
{if}  	{return IF;}
{loop_}  {return LOOP_;}
{false} {return FALSE;}
{char}  {return CHAR;}
{bool}  {return BOOL;}
{and} 	{return AND;}
{or} 	{return OR;}
{int} 	{return INTEGERDEC;}
{float} {return FLOATDEC;}
{character} {return CHARDEC;}
{stringd} {return STRINGDEC;}
{fnum}	{yylval.fval = atof(yytext); return FLOAT;}
{inum}	{yylval.ival = atoi(yytext); return INT;}
{string}  {return STR;}
{variable_name}  {return VAR_NAME;}
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
">="    {return GREATER_THAN;}
"<="    {return LESSER_THAN;}
"!="    {return NOT_EQUAL;}
"--".*  {return COMMENT;}


%%