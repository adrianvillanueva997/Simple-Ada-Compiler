/* A Bison parser, made by GNU Bison 2.4.2.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989-1990, 2000-2006, 2009-2010 Free Software
   Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     INT = 258,
     FLOAT = 259,
     PLUS = 260,
     MINUS = 261,
     MULTIPLY = 262,
     DIVIDE = 263,
     LEFT = 264,
     RIGHT = 265,
     OPEN = 266,
     CLOSE = 267,
     WHILE = 268,
     BOOL = 269,
     FOR = 270,
     CASE = 271,
     STR = 272,
     VAR_NAME = 273,
     CHAR = 274,
     AND = 275,
     OR = 276,
     PROC = 277,
     IS = 278,
     END = 279,
     BEG = 280,
     INTEGERDEC = 281,
     FLOATDEC = 282,
     CHARDEC = 283,
     STRINGDEC = 284,
     IF = 285,
     THEN = 286,
     DOT = 287,
     LOOP_ = 288,
     LESS = 289,
     MORE = 290,
     EQUAL = 291,
     GREATER_THAN = 292,
     LESSER_THAN = 293,
     NOT_EQUAL = 294,
     COMPARE = 295,
     COMMENT = 296,
     COLON = 297,
     SEMICOLON = 298,
     QUOTE = 299,
     NEWLINE = 300,
     QUIT = 301,
     TRUE = 302,
     FALSE = 303
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1685 of yacc.c  */
#line 15 "bison.y"

	int ival;
	float fval;
	char* sval;



/* Line 1685 of yacc.c  */
#line 107 "bison.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


