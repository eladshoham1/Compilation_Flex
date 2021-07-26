%{
#include <string.h>

enum { TITLE = 500, SPORT, YEARS, NAME, YEAR_NUM, COMMA, THROUGH, SINCE, ALL }; 

union {
	char name[100];
	int year;
} yylval;
%}

%option noyywrap
%option yylineno

%%

"all"				{ return ALL; }

"since"				{ return SINCE; }

"<sport>"			{ return SPORT; }

"<years>"			{ return YEARS; }

,				{ return COMMA; }

"through"|-			{ return THROUGH; }

"["[a-zA-Z]+[a-zA-Z ]*"]"	{ strcpy(yylval.name, yytext); return NAME; }

[a-zA-Z]+[a-zA-Z ]*		{ return TITLE; }

189[6-9]|19[0-9]{2}|[2-9][0-9]{3,}	{ yylval.year = atoi(yytext); return YEAR_NUM; }

[\t\n ]+			{ /* skip white space */ }
                
. 				{ fprintf (stderr, "Line: %d unrecognized token %c (0x%x)\n", 						yylineno, yytext[0], yytext[0]); }			

%%

int main (int argc, char **argv)
{
	int token;
	extern FILE *yyin;

	if (argc != 2) {
		fprintf(stderr, "Usage: %s <input file name>\n", argv [0]);
		exit (1);
	}

	yyin = fopen (argv[1], "r");
	if (yyin == NULL) { 
		fprintf(stderr, "failed to open file %s\n", argv[1]);
		exit(1);
	}

	printf("%s\t\t%s\t\t%s\n", "TOKEN", "LEXEME", "SEMANTIC VALUE");
	printf("----------------------------------------------\n");
	while ((token = yylex()) != 0) {
		switch (token) {
			case TITLE: 	
				printf("TITLE\t\t%s\n", yytext);
				break;
			case SPORT:
				printf("SPORT\t\t%s\n", yytext);
			      	break;
			case YEARS:
				printf("YEARS\t\t%s\n", yytext);
			      	break;
			case NAME: 	
				printf("NAME\t\t%s\t%s\n", yytext, yylval.name);
			      	break;
			case YEAR_NUM:
				printf("YEAR_NUM\t%s\t\t%d\n", yytext, yylval.year);
			      	break;
			case COMMA:
				printf("COMMA\t\t%s\n", yytext);
			      	break;
			case THROUGH: 	
				printf("THROUGH\t\t%s\n", yytext);
			      	break;
			case SINCE:
				printf("SINCE\t\t%s\n", yytext);
			      	break;
			case ALL:
				printf("ALL\t\t%s\n", yytext);
			      	break;
			default:
				fprintf (stderr, "error ... \n");
				exit(1);
		}
	}

	fclose(yyin);
	exit (0);
}

