%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	#include<unistd.h>

	int uminus(int );
	int preced(char *);
	struct extr
	{
		union u
		{
			char opr;
			int data;
		}node;
		int tag;
		struct extr *left;
		struct extr *right;
	};
	typedef struct extr* eptr;

	void post(eptr);

	struct stack1{
		eptr data[100];
		int top;
	};

	struct stack2{
		char data[100];
		int top;
	};
	
	struct stack1 st1;
	struct stack2 st2;
	int flag=0;
%}

DIGIT    [0-9]

%%


{DIGIT}+	 {

	int d=atoi(yytext);
	if(flag==1)
	{
		flag=0;
		d=uminus(d);
	}
	eptr temp=malloc(sizeof(eptr)*400);
	temp->tag=0;
	temp->node.data=d;
	temp->right=NULL;
	temp->left=NULL;
	st1.data[st1.top++]=temp;
}

"+"|"-"|"*"|"/"|"um"|"@"|"("|")"	{
	if(strcmp(yytext,"um")==0)
		flag=1;
	else
	{
		if(strcmp(yytext,"(")==0)
		{
			st2.data[st2.top++]='(';
		}
		else if(strcmp(yytext,")")==0)
		{
			while(st2.data[st2.top-1]!='(')
			{
				char nopr=st2.data[--st2.top];
				eptr tmp1=st1.data[--st1.top];
				eptr tmp2=st1.data[--st1.top];

				eptr root=malloc(sizeof(eptr)*400);
				root->node.opr=nopr;
				root->tag=1;
				root->left=tmp2;
				root->right=tmp1;
				st1.data[st1.top++]=root;

			}
			st2.top--;
		}
		else 
		{
			if(st2.top != 0)
			{
				char c = st2.data[st2.top-1];
				char str[2];
				str[0] = c;
				str[1] = '\0';
				int pre=preced(str);
				int cur=preced(yytext);
				if(pre<=cur)
				{
					st2.data[st2.top++]=yytext[0];
				}
				else
				{
					char check=st2.data[st2.top-1];
					char strg[2];
					strg[0] = check;
					strg[1] = '\0';
					while(preced(strg)>cur && st2.top>0)
					{
						char nopr=st2.data[--st2.top];
						eptr tmp1=st1.data[--st1.top];
						eptr tmp2=st1.data[--st1.top];
						eptr root=malloc(sizeof(eptr)*400);
						root->tag=1;
						root->node.opr=nopr;
						root->left=tmp2;
						root->right=tmp1;
						
						st1.data[st1.top++]=root;
						check=st2.data[st2.top-1];
						strg[0] = check;
						strg[1] = '\0';
					}
					st2.data[st2.top++]=yytext[0];
				}
			}
			else
			{
				st2.data[st2.top++]=yytext[0];
			}
		}
	}
}


%%


int main(int argc, char *argv[])
{

	st1.top = 0;
	st2.top= 0;
	
	yylex();

	while(st2.top>0)
	{
		char nopr=st2.data[--st2.top];
		eptr tmp1=st1.data[--st1.top];
		eptr tmp2=st1.data[--st1.top];

		eptr root=malloc(sizeof(eptr)*400);
		root->node.opr=nopr;
		root->tag=1;
		root->left=tmp2;
		root->right=tmp1;
		
		st1.data[st1.top++]=root;
	}

	post(st1.data[0]);
	printf("\n");
	return 0;
}

int uminus(int x)
{
	return (-1)*x;
}

int preced(char *opr)
{
	if(strcmp(opr,"(")==0)
		return 0;
	if(strcmp(opr,"+")==0)
		return 1;
	else if(strcmp(opr,"*")==0)
		return 2;
	else if(strcmp(opr,"-")==0)
		return 1;
	else if(strcmp(opr,"/")==0)
		return 2;
	else
		return 3;
}

void post(eptr x)
{
	if(x!=NULL)
	{
		post(x->left);
		post(x->right);
		if(x->tag == 0)
		{
			printf("%d  ",x->node.data);
		}
		else
		{
			printf("%c  ",x->node.opr);
		}
	}
}
