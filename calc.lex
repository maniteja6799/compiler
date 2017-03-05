%{
#include <stdlib.h>
#include "y.tab.h"
#include "calc_include.h"

void yyerror(char *);
%}
%%

[a-z]		{
			yylval.sIndex = *yytext - 'a';
			return VARIABLE;
		}


[0-9]+ 		{
			yylval = atoi(yytext);
			return INTEGER;
		}

[-+()=/*><;{}.]	{ return *yytext; }

">="		return GE;
"<="		return LE;
"=="		return EQ;
"!="		return NE;
"while" 	return WHILE;
"if"		return IF;
"else"		return ELSE;
"print"		return PRINT;

[ \t\n]		/*skip*/;

. 		yyerror("invalid charechter");

%%
int yywrap(void) {
	return 1;
}
