%{
int yylex();
%}
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define YYDEBUG 1

#define TYPE_INT 1
#define TYPE_STRING 2
#define TYPE_COMP 3
 int yylex(void);
 int yyerror(char* s);

%}


%union{
    int l_val;
    char *p_val;
}

%token MAIN
%token IF
%token ELSE
%token WHILE
%token FOR


%token ID
%token <p_val> NUMBER_CONST
%token <p_val> ZERO_CONST
%token STRING_CONST

%token INT
%token STRING
%token CHAR
%token FLOAT
%token BOOL

%token COUT
%token CIN
%right '='
%left '<'
%left '>'
%right 'ASSIG'
%left NE
%left GE
%left LE
%left '+' 
%left '-'
%left '*' 
%left '/'

%token '('
%token ')'
%token '{'
%token '}'
%token '['
%token ']'
%token ':'
%token ';'
%token '\''
%token ' '
%token '?'
%token '!'
%token '.'
%token '\n'

%left OR
%left AND

%token ATR
%token EQ
%%

program:    INT MAIN '(' ')' '{' code '}' 
    ;
code:       declaration_list
    |       statement 
    |       declaration code
    |       statement code
    ;

declaration:
        |  declvar
        ;  
declvar:   declvar
        |  arraydecl
        ;
declaration_list:   type declmulti ';'
	;
declmulti:   variable
	|    ID ',' declmulti
        ;
arraydecl :   type ID '[' NUMBER_CONST ']' ';'
        ;

type:       INT
        |   STRING
        |   BOOL
        |   FLOAT
        |   CHAR
        ;
statement: 
        |   stmt_atr ';'
        |   if_statement 
        |   while_statement
	|   for_statement
        |   input_statement ';'
        |   output_statement ';'
	|   stmt_atr ';' statement 
        |   if_statement statement 
        |   while_statement statement 
        |   input_statement ';' statement 
        |   output_statement ';' statement 
        ;
stmt_atr:   variable ATR expression
        ;
variable:   ID
        |   ID '[' expression ']'
        ;
expression: factor
        | expression '+' expression
        | expression '-' expression
        | expression '*' expression
        | expression '/' expression
        | expression '%' expression
        ;
factor:     ID
        |   constant
        |   '(' expression ')'
        |   ID '[' expression ']'
        ;
constant:   NUMBER_CONST
        |   ZERO_CONST
        |   STRING_CONST
        ;
if_statement:    IF '(' condition ')' '{' statement '}' else_branch
        ;
else_branch:
        |   ELSE '{' statement '}'
        ;
condition:  expr_log
        |   expression relation expression
        ;
expr_log:   factor_log
        |   expr_log AND expr_log
        |   expr_log OR expr_log
        ;
factor_log: '(' condition ')'
        ;
relation:     EQ
        |   '<'
        |   '>'
        |   NE
        |   LE
        |   GE
        ;
while_statement: WHILE '(' condition ')' '{' statement '}'
        
for_statement: FOR '(' stmt_atr ',' condition ',' stmt_atr ')' '{' statement '}'
        
output_statement: COUT '<''<' elem_list ';'
        ;
elem_list:  elem
        |   elem_list ',' elem
        ;
elem:       expression
        ;
input_statement:  CIN '>''>' id_list ';'
        ;
id_list:    ID
        |   id_list ',' ID
        ;
        
%%

int yyerror(char *s)
{
  printf("%s\n", s);
  return 0;
}

extern FILE *yyin;

int main(int argc, char **argv)
{
  if(argc>1) yyin = fopen(argv[1], "r");
  if((argc>2)&&(!strcmp(argv[2],"-d"))) yydebug = 1;
  if(!yyparse()) fprintf(stderr,"\tO.K.\n");
}





