
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


//void yyerror(char *str) ;

%}



%%

[\n\t ' '] {}



"'s " {}
"every "  {   }  

"of "  {   }
"of every "  {   }



"all the "  { } 

"all "  { } 

"the "  {  }     

"their "  {  }

"our "    {  }

"any "    {  }
"has "    {  }


"show "    { return REPLY  ; }

"list "    { return REPLY ; }

"display "   { return REPLY  ; }

"give "   { return REPLY  ; }

"fetch "   { return REPLY  ; }





"to me "    { return TO_ME  ; }

"to us "    { return TO_ME ; }

"me "    { return TO_ME  ; }

"us "    { return TO_ME ; }



"how much "   { return MOJ ; }

"how many "   { return MOJ ; }

"what is the count of "   { return MOJ ; }
"what is count of "   { return MOJ ; }
"what is the number of "   { return MOJ ; }
"what is number of "   { return MOJ ; }
"what number of "   { return MOJ ; }
"count the number of "   { return MOJ ; }
"count"   { return MOJ ; }



"is there"  	{ return ENQUIRE ; }
"are there"  	{ return ENQUIRE ; }
"do we have"  	{ return ENQUIRE ; }
"we have"  	{ return ENQUIRE ; }






"whose "    {  }

"by "     { }

"which "   {  return QUESTION ;}
"who "   { return QUESTION ; }
"what's "|"what're "|"what "|"what is "|"what are "		{return QUESTION;}
"who's "|"who're "|"who "|"who is "|"who are "|"what is the name of "|"what are the names of "			{return QUESTION;}

"with "   {  } 
"and "   { return WORDQ ; }

","    { return WORDQ ; }





    
"is equal to "  {  return PRE_EQUAL ; } 
"equal "  {  return PRE_EQUAL ; }

"equal to "   {  return PRE_EQUAL ; }

"is "   { return PRE_EQUAL; }

"for "   {  return PRE_EQUAL ; }

"to "    {  return PRE_EQUAL ; }

"from "   {  return PRE_EQUAL ; }

"are "    {  return PRE_EQUAL ; }

"is more than "   {  return PRE_GREATER ; }

"are more than "   {  return PRE_GREATER ; }

"is greater than "   {  return PRE_GREATER ; }

"are greater than "   {  return PRE_GREATER ; }
"is above "   {  return PRE_GREATER ; }

"are above "   {  return PRE_GREATER ; }

"is less than "    {  return  PRE_LESS ; } 

"are less than "   {  return  PRE_LESS ; } 

"is lower than "   {  return  PRE_LESS ; } 

"are below "   {  return  PRE_LESS ; } 
"is below "   {  return  PRE_LESS ; } 

"are lower than "   {  return  PRE_LESS ; } 

"is between "    { return PRE_BETWEEN ; }

"are between "   {  return PRE_BETWEEN  ; }
"are in range "   {  return PRE_BETWEEN  ; }
"is in range "   {  return PRE_BETWEEN  ; }




"?"   { return EOL ; }

"."   { return EOL ; } 




[a-zA-Z0-9]+     { 


		//free(yylval);
		yylval = strdup(yytext) ; 

		if(yylval!=NULL)
		{

		int res;
		int i,j;
		//printf("ip %s\n",yylval);
		for(j=0 ; j<alias_count ; j++)
		{
            	if(strcmp(yylval,alias_name[j])==0)
				{
						strcpy(yylval,alias_map[j]);
						//printf("pro.l %s<=>%s\n",alias_name[j],alias_map[j]);
				}
		}
		for(i=0 ; i<tbl_count ; i++)
		{
				res = strcmp(yylval,tbl_name[i]);
				if(res==0)
				{
				//printf("tab\n");
					return TABLE ;
				}
				for(j=0 ; j<tbl_column_count[i] ; j++)
				{
					res = strcmp(yylval,tbl_column_name[i][j]);
					if(res==0)
					{
					//printf("f\n");
						return FIELD ;
					}
				}
		}
		//printf("JUNKP!!!!!");
		return INPUT;
		}
		else
		{
		printf("memory full!");
}
	}

%%           


