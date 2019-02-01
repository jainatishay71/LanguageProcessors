%{
	char buf[500][50];
	int k = 0;
	char buff[50];
%}
%%
[A-Z]+	{ 
	char *buffer,*m;
	buffer = malloc(sizeof(char)*50);
	m = malloc(sizeof(char)*50);
	strcpy(buffer,yytext);
	for(int i=0;i<strlen(yytext);i++)
	{
		buffer[i] = yytext[(i+2)%strlen(yytext)];
	}
	for(int i=strlen(buffer)-1;i>=0;i--)
	{
		char tmp[2];
		tmp[0]=buffer[i];
		tmp[1]='\0';
		strcat(m,tmp);
	}
	strcpy(buf[k],m);
	k++;
}

[a-zA-Z]+	{
	char *b,*m;
	b = malloc(sizeof(char)*50);
	m = malloc(sizeof(char)*50);
	strcpy(b,yytext);
	for(int i=0;i<strlen(b);i++)
	{
		int r = (int)b[i];
		r = (r+2)%256;
		b[i] = (char)r;
	}
	for(int i=strlen(b)-1;i>=0;i--)
	{
		char tmp[2];
		tmp[0]=b[i];
		tmp[1]='\0';
		strcat(m,tmp);
	}
	strcpy(buf[k],m);
	k++;
}

[0-9]+	{
	
	char *hut,*jug;
	hut = malloc(sizeof(char)*50);
	jug = malloc(sizeof(char)*50);
	if(strlen(yytext)%2==0)
	{
		for(int i=strlen(yytext)/2;i<strlen(yytext);i++)
		{
			char tmp[2];
			tmp[0]=yytext[i];
			tmp[1]='\0';
			strcat(hut,tmp);
		}
	}
	else
	{
		for(int i=((strlen(yytext)/2)+1);i<strlen(yytext);i++)
		{
			char tmp[2];
			tmp[0]=yytext[i];
			tmp[1]='\0';
			strcat(hut,tmp);
		}
	}
	
	if(strlen(yytext)%2==1)
	{
		char tmp[2];
		tmp[0]=yytext[strlen(yytext)/2];
		tmp[1]='\0';
		strcat(hut,tmp);
	}
	strcpy(buf[k],hut);

	for(int i=0;i<strlen(yytext)/2;i++)
	{
		char tmp[2];
		tmp[0]=yytext[i];
		tmp[1]='\0';
		strcat(buf[k],tmp);
	}
	
	k++;
}

[ ]*	{ 
	strcpy(buf[k]," ");
	k++;
}

.	{
	strcpy(buf[k],yytext);
	k++;
}



%%
int main(int argc, char **argv)
{
	yylex();
	
	for(int i=0;i<k;i++)
	{
		printf("%s\n",buf[i]);
	}


	return 0;
}