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
     STRING = 260,
     PLUS = 261,
     MINUS = 262,
     MULTIPLY = 263,
     DIVIDE = 264,
     LEFT = 265,
     RIGHT = 266,
     OPEN = 267,
     CLOSE = 268,
     WHILE = 269,
     BOOL = 270,
     FOR = 271,
     CASE = 272,
     LESS = 273,
     MORE = 274,
     EQUAL = 275,
     GREATER_THAN = 276,
     LESSER_THAN = 277,
     NOT_EQUAL = 278,
     COMPARE = 279,
     COMMENT = 280,
     NEWLINE = 281,
     QUIT = 282,
     TRUE = 283,
     FALSE = 284
   };
#endif
/* Tokens.  */
#define INT 258
#define FLOAT 259
#define STRING 260
#define PLUS 261
#define MINUS 262
#define MULTIPLY 263
#define DIVIDE 264
#define LEFT 265
#define RIGHT 266
#define OPEN 267
#define CLOSE 268
#define WHILE 269
#define BOOL 270
#define FOR 271
#define CASE 272
#define LESS 273
#define MORE 274
#define EQUAL 275
#define GREATER_THAN 276
#define LESSER_THAN 277
#define NOT_EQUAL 278
#define COMPARE 279
#define COMMENT 280
#define NEWLINE 281
#define QUIT 282
#define TRUE 283
#define FALSE 284




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1685 of yacc.c  */
#line 14 "bison.y"

	int ival;
	float fval;
	char* sval;



/* Line 1685 of yacc.c  */
#line 117 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


