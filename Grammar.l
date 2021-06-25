D			[0-9]
L			[a-zA-Z_]


%{
#include <stdio.h>
#include ".tab.h"
void count();
%}

%%
"int"			{ count(); return(INT); }
"char"		{ count(); return(CHAR); }
"if"			{ count(); return(IF); }
"while"		{ count(); return(WHILE); }

{L}({L}|{D})*		{ count(); return(check_type()); }
L?'(\\.|[^\\'])+'	{ count(); return(CONSTANT); }

"+"			{ count(); return('+'); }
"-"			{ count(); return('-'); }
"*"			{ count(); return('*'); }
"/"			{ count(); return('/'); }

"="			{ count(); return('='); }

"=="		{ count(); return(EQ_OP); }
"<"			{ count(); return('<'); }
">"			{ count(); return('>'); }

"!="		{ count(); return(NE_OP); }
";"			{ count(); return(';'); }
"{"			{ count(); return('{'); }
"}"			{ count(); return('}'); }
","			{ count(); return(','); }
"("			{ count(); return('('); }
")"			{ count(); return(')'); }
"["			{ count(); return('['); }
"]"			{ count(); return(']'); }

[ \t\v\n\f]		{ count(); }
.			{ /* ignore bad characters */ }

%%

yywrap()
{
	return(1);
}


comment()
{
char c, c1;
loop:
	while ((c = input()) != '*' && c != 0)
		putchar(c);

	if ((c1 = input()) != '/' && c != 0)
	{
		unput(c1);
		goto loop;
	}

	if (c != 0)
		putchar(c1);
}


int column = 0;

void count()
{
	int i;

	for (i = 0; yytext[i] != '\0'; i++)
		if (yytext[i] == '\n')
			column = 0;
		else if (yytext[i] == '\t')
			column += 8 - (column % 8);
		else
			column++;

	ECHO;
}


int check_type()
{
	return(IDENTIFIER);
}
