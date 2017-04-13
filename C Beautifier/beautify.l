%option noyywrap
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sym.c"
#define INDENT (4)
int line=1;
int column=4;
int paren=0;
%}


quote '
ditto \"
back \\
newline \\n
ch	[^'\"\\"\n"]
digit [0-9]
exp	(e|E)((\+|-)?){digit}+
hex	{digit}|[a-fA-F]
alpha [a-zA-Z]|_
white_space	[" "\t\n\v\r\f]+
directives	"#".*
in_line_comment	"//".*
arith	["+"|"-"|*|"/"|"%"]
inc_dec	["++"|"--"]
bitshift	["<<"|">>"]
logical	[!|&&|"||"]
bit_log	[&|"^"|~|"|"]
misc	["sizeof"|,|"->"]
comparator	["=="|\>|\<|\>=|\<=]
assign	[{arith}|{bitshift}|{logical}]?=
operator	[{assign}|{comparator}|{misc}|{bit_log}|{logical}|{bitshift}|{inc_dec}|{arith}]

%%
{quote}({back}{ch}|{back}{back}|{back}{quote}|{back}{ditto}|{ch}|{ditto})+{quote}	{write_char();}
{ditto}({back}{ch}|{back}{back}|{back}{quote}|{back}{ditto}|{ch}|{quote})+{ditto}	{write_string();}
0(0|1|2|3|4|5|6|7)+	{write_oct();}
0(x|X){hex}+	{write_hex();}
{digit}+	{write_int();}
{digit}*\.{digit}*{exp}?	{write_fp();}
{alpha}({alpha}|{digit})*	{write_id();}
\{	{write_begin();}
\}	{write_end();}
\(	{write_open();}
\)	{write_close();}
\[	{write_bopen();}
\]	{write_bclose();}
";"	{write_sep();}
{operator}	{write_op();}
{in_line_comment}	{write_inline();}
"\*"	{write_comment();}
{directives}	{write_directive();}
{white_space}	{write_whitespaces();}
%%

indent()
{
	printf("\n%-*d",column,line++); 
}

write_comment()
{ 
	char c, c1;
	printf("<font color='#00FF00'>/*");
	loop:
		while ((c = input()) != '*' && c != 0)
			write_html_char(c);
		write_html_char('*');
		if ((c1 = input()) != '/' && c != 0)
		{ 
			unput(c1);
	goto loop; }
		if (c != 0)
			write_html_char(c1);
	printf("</font>");
}

write_html_char(int c)
{ 
	switch (c)
	{ 
		case '<': printf("&lt;"); break;
		case '>': printf("&gt;"); break;
		case '"': printf("&quot;"); break;
		case '&': printf("&amp;"); break;
		default: putchar(c);
	}
}

write_html() 
{ 
	char *s = yytext;
	while (*s)
		write_html_char(*s++);
}

write_id()
{
	if(lookup(yytext)==0)
	{
		printf("<b><font color=\"blue\">");
		write_html();
		printf("</font></b>");
	}
	else if(lookup(yytext)==1)
	{
		printf("<font color=\"blue\">");
		printf("<a href=\"#%s\">",yytext);
		write_html();
		printf("</a>");
		printf("</font>");
	}
	else
	{
		insert(yytext,1);
		printf("<font color=\"blue\">");
		printf("<a name=\"%s\">",yytext);
		write_html();
		printf("</a>");
		printf("</font>");
	}
}

write_sep()
{ 
	write_html();
	if (!paren)
		indent();
	else
		putchar(' ');
}

write_begin()
{ 
	indent();
	write_html();
	column += INDENT;
	indent();
}

write_end()
{ 
	column -= INDENT;
	indent();
	write_html();
	indent();
}

write_open()
{ 
	write_html();
	putchar(' ');
	paren++; 
}

write_close()
{ 
	write_html();
	putchar(' ');
	paren--; 
}

write_bopen()
{
	write_html();
}

write_bclose()
{
	write_html();
}

write_string()
{
	printf("<font color=\"red\">");
	write_html();
	printf("</font>");
}

write_char()
{
	printf("<u><font color=\"cyan\">");
	write_html();
	printf("</font></u>");
}

write_hex()
{
	printf("<i><font color=\"cyan\">");
	write_html();
	printf("</font></i>");
}

write_oct()
{
	printf("<i><font color=\"cyan\">");
	write_html();
	printf("</font></i>");
}

write_int()
{
	printf("<i><font color=\"cyan\">");
	write_html();
	printf("</font></i>");
}

write_fp()
{
	printf("<font color=\"cyan\">");
	write_html();
	printf("</font>");
}

write_op()
{
	printf("<b><font color=\"black\">");
	write_html();
	printf("</font></b>");
}

write_directive()
{
	printf("<b><font color=\"magenta\">");
	write_html();
	printf("</font></b>");	
}

write_inline()
{
	printf("<font color=\"green\">");
	write_html();
	printf("</font>");
}

write_whitespaces()
{
	write_html();
}

error()
{
	printf("<b><font color=\"green\">");
	write_html();
	printf("</b></font>");	
}

main()
{
	init();
	printf("<html><pre>\n");
	indent();
	yylex();
	printf("\n</pre></html>\n");
	return 0;	
}