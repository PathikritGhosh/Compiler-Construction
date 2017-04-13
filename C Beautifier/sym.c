# define MAXSYMBOL 200

struct entry
{
	char *lexptr;
	int token;
};

struct entry symtable[MAXSYMBOL];
int size=0;

int lookup(char *lexeme)
{
	for(int i=0;i<size;++i)
	{
		if(strcmp(symtable[i].lexptr,lexeme)==0)
		{
			return symtable[i].token;
		}
	}
	return -1;
}

int insert(char *a,int token)
{
	//printf("insert:%s\n",a);
	//printf("table:%s\n",symtable[size].lexptr);
	symtable[size].lexptr=malloc(sizeof(struct entry));
	strcpy(symtable[size].lexptr,a);
	symtable[size].token=token;				//1 is an identifier
	size++;
	return 1;
}

void init()
{
	insert("auto",0);
	insert("int",0);
	insert("double",0);
	insert("break",0);
	insert("struct",0);
	insert("case",0);
	insert("const",0);
	insert("char",0);
	insert("default",0);
	insert("enum",0);
	insert("else",0);
	insert("do",0);
	insert("extern",0);
	insert("goto",0);
	insert("register",0);
	insert("if",0);
	insert("float",0);
	insert("long",0);
	insert("for",0);
	insert("short",0);
	insert("unsigned",0);
	insert("volatile",0);
	insert("return",0);
	insert("signed",0);
	insert("sizeof",0);
	insert("static",0);
	insert("typedef",0);
	insert("union",0);
	insert("switch",0);
	insert("void",0);
	insert("while",0);
}