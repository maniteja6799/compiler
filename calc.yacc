%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <stdarg.h>
	#include "calc_include.h"
	//prototypes
	nodeType *opr(int oper, int nops, ...);
	nodeType *id(int i );
	nodeType *con(int value);
	void freeNode(nodeType p);
	int ec(nodeType *p);
	int yylex(void);
	void yyerror(char *);
	int sym[26];
%}

%union {
	int iValue;
	char sIndex;
	nodeType *nPtr;
}
%token <iValue> INTEGER
%token <sIndex> VARIABLE
%token WHILE IF PRINT
%nonassoc IFX
%nonassoc ELSE
%left GE LE EQ NE '>' '<'
%left '+' '-'
%left '*' '/'

%nonassoc UMINUS

%type <nPtr> stmt expr stmt_list

%%

program:
	function		{exit(0); }
	|
	;

function:
	function stmt 	{ex($2); freeNode($2);}
	|
	;

stmt:
	';'				{ $$ = opr(';',2, NULL, NULL); }
	| expr ';'		{ $$ = $1; }
	| PRINT expr ';'{ $$ = opr(PRINT, 1, $2); }
	| 
statement:
	expr			{ printf("%d\n", $1);}
	| VARIABLE '=' expr	{ sym[$1] = $3; }
	;

expr:
	INTEGER			{ $$ = $1; }
	| VARIABLE		{ $$ = sym[$1]; }
	| expr '+' expr 	{ $$ = $1 + $3; }
	| expr '-' expr 	{ $$ = $1 - $3; }
	| expr '*' expr		{ $$ = $1 * $3; }
	| expr '/' expr		{ $$ = $1 / $3; }
	| '(' expr ')'		{ $$ = $2; }
	;

%%

void yyerror(char *s) {
	fprintf(stderr, "error: %s\n", s);
}

int main(void) {
	yyparse();
	return 0;
}
