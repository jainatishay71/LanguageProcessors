/*
	Implementation of CYK Algorithm to find membership of a string according to given grammer rules.

	Sample Input

	8

	SAB
	SBC
	ABA
	Aa
	BCC
	Bb
	CAB
	Ca

	baaba

*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{
	int np;
	printf("Enter the no of productions:");
	scanf("%d",&np);
	printf("Enter the productions!\n");
	char prod[50][50];
	for(int i=0;i<np;i++)
		scanf("%s",prod[i]);
	printf("Enter the string whose membership is to be checked:");
	char w[50];
	scanf("%s",w);
	int len = strlen(w);
	char mat[len][len][50];

	for (int i = 0; i < len; i++)
	{
		char buf[50];
		buf[0] = '\0';
		for(int j=0;j<np;j++)
		{
			if(strlen(prod[j])==2)
			{
				char u = prod[j][1];
				if(u == w[i])
				{
					char temp[2];
					temp[0]=prod[j][0];
					temp[1]='\0';
					strcat(buf,temp);
				}
			}
		}
		strcpy(mat[len-1][i],buf);
	}

	for(int i=1;i<len;i++)
	{
		for(int j=0;j<len-i;j++)
		{
			int k=i,h=j,g=len-i,v=1;;
			char buff[50];
			buff[0]='\0';
			while(k>0)
			{
				char str1[50],str2[50];
				str1[0]='\0';str2[0]='\0';
				strcpy(str1,mat[len-v][j]);
				v++;
				strcpy(str2,mat[g++][++h]);
				for(int x=0;x<strlen(str1);x++)
				{
					for(int y=0;y<strlen(str2);y++)
					{
						char temp[3];
						temp[0]=str1[x];temp[1]=str2[y];temp[2]='\0';
						for(int m=0;m<np;m++)
						{
							if(strlen(prod[m])==3)
							{
								char tmp[3];
								tmp[0]=prod[m][1];tmp[1]=prod[m][2];tmp[2]='\0';
								if(strcmp(temp,tmp)==0)
								{
									char ftmp[2];
									ftmp[0]=prod[m][0];ftmp[1]='\0';
									strcat(buff,ftmp);
								}
							}
						}
					}
				}
				k--;
			}
			if(strlen(buff)==0)
			{
				buff[0]='@';
				buff[1]='\0';
			}
			strcpy(mat[len-i-1][j],buff);
		}
	}
	for(int i=0;i<len;i++)
	{
		for(int j=0;j<=i;j++)
		{
			char hut[50],res[50];
			hut[0]='\0';res[0]='\0';
			strcpy(hut,mat[i][j]);
			for(int z=0;z<strlen(hut);z++)
			{
				int q=0;
				for(int f=0;f<strlen(res);f++)
				{
					if(res[f]==hut[z])
					{
						q=1;
						break;
					}
				}
				if(!q)
				{
					char tempp[2];
					tempp[0]=hut[z];tempp[1]='\0';
					strcat(res,tempp);
					strcpy(mat[i][j],res);
				}
			}
		}
	}
	for(int i=0;i<len;i++)
	{
		for(int j=0;j<=i;j++)
		{
			printf("%s\t", mat[i][j]);
		}
		printf("\n");
	}
	char hut[50];
	hut[0]='\0';
	strcpy(hut,mat[0][0]);
	int q=0;
	for(int i=0;i<strlen(hut);i++)
	{
		if(hut[i] == 'S')
		{
			q=1;
			break;
		}
	}
	if(q)
		printf("Given word is a member of given Grammer!\n");
	else
		printf("Given word is not a member of given Grammer!\n");

}