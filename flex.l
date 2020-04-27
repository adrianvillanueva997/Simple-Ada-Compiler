%option noyywrap

%{
#include <stdio.h>
#include "y.tab.h"
// #include "bison.tab.h"

%}

word ([a-zA-Z])+
fnum ([0-9])+[\,|\.]([0-9])+
inum ([0-9])+
bool (bool|boolean)
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
{bool}  {return BOOL;}
{fnum}	{yylval.fval = atof(yytext); return FLOAT;}
{inum}	{yylval.ival = atoi(yytext); return INT;}
{word}  {yylval.sval = strdup(yytext); return STRING;}
\n		{return NEWLINE;}
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
"and"
%%