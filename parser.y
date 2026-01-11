%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* External functions from lexer */
extern int yylex();
extern int yylineno;
extern FILE *yyin;
extern char *yytext;

/* Function declarations */
void yyerror(const char *s);
int error_count = 0;
%}

/* Token declarations - ALL from Phase 1 scanner.l */

/* SaraikiScript Keywords (15 keywords) */
%token JE BIA JEIN_TAK WASTEY KAR WAPAS
%token TE YA KOH SACH KOOR
%token KAAM DAS VIKHA BUNIYAD

/* Data Types */
%token INT FLOAT CHAR STRING BOOL VOID

/* Identifiers and Literals */
%token IDENTIFIER INTEGER FLOAT_NUM STRING_LITERAL CHAR_LITERAL

/* Operators */
%token PLUS MINUS MULTIPLY DIVIDE MODULO
%token INCREMENT DECREMENT

/* Relational Operators */
%token EQ NEQ GT LT GTE LTE

/* Assignment */
%token ASSIGN

/* Stream Operators */
%token STREAM_IN STREAM_OUT

/* Punctuation */
%token SEMICOLON COMMA
%token LPAREN RPAREN
%token LBRACE RBRACE
%token LBRACKET RBRACKET

/* Comments (for documentation) */
%token COMMENT

/* Define the start symbol */
%start program

/* Operator precedence and associativity */
%left TE YA
%left EQ NEQ
%left GT LT GTE LTE
%left PLUS MINUS
%left MULTIPLY DIVIDE MODULO
%right KOH
%left INCREMENT DECREMENT

%%

/* ============================================
   GRAMMAR RULES FOR SARAIKISCRIPT
   ============================================ */

/* Program Structure */
program
    : function_list
        {
            if (error_count == 0) {
                printf("\n=================================================\n");
                printf("    ✓ Syntax Analysis Successful!\n");
                printf("    Program structure is valid.\n");
                printf("=================================================\n");
            }
        }
    ;

function_list
    : function_list function_def
    | function_list COMMENT
    | function_def
    | COMMENT
    ;

/* Function Definition */
function_def
    : KAAM BUNIYAD LPAREN RPAREN LBRACE stmt_list RBRACE
        { printf("Parsed: Main function\n"); }
    | KAAM IDENTIFIER LPAREN param_list RPAREN LBRACE stmt_list RBRACE
        { printf("Parsed: Function definition\n"); }
    | KAAM IDENTIFIER LPAREN RPAREN LBRACE stmt_list RBRACE
        { printf("Parsed: Function definition (no params)\n"); }
    ;

/* Parameter List */
param_list
    : param_list COMMA param
    | param
    ;

param
    : data_type IDENTIFIER
    ;

/* Statement List */
stmt_list
    : stmt_list stmt
    | stmt
    | /* empty */
    ;

/* Statement Types */
stmt
    : declaration_stmt
    | assignment_stmt
    | conditional_stmt
    | loop_stmt
    | io_stmt
    | return_stmt
    | function_call_stmt
    | increment_stmt
    | decrement_stmt
    | COMMENT
        { printf("Parsed: Comment\n"); }
    ;

/* Declaration Statement */
declaration_stmt
    : data_type IDENTIFIER SEMICOLON
        { printf("Parsed: Variable declaration\n"); }
    | data_type IDENTIFIER ASSIGN expression SEMICOLON
        { printf("Parsed: Variable declaration with initialization\n"); }
    ;

data_type
    : INT
    | FLOAT
    | CHAR
    | STRING
    | BOOL
    | VOID
    ;

/* Assignment Statement */
assignment_stmt
    : IDENTIFIER ASSIGN expression SEMICOLON
        { printf("Parsed: Assignment statement\n"); }
    ;

/* Conditional Statement */
conditional_stmt
    : JE LPAREN expression RPAREN LBRACE stmt_list RBRACE
        { printf("Parsed: If statement\n"); }
    | JE LPAREN expression RPAREN LBRACE stmt_list RBRACE BIA LBRACE stmt_list RBRACE
        { printf("Parsed: If-Else statement\n"); }
    ;

/* Loop Statements */
loop_stmt
    : while_loop
    | for_loop
    ;

while_loop
    : JEIN_TAK LPAREN expression RPAREN LBRACE stmt_list RBRACE
        { printf("Parsed: While loop\n"); }
    ;

for_loop
    : WASTEY LPAREN for_init SEMICOLON expression SEMICOLON for_update RPAREN LBRACE stmt_list RBRACE
        { printf("Parsed: For loop\n"); }
    ;

for_init
    : data_type IDENTIFIER ASSIGN expression
    | IDENTIFIER ASSIGN expression
    | /* empty */
    ;

for_update
    : IDENTIFIER ASSIGN expression
    | IDENTIFIER INCREMENT
    | IDENTIFIER DECREMENT
    | INCREMENT IDENTIFIER
    | DECREMENT IDENTIFIER
    | /* empty */
    ;

/* Input/Output Statements */
io_stmt
    : output_stmt
    | input_stmt
    ;

output_stmt
    : VIKHA STREAM_OUT expression SEMICOLON
        { printf("Parsed: Output statement\n"); }
    ;

input_stmt
    : DAS STREAM_IN IDENTIFIER SEMICOLON
        { printf("Parsed: Input statement\n"); }
    ;

/* Return Statement */
return_stmt
    : WAPAS SEMICOLON
        { printf("Parsed: Return statement (void)\n"); }
    | WAPAS expression SEMICOLON
        { printf("Parsed: Return statement\n"); }
    ;

/* Function Call Statement */
function_call_stmt
    : KAR IDENTIFIER LPAREN arg_list RPAREN SEMICOLON
        { printf("Parsed: Function call\n"); }
    | KAR IDENTIFIER LPAREN RPAREN SEMICOLON
        { printf("Parsed: Function call (no args)\n"); }
    ;

/* Argument List */
arg_list
    : arg_list COMMA expression
    | expression
    ;

/* Increment/Decrement Statements */
increment_stmt
    : IDENTIFIER INCREMENT SEMICOLON
        { printf("Parsed: Increment statement\n"); }
    ;

decrement_stmt
    : IDENTIFIER DECREMENT SEMICOLON
        { printf("Parsed: Decrement statement\n"); }
    ;

/* Expressions */
expression
    : logical_expr
    ;

logical_expr
    : logical_expr TE relational_expr
    | logical_expr YA relational_expr
    | KOH relational_expr
    | relational_expr
    ;

relational_expr
    : relational_expr relational_op arithmetic_expr
    | arithmetic_expr
    ;

relational_op
    : EQ
    | NEQ
    | GT
    | LT
    | GTE
    | LTE
    ;

arithmetic_expr
    : arithmetic_expr PLUS term
    | arithmetic_expr MINUS term
    | term
    ;

term
    : term MULTIPLY factor
    | term DIVIDE factor
    | term MODULO factor
    | factor
    ;

factor
    : LPAREN expression RPAREN
    | IDENTIFIER
    | INTEGER
    | FLOAT_NUM
    | STRING_LITERAL
    | CHAR_LITERAL
    | SACH
    | KOOR
    | IDENTIFIER INCREMENT
    | IDENTIFIER DECREMENT
    | INCREMENT IDENTIFIER
    | DECREMENT IDENTIFIER
    ;

%%

/* ============================================
   ERROR HANDLING AND MAIN FUNCTION
   ============================================ */

void yyerror(const char *s) {
    error_count++;
    fprintf(stderr, "\n Line %d: Syntax Error - %s\n", yylineno, s);
    fprintf(stderr, "   Found unexpected token: '%s'\n", yytext);
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <input_file.srk>\n", argv[0]);
        fprintf(stderr, "Example: %s test_program.srk\n", argv[0]);
        return 1;
    }
    
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        fprintf(stderr, "Error: Cannot open file '%s'\n", argv[1]);
        return 1;
    }
    
    printf("\n=================================================\n");
    printf("   SaraikiScript Parser - Phase 2\n");
    printf("   Parsing: %s\n", argv[1]);
    printf("=================================================\n\n");
    
    int result = yyparse();
    
    if (result != 0 || error_count > 0) {
        printf("\n=================================================\n");
        printf("     Syntax Analysis Failed!\n");
        printf("    Total errors: %d\n", error_count);
        printf("=================================================\n");
    }
    
    fclose(yyin);
    return result;
}
