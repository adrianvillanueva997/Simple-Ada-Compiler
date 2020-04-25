%option noyywrap

%{
#include <stdio.h>
#include "y.tab.h"

%}

word ([a-zA-Z])+
fnum ([0-9])+[\,|\.]([0-9])+
inum ([0-9])+

bool (bool|boolean)
while (while|WHILE)
for (for|FOR)
case (case|CASE)

%%

[ \t]	; // ignore all whitespace
{fnum}	{yylval.fval = atof(yytext); return FLOAT;}
{inum}	{yylval.ival = atoi(yytext); return INT;}
{word}  {yylval.sval = strdup(yytext); return STRING;}
\n		{return NEWLINE;}
"boolean"  {return BOOLEAN;}
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
%%