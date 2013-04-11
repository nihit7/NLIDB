#include "pro.tab.c"
#include "lex.yy.c"

int yywrap();
int yywrap()
{
		return 1;
}
void initialize_db(char *link)
{
		char line[100];
		char tem[50];
		char alias[50];
		int tabno = 0,colno = 0;
		FILE *fr = fopen (link, "rt");

		tbl_count = 0;
		alias_count = 0;
	   	while(fgets(line, 100, fr) != NULL)
	   	{

			char *pch = strchr(line,'<');
			if(strncmp(pch,"<table>",7)==0)
			{


				strcpy(tem,pch+7);
				tem[strlen(tem)-1]='\0';
				strcpy(tbl_name[tbl_count],tem);
				tbl_count++;
				tabno = tbl_count-1;
				colno = 0 ;
				//printf("%d,%s",strlen(top),top);
				//printf("zz%czz",top[4]);

			}
			else if(strncmp(pch,"<column>",8)==0)
			{
				strcpy(tem,pch+8);
				tem[strlen(tem)-1]='\0';
				strcpy(tbl_column_name[tabno][colno],tem);
				colno++;
				tbl_column_count[tabno]=colno;

			}
			else if(strncmp(pch,"<alias>",7)==0)
			{

	            strcpy(alias,pch+7);
				alias[strlen(alias)-1]='\0';
				strcpy(alias_name[alias_count],alias);
				strcpy(alias_map[alias_count],tem);
				alias_count++;


			}

	}
}
char* convert_sql(char *query)
{
	
	    //char output[200];
		yy_scan_string(query);
		successcode=yyparse();
	//	printf("%d<->%d)",i,successcode);
		//yylex_destroy() ;
		//strcpy(output,ret_string);
		//printf("00000%s999999",output);
		return ret_string;
}
int success()
{
	if(successcode==0)
	    return 1;
	else
	    return 0;
}
char* message()
{
	return error_string;
}




