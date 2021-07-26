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

"Olympic Games"				{ return TITLE; }

"<sport>"				{ return SPORT; }

"<years>"				{ return YEARS; }

189[6-9]|19[0-9]{2}|[2-9][0-9]{3,}	{ yylval.year = atoi(yytext); yylval.year = yylval.year == 2020 ? 2021 : yylval.year; return YEAR_NUM; }

,					{ return COMMA; }

"through"|-				{ return THROUGH; }

"since"					{ return SINCE; }

"all"					{ return ALL; }

"["[A-Za-z]+(" "[A-Za-z]+)*"]"		{ strcpy(yylval.name, yytext+1); yylval.name[strlen(yylval.name)-1] = '\0'; return NAME; }

[ \t\n]+				{ /* skip white space */ }
                
. 					{ fprintf(stderr, "Line: %d unrecognized token %c (0x%x)\n", yylineno, yytext[0], yytext[0]); }			

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

