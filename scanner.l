%{
#include "parser.tab.h"
#include <stdio.h>

%}

%option yylineno

/* Regular Expression Definitions */
DIGIT       [0-9]
LETTER      [a-zA-Z]
IDENTIFIER  {LETTER}({LETTER}|{DIGIT}|_)*
INTEGER     {DIGIT}+
FLOAT       {DIGIT}+\.{DIGIT}+
WHITESPACE  [ \t]+
NEWLINE     \n

%%

    /* KEYWORDS */

"je"            { return JE; }
"bia"           { return BIA; }
"jein_tak"      { return JEIN_TAK; }
"wastey"        { return WASTEY; }
"kar"           { return KAR; }
"wapas"         { return WAPAS; }
"te"            { return TE; }
"ya"            { return YA; }
"koh"           { return KOH; }
"sach"          { return SACH; }
"Koor"          { return KOOR; }
"kaam"          { return KAAM; }
"das"           { return DAS; }
"vikha"         { return VIKHA; }
"buniyad"       { return BUNIYAD; }

    /* DATA TYPES */

"int"           { return INT; }
"float"         { return FLOAT; }
"char"          { return CHAR; }
"string"        { return STRING; }
"bool"          { return BOOL; }
"void"          { return VOID; }

    /* ARITHMETIC OPERATORS */

"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MULTIPLY; }
"/"             { return DIVIDE; }
"%"             { return MODULO; }

    /* ASSIGNMENT OPERATOR */

"="             { return ASSIGN; }

    /* INCREMENT/DECREMENT */

"++"            { return INCREMENT; }
"--"            { return DECREMENT; }

    /*  RELATIONAL OPERATORS */

"=="            { return EQ; }
"!="            { return NEQ; }
">"             { return GT; }
"<"             { return LT; }
">="            { return GTE; }
"<="            { return LTE; }

    /* STREAM OPERATORS */

">>"            { return STREAM_IN; }
"<<"            { return STREAM_OUT; }

    /* PUNCTUATIONS */

";"             { return SEMICOLON; }
","             { return COMMA; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }
"["             { return LBRACKET; }
"]"             { return RBRACKET; }

    /* LITERALS */

{INTEGER}       { return INTEGER; }
{FLOAT}         { return FLOAT_NUM; }
\"([^\\\"]|\\.)*\"  { return STRING_LITERAL; }
'([^\\']|\\.)'      { return CHAR_LITERAL; }

    /*      INVALID IDENTIFIERS
       Starting with special characters */

[@#$%^&!~`][a-zA-Z0-9_]+  { 
    fprintf(stderr, "Line %d: Lexical Error - Invalid identifier '%s' (cannot start with special character)\n", 
            yylineno, yytext);
    return -1;
}

    /*            INVALID NUMBERS
       Starting with digit followed by letters */

{DIGIT}+[a-zA-Z_]+[a-zA-Z0-9_]*  { 
    fprintf(stderr, "Line %d: Lexical Error - Invalid number '%s' (cannot have letters after digits)\n", 
            yylineno, yytext);
    return -1;
}

    /*              IDENTIFIERS
       Must come after keywords to avoid conflicts */

{IDENTIFIER}    { return IDENTIFIER; }

    /*  COMMENTS */

"//".*          { return COMMENT; }
"/*"([^*]|\*+[^*/])*\*+"/"  { return COMMENT; }

    /*  WHITESPACE AND NEWLINE */

{WHITESPACE}    { /* Ignore whitespace */ }
{NEWLINE}       { /* Line count handled by %option yylineno */ }

    /* UNRECOGNIZED SYMBOLS */

[@#$%^&!~`|\\]  { 
    fprintf(stderr, "Line %d: Lexical Error - Unrecognized symbol '%s'\n", 
            yylineno, yytext);
    return -1;
}

    /* ANY OTHER UNRECOGNIZED CHARACTER */

.               { 
    fprintf(stderr, "Line %d: Lexical Error - Unrecognized character '%s'\n", 
            yylineno, yytext);
    return -1;
}

%%

/* WRAPPER FUNCTION */

int yywrap() {
    return 1;  /* Indicates end of input */
}
