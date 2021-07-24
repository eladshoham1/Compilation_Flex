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

"<sport>"			{ return SPORT; }

"<years>"			{ return YEARS; }

"["[a-zA-Z]+[a-zA-Z ]*"]"	{ return NAME; }

[0-9]+				{ yylval.year = atoi(yytext); return YEAR_NUM; }

,				{ return COMMA; }

["through"-]			{ return THROUGH; }

since				{ return SINCE; }

all				{ return ALL; }	

[\t\n ]+			{ /* skip white space */ }
                
. 				{ fprintf (stderr, "line %d: unrecognized token %c (%x)\n",
                      			yylineno, yytext[0], yytext[0]); }

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

	while ((token = yylex()) != 0) {
		switch (token) {
			case TITLE: 	
				printf("TITLE: %s\n", yylval.title);
			      	break;
			case SPORT:
				printf ("SPORT: %s\n", yylval.name);
			      	break;
			case YEARS:
				printf ("YEARS\n");
			      	break;
			case NAME: 	
				printf("NAME\n");
			      	break;
			case YEAR_NUM:
				printf ("YEAR_NUM: %d\n", yylval.year);
			      	break;
			case COMMA:
				printf ("COMMA\n");
			      	break;
			case THROUGH: 	
				printf("THROUGH\n");
			      	break;
			case SINCE:
				printf ("SINCE\n");
			      	break;
			case ALL:
				printf ("ALL\n");
			      	break;
			default:
				fprintf (stderr, "error ... \n");
				exit(1);
		}
	}

	fclose(yyin);
	exit (0);
}

