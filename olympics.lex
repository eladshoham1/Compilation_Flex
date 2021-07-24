%{
#include <string.h>

#define TITLE 500
#define SPORT 501
#define YEARS 502
#define NAME 503
#define YEAR_NUM 504
#define COMMA 505
#define THROUGH 506
#define SINCE 507
#define ALL 508

#define MAX_STR_LEN 100

union {
	char title[MAX_STR_LEN];
	char name[MAX_STR_LEN];
	int year;
} yylval;
%}

%option noyywrap
%option yylineno

%%

[a-zA-Z]+[a-zA-Z ]*		{ strcpy(yylval.title, yytext); return TITLE; }

\<sport\>			{ return SPORT; }

\<years\>			{ return YEARS; }

"["[a-zA-Z]+[a-zA-Z ]*"]"	{ strcpy(yylval.name, yytext); /*return NAME;*/ }

[0-9]+				{ yylval.year = atoi(yytext); /*return YEAR_NUM;*/ }

,				{ return COMMA; }

["through"-]			{ return THROUGH; }

"since"				{ return SINCE; }

"all"				{ return ALL; }

[\t\n ]+			{ /* skip white space */ }
                
. 				{ fprintf (stderr, "Line: %d unrecognized token %c (%x)\n", 						yylineno, yytext[0], yytext[0]); }			

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

	printf("%s\t\t\t%s\t\t\t%s\n", "TOKEN", "LEXEME", "SEMANTIC VALUE");
	printf("---------------------------------------------------------------\n");
	while ((token = yylex()) != 0) {
		switch (token) {
			case TITLE: 	
				printf("TITLE\t\t\t%s\t\t\t%s\n", yytext, yylval.title); 
				break;
			case SPORT:
				printf("SPORT\t\t\t%s\t\t\t%s\n", yytext, yylval.name);
			      	break;
			case YEARS:
				printf("YEARS\t\t\t%s\n", yytext);
			      	break;
			case NAME: 	
				printf("NAME\t\t\t%s\n", yytext);
			      	break;
			case YEAR_NUM:
				printf("YEAR_NUM\t\t\t%s\t\t\t%d\n", yytext, yylval.year);
			      	break;
			case COMMA:
				printf("COMMA\t\t\t%s\n", yytext);
			      	break;
			case THROUGH: 	
				printf("THROUGH\t\t\t%s\n", yytext);
			      	break;
			case SINCE:
				printf("SINCE\t\t\t%s\n", yytext);
			      	break;
			case ALL:
				printf("ALL\t\t\t%s\n", yytext);
			      	break;
			default:
				fprintf (stderr, "error ... \n");
				exit(1);
		}
	}

	fclose(yyin);
	exit (0);
}

