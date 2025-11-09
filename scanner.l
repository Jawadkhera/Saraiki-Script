%{

#include <stdio.h>
#include <string.h>

int line_number = 1;
int token_count = 0;

void print_token(const char* token_type, const char* lexeme) {
    token_count++;
    printf("Line %d: %s → %s\n", line_number, token_type, lexeme);
}

%}

/* Regular Expression Definitions */
DIGIT       [0-9]
LETTER      [a-zA-Z]
IDENTIFIER  {LETTER}({LETTER}|{DIGIT}|_)*
INTEGER     {DIGIT}+
FLOAT       {DIGIT}+\.{DIGIT}+
WHITESPACE  [ \t]+
NEWLINE     \n

%%

    /* Keywords */
"je"            { print_token("KEYWORD", yytext); }
"bia"           { print_token("KEYWORD", yytext); }
"jein_tak"      { print_token("KEYWORD", yytext); }
"wastey"        { print_token("KEYWORD", yytext); }
"kar"           { print_token("KEYWORD", yytext); }
"wapas"         { print_token("KEYWORD", yytext); }
"te"            { print_token("KEYWORD", yytext); }
"ya"            { print_token("KEYWORD", yytext); }
"koh"           { print_token("KEYWORD", yytext); }
"sach"          { print_token("KEYWORD", yytext); }
"Koor"          { print_token("KEYWORD", yytext); }
"kaam"          { print_token("KEYWORD", yytext); }
"das"           { print_token("KEYWORD", yytext); }
"vikha"         { print_token("KEYWORD", yytext); }
"buniyad"       { print_token("KEYWORD", yytext); }

    /* Data Types */
"int"           { print_token("DATA_TYPE", yytext); }
"float"         { print_token("DATA_TYPE", yytext); }
"char"          { print_token("DATA_TYPE", yytext); }
"string"        { print_token("DATA_TYPE", yytext); }
"bool"          { print_token("DATA_TYPE", yytext); }
"void"          { print_token("DATA_TYPE", yytext); }

    /* Arithmetic Operators */
"+"             { print_token("OPERATOR", yytext); }
"-"             { print_token("OPERATOR", yytext); }
"*"             { print_token("OPERATOR", yytext); }
"/"             { print_token("OPERATOR", yytext); }
"%"             { print_token("OPERATOR", yytext); }

    /* Assignment Operator */
"="             { print_token("ASSIGNMENT", yytext); }

    /* Increment/Decrement */
"++"            { print_token("INCREMENT", yytext); }
"--"            { print_token("DECREMENT", yytext); }

    /* Relational Operators */
"=="            { print_token("RELATIONAL_OP", yytext); }
"!="            { print_token("RELATIONAL_OP", yytext); }
">"             { print_token("RELATIONAL_OP", yytext); }
"<"             { print_token("RELATIONAL_OP", yytext); }
">="            { print_token("RELATIONAL_OP", yytext); }
"<="            { print_token("RELATIONAL_OP", yytext); }

    /* Stream Operators */
">>"            { print_token("STREAM_IN", yytext); }
"<<"            { print_token("STREAM_OUT", yytext); }

    /* Punctuations */
";"             { print_token("SEMICOLON", yytext); }
","             { print_token("COMMA", yytext); }
"("             { print_token("LEFT_PAREN", yytext); }
")"             { print_token("RIGHT_PAREN", yytext); }
"{"             { print_token("LEFT_BRACE", yytext); }
"}"             { print_token("RIGHT_BRACE", yytext); }
"["             { print_token("LEFT_BRACKET", yytext); }
"]"             { print_token("RIGHT_BRACKET", yytext); }

    /* Literals */
{INTEGER}       { print_token("INTEGER", yytext); }
{FLOAT}         { print_token("FLOAT", yytext); }
\"([^\\\"]|\\.)*\"  { print_token("STRING_LITERAL", yytext); }
'([^\\']|\\.)'      { print_token("CHAR_LITERAL", yytext); }

    /* Invalid Identifiers - starting with special characters */
[@#$%^&!~`][a-zA-Z0-9_]+  { 
    fprintf(stderr, "Line %d: ERROR → %s (invalid identifier)\n", line_number, yytext);
}

    /* Invalid Numbers - starting with digit followed by letters */
{DIGIT}+[a-zA-Z_]+[a-zA-Z0-9_]*  { 
    fprintf(stderr, "Line %d: ERROR → %s (invalid number)\n", line_number, yytext);
}

    /* Identifiers */
{IDENTIFIER}    { print_token("IDENTIFIER", yytext); }

    /* Comments */
"//".*          { print_token("COMMENT", yytext); }
"/*"([^*]|\*+[^*/])*\*+"/"  { print_token("MULTI_COMMENT", yytext); }


    /* Whitespace and Newline */
{WHITESPACE}    { /* ignore whitespace */ }
{NEWLINE}       { line_number++; }

    /*Unrecognized Symbols*/
[@#$%^&!~`|\\]  { 
    fprintf(stderr, "Line %d: ERROR → %s (unrecognized symbol)\n", line_number, yytext);
}

    /* Any other unrecognized character */
.               { 
    fprintf(stderr, "Line %d: ERROR → %s (unrecognized character)\n", line_number, yytext);
}

%%

int yywrap() {
    return 1;
}

int main(int argc, char *argv[]) {
    FILE *input_file;
    
    if (argc < 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }
    
    input_file = fopen(argv[1], "r");
    if (!input_file) {
        fprintf(stderr, "Error: Cannot open file '%s'\n", argv[1]);
        return 1;
    }
    
    yyin = input_file;
    
    printf("=================================================================\n");
    printf("          SaraikScript Lexical Analyzer Output\n");
    printf("=================================================================\n");
    
    yylex();
    
    printf("=================================================================\n");
    printf("Total Tokens: %d\n", token_count);
    printf("Total Lines: %d\n", line_number);
    printf("=================================================================\n");
    
    fclose(input_file);
    return 0;
}
