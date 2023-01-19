%{
#include <stdio.h>
#include <stdlib.h>
#define YYDEBUG 1

#define TYPE_INT 1
#define TYPE_STRING 2
#define TYPE_COMP 3


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

program:    MAIN code 
    ;
code:       declstmt
    |       stmt
    |       declstmt code
    |       stmt code
    ;

declstmt:
        |  declvar
        ;  
declvar:   declsimpl
        |   declarr
        ;
declsimpl:   type declmulti ';'
	;
declmulti:   variable
	|    ID ',' declmulti
        ;
declarr:   type ID '[' NUMBER_CONST ']' ';'
        ;

type:       INT
        |   STRING
        |   BOOL
        |   FLOAT
        |   CHAR
        ;
stmt: 
        |   stmt_atr ';'
        |   stmt_if 
        |   stmt_while 
	|   stmt_for
        |   stmt_read ';'
        |   stmt_print ';'
	|   stmt_atr ';' stmt
        |   stmt_if stmt
        |   stmt_while stmt
        |   stmt_read ';' stmt
        |   stmt_print ';' stmt
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
stmt_if:    IF '(' condition ')' '{' stmt '}' else_branch
        ;
else_branch:
        |   ELSE '{' stmt '}'
        ;
condition:  expr_log
        |   expression op_rel expression
        ;
expr_log:   factor_log
        |   expr_log AND expr_log
        |   expr_log OR expr_log
        ;
factor_log: '(' condition ')'
        ;
op_rel:     EQ
        |   '<'
        |   '>'
        |   NE
        |   LE
        |   GE
        ;
stmt_while: WHILE '(' condition ')' '{' stmt '}'
        
stmt_for: FOR '(' stmt_atr ',' condition ',' stmt_atr ')' '{' stmt '}'
        
stmt_print: COUT '<<' elem_list ';'
        ;
elem_list:  elem
        |   elem_list ',' elem
        ;
elem:       expression
        ;
stmt_read:  CIN '>>' id_list ';'
        ;
id_list:    ID
        |   id_list ',' ID
        ;
        
%%

yyerror(char *s)
{
  printf("%s\n", s);
}

extern FILE *yyin;

int main(int argc, char **argv)
{
  if(argc>1) yyin = fopen(argv[1], "r");
  if((argc>2)&&(!strcmp(argv[2],"-d"))) yydebug = 1;
  if(!yyparse()) fprintf(stderr,"\tO.K.\n");
}





