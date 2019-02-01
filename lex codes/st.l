/* just like Unix wc */
%{
	struct data{
		char *buf;
		int freq;
		int size;
		int lno[50];
	};

	int k=0,cnt=1,h=0;

	struct data table[50];
	
%}

%%

[a-z(')?A-Z]+	{
	int flag=0,u=-1;
	for(int i=0;i<k;i++)
	{
		if(strcmp(table[i].buf,yytext)==0)
		{
			flag=1;
			u = i;
			break;
		}
	}
	if(flag==0)
	{
		strcpy(table[k].buf,yytext);
		int p = strlen(yytext);
		table[k].freq = 1;
		table[k].lno[0] = cnt;
		table[k].size = 1;
		k++;
	}
	else
	{
		int q=0;
		table[u].freq++;
		for(int i=0;i<table[u].size;i++)
		{
			if(table[u].lno[i] == cnt)
			{
				q=1;
				break;
			}
		}
		if(q==0)
		{
			table[u].lno[table[u].size] = cnt;
			table[u].size++;
		}

	}
}
\n	{ cnt++; }

[ ] { h++; }



%%
int main(int argc, char **argv)
{
	for(int i=0;i<50;i++)
	{
		table[i].buf = malloc(sizeof(char)*400);
	}
	yylex();

	for(int i=0;i<k;i++)
	{
		printf("%s --> \t",table[i].buf);
		for(int j=0;j<table[i].size;j++)
		{
			printf("%d\t",table[i].lno[j]);
		}
		printf("\t%d  ",table[i].freq);
		printf("\n");
	}

	return 0;
}