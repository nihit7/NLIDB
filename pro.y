%{
#include <stdio.h>
#include <stdio.h>
#include <string.h>
#define YYSTYPE char *


extern int yylex() ;
extern int yyparse() ;
extern FILE *yyin ;
extern char *yytext ;

int successcode = 0 ;

int tbl_count;
char tbl_name[5][20];
int tbl_column_count[5];
char tbl_column_name[5][10][20];

int alias_count;
char alias_name[100][20];
char alias_map[100][20];

char tempe[100];

char ret_string[200];
char error_string[200];

int yylex(void) ;

int get_table(char *field);
int table_id(char *field);
char* get_common(int table1,int table2);

static void yyerror(char *str) 
{
	if(tbl_count==0)
	{
		sprintf(error_string,"Database not initialised! initialize_db(char * )") ;
		sprintf(ret_string,"Please set the database!") ;
	}
	else if(strstr (str,"expecting EOL")!=NULL)
	{
		sprintf(error_string,"Faliure! NLPError : %s " , str) ;
		sprintf(ret_string,"Please end the sentence with a punctuation mark") ;
	}
	else
	{
		sprintf(error_string,"Faliure! NLPError : %s " , str) ;
		sprintf(ret_string,"Could you rephrase that?") ;
	}
}
%}




%error-verbose
%token REPLY 
%token TO_ME
%token QUESTION
%token PREP
%token QUALIFIER
%token MOJ
%token ENQUIRE
%token WORDQ
%token TOTAL
%token EOL 
%token TABLE
%token FIELD
%token WHOSE
%token PRE_EQUAL
%token INPUT
%token PRE_LESS
%token PRE_BETWEEN
%token PRE_GREATER
%start translate

%%
                         
translate   :   select
	    	|   count
            ;                                                                                                                                                   


select  	:   query TABLE EOL									{	sprintf ( ret_string,  "SELECT * FROM %s",$2)	;sprintf(error_string,"Success with rule : query TABLE") ;}

			|   query FIELD TABLE EOL      						{
																	int table1 = table_id($3);
																	int ftable2 = get_table($2);
																	if(table1==ftable2){
																		sprintf(ret_string,"SELECT %s  FROM %s",$2,$3) ;	
																		sprintf(error_string,"Success with rule : query FIELD TABLE") ;
																	}
																	else
																	{
																		char common[20];
																		strcpy(common,get_common(table1,ftable2));
																		sprintf(ret_string,"SELECT %s.%s  FROM %s,%s WHERE %s.%s = %s.%s",tbl_name[ftable2] ,$2, tbl_name[table1] , tbl_name[ftable2] , tbl_name[table1] , common , tbl_name[ftable2] , common) ;	
																		sprintf(error_string,"Success with rule : query FIELD TABLE (join)") ;
																	}
																}
			|   query TABLE FIELD EOL							{
																	int table1 = table_id($2);
																	int ftable2 = get_table($3);
																	if(table1==ftable2){
																		sprintf(ret_string,"SELECT %s  FROM %s",$3,$2) ;	
																		sprintf(error_string,"Success with rule : query TABLE FIELD") ;
																	}
																	else
																	{
																		char common[20];
																		strcpy(common,get_common(table1,ftable2));
																		sprintf(ret_string,"SELECT %s.%s  FROM %s,%s WHERE %s.%s = %s.%s",tbl_name[ftable2] ,$3, tbl_name[table1] , tbl_name[ftable2] , tbl_name[table1] , common , tbl_name[ftable2] , common) ;	
																		sprintf(error_string,"Success with rule : query TABLE FIELD (join)") ;
																	}
																}
																						
									
			|  	query  FIELD WORDQ FIELD TABLE EOL   			{	
																	int table1 = get_table($2);
																	int table2 = get_table($4);
																	if(table1==table2)
																	{
																		sprintf(ret_string,"SELECT %s ,%s FROM %s ", $2 , $4 ,tbl_name[table1]) ;
																		sprintf(error_string,"Success with rule : 	query  FIELD WORDQ FIELD TABLE") ;
																	}
																	else
																	{
																		char common[20];
																		strcpy(common,get_common(table1,table2));
																		sprintf(ret_string,"SELECT %s.%s , %s.%s FROM %s , %s  WHERE %s.%s = %s.%s", tbl_name[table1] , $2 , tbl_name[table2] , $4 ,tbl_name[table1] , tbl_name[table2] , tbl_name[table1] , common , tbl_name[table2] , common) ;
																		sprintf(error_string,"Success with rule : 	query  FIELD WORDQ FIELD TABLE (join)") ;
																	}
																}
			|  	query TABLE FIELD WORDQ FIELD EOL 				{	
																	int table1 = get_table($3);
																	int table2 = get_table($5);
																	if(table1==table2)
																	{
																		sprintf(ret_string,"SELECT %s ,%s FROM %s ", $3 , $5,tbl_name[table1]) ;
																		sprintf(error_string,"Success with rule : 	query TABLE FIELD WORDQ FIELD") ;
																	}
																	else
																	{
																		char common[20];
																		strcpy(common,get_common(table1,table2));
																		sprintf(ret_string,"SELECT %s.%s , %s.%s FROM %s , %s  WHERE %s.%s = %s.%s", tbl_name[table1] , $3 , tbl_name[table2] , $5 ,tbl_name[table1] , tbl_name[table2] , tbl_name[table1] , common , tbl_name[table2] , common) ;
																		sprintf(error_string,"Success with rule :	query TABLE FIELD WORDQ FIELD (join)") ;
																	}
																}
																																															
																
			|   query TABLE FIELD condition EOL  			{ 	
			
																	int table1 = table_id($2);
																	int ftable2 = get_table($3);
																	char condi[20];
																	strcpy(condi,tempe); 
																	if(table1==ftable2){
																		sprintf(ret_string,"SELECT  * FROM %s WHERE %s", $2,$3);
																		sprintf(error_string,"Success with rule :	 query TABLE FIELD condition") ;
																	}
																	else
																	{
																		char common[20];																		
																		strcpy(common,get_common(table1,ftable2));
																		sprintf(ret_string,"SELECT * FROM %s,%s WHERE %s.%s = %s.%s AND %s.%s ", tbl_name[table1] , tbl_name[ftable2] , tbl_name[table1] , common , tbl_name[ftable2] , common ,tbl_name[ftable2] ,$3) ;	
																	}
																	strcat(ret_string,condi); 	
																	sprintf(error_string,"Success with rule :	 query TABLE FIELD condition (join)") ;
																}
																	
								
			|	query FIELD FIELD condition EOL			{ 	
																	int table1 = get_table($2);
																	int table2 = get_table($3);
																	char condi[20];
																	strcpy(condi,tempe); 
																	if(table1==table2)
																	{
																		sprintf(ret_string,"SELECT  %s FROM %s WHERE %s", $2,tbl_name[table1],$3);
																		sprintf(error_string,"Success with rule :	query FIELD FIELD condition") ;
																	}
																	
																	else
																	{
																		char common[20];																		
																		strcpy(common,get_common(table1,table2));
																		sprintf(ret_string,"SELECT %s.%s FROM %s,%s WHERE %s.%s = %s.%s AND %s.%s ", tbl_name[table1] , $2 ,tbl_name[table1] , tbl_name[table2] , tbl_name[table1] , common , tbl_name[table2] , common ,tbl_name[table2] ,$3) ;	
																	}
																	strcat(ret_string,condi); 	
																	sprintf(error_string,"Success with rule :	query FIELD FIELD condition(join)") ;
																}		
								
			|   query FIELD TABLE FIELD condition EOL			{ 	
																	int table1 = get_table($2);
																	int table2 = get_table($4);
																	char condi[20];
																	strcpy(condi,tempe); 
																	if(table1==table2)
																	{
																		sprintf(ret_string,"SELECT  %s FROM %s WHERE %s", $2,tbl_name[table1],$4);
																		sprintf(error_string,"Success with rule :	 query FIELD TABLE FIELD condition") ;
																	}
																	
																	else
																	{
																		char common[20];																		
																		strcpy(common,get_common(table1,table2));
																		sprintf(ret_string,"SELECT %s.%s FROM %s,%s WHERE %s.%s = %s.%s AND %s.%s ", tbl_name[table1] , $2 ,tbl_name[table1] , tbl_name[table2] , tbl_name[table1] , common , tbl_name[table2] , common ,tbl_name[table2] ,$4) ;	
																	}
																	strcat(ret_string,condi); 	
																	sprintf(error_string,"Success with rule :	 query FIELD TABLE FIELD condition (join)") ;
																}																
			|   query TABLE FIELD FIELD condition EOL			{ 	
																	int table1 = get_table($3);
																	int table2 = get_table($4);
																	char condi[20];
																	strcpy(condi,tempe); 
																	if(table1==table2)
																	{
																		sprintf(ret_string,"SELECT  %s FROM %s WHERE %s", $3,tbl_name[table1],$4);
																		sprintf(error_string,"Success with rule :	 query TABLE FIELD FIELD condition") ;
																	}
																	
																	else
																	{
																		char common[20];																		
																		strcpy(common,get_common(table1,table2));
																		sprintf(ret_string,"SELECT %s.%s FROM %s,%s WHERE %s.%s = %s.%s AND %s.%s ", tbl_name[table1] , $3 ,tbl_name[table1] , tbl_name[table2] , tbl_name[table1] , common , tbl_name[table2] , common ,tbl_name[table2] ,$4) ;	
																	}
																	strcat(ret_string,condi); 	
																	sprintf(error_string,"Success with rule :	 query TABLE FIELD FIELD condition(join)") ;
																}
																																			
																	
			|	query FIELD WORDQ FIELD TABLE FIELD condition EOL 	{ 	
																			int table1 = get_table($2);
																			int table2 = get_table($4);
																			int ftable = get_table($6);
																			char condi[50];
																			strcpy(condi,tempe); 
																			if(table1==table2 && table1==ftable)
																			{
																				sprintf(ret_string,"SELECT  %s,%s  FROM %s WHERE %s", $2,$4,tbl_name[table1],$6);
																			}
																			
																			else if(table1==table2 && table1!=ftable)
																			{
																				char common[50];																		
																				strcpy(common,get_common(table1,ftable));
																				sprintf(ret_string,"SELECT %s.%s , %s.%s FROM %s,%s WHERE %s.%s = %s.%s AND %s.%s ", tbl_name[table1] , $2, tbl_name[table2] , $4      ,tbl_name[table1] , tbl_name[ftable]      , tbl_name[table1] , common , tbl_name[ftable] , common ,     tbl_name[ftable] ,$6) ;	
																			}
																			else if(table1!=table2 && table2==ftable)
																			{
																				char common[50];																		
																				strcpy(common,get_common(table1,ftable));
																				sprintf(ret_string,"SELECT %s.%s , %s.%s FROM %s,%s WHERE %s.%s = %s.%s AND %s.%s ", tbl_name[table1] , $2, tbl_name[table2] , $4      ,tbl_name[table1] , tbl_name[ftable]      , tbl_name[table1] , common , tbl_name[ftable] , common ,     tbl_name[ftable] ,$6) ;	
																			}
																			else if(table1!=table2 && table1==ftable)
																			{
																				char common[50];																		
																				strcpy(common,get_common(table2,ftable));
																				sprintf(ret_string,"SELECT %s.%s , %s.%s FROM %s,%s WHERE %s.%s = %s.%s AND %s.%s ", tbl_name[table1] , $2, tbl_name[table2] , $4      ,tbl_name[table2] , tbl_name[ftable]      , tbl_name[table2] , common , tbl_name[ftable] , common ,     tbl_name[ftable] ,$6) ;	
																			}
																			strcat(ret_string,condi); 	
																			sprintf(error_string,"Success with rule :query FIELD WORDQ FIELD TABLE FIELD condition") ;
			
																		}																
			| 	query TABLE FIELD WORDQ FIELD FIELD condition EOL 	{ 	
																				int table1 = get_table($3);
																				int table2 = get_table($5);
																				int ftable = get_table($6);
																				char condi[50];
																				strcpy(condi,tempe); 
																				if(table1==table2 && table1==ftable)
																				{
																					sprintf(ret_string,"SELECT  %s,%s  FROM %s WHERE %s", $3,$5,tbl_name[table1],$6);
																				}
																				
																				else if(table1==table2 && table1!=ftable)
																				{
																					char common[20];																		
																					strcpy(common,get_common(table1,ftable));
																					sprintf(ret_string,"SELECT %s.%s , %s.%s FROM %s,%s WHERE %s.%s = %s.%s AND %s.%s ", tbl_name[table1] , $3, tbl_name[table2] , $5      ,tbl_name[table1] , tbl_name[ftable]      , tbl_name[table1] , common , tbl_name[ftable] , common ,     tbl_name[ftable] ,$6) ;	
																				}
																				else if(table1!=table2 && table2==ftable)
																				{
																					char common[20];																		
																					strcpy(common,get_common(table1,ftable));
																					sprintf(ret_string,"SELECT %s.%s , %s.%s FROM %s,%s WHERE %s.%s = %s.%s AND %s.%s ", tbl_name[table1] , $3, tbl_name[table2] , $5      ,tbl_name[table1] , tbl_name[ftable]      , tbl_name[table1] , common , tbl_name[ftable] , common ,     tbl_name[ftable] ,$6) ;	
																				}
																				else if(table1!=table2 && table1==ftable)
																				{
																					char common[20];																		
																					strcpy(common,get_common(table2,ftable));
																					sprintf(ret_string,"SELECT %s.%s , %s.%s FROM %s,%s WHERE %s.%s = %s.%s AND %s.%s ", tbl_name[table1] , $3, tbl_name[table2] , $5      ,tbl_name[table2] , tbl_name[ftable]      , tbl_name[table2] , common , tbl_name[ftable] , common ,     tbl_name[ftable] ,$6) ;	
																				}
																				strcat(ret_string,condi); 	
																				sprintf(error_string,"Success with rule :	query TABLE FIELD WORDQ FIELD FIELD condition ") ;
				
																			}


			|	query TABLE WORDQ TABLE EOL	{
												char common[20];
												int table1=0,table2=0;
												table1=table_id($2);
												table2=table_id($4);
												strcpy(common,get_common(table1,table2));
												sprintf(ret_string,"SELECT * FROM %s , %s  WHERE %s.%s = %s.%s", tbl_name[table1] , tbl_name[table2] , tbl_name[table1] , common , tbl_name[table2] , common) ;
												sprintf(error_string,"Success with rule :	query TABLE WORDQ TABLE (join)") ;
											}

			|	query TABLE TABLE EOL		{
														char common[20];
														int table1=0,table2=0;
														table1=table_id($2);
														table2=table_id($3);
														strcpy(common,get_common(table1,table2));
														sprintf(ret_string,"SELECT * FROM %s , %s  WHERE %s.%s = %s.%s", tbl_name[table1] , tbl_name[table2] , tbl_name[table1] , common , tbl_name[table2] , common) ;
														sprintf(error_string,"Success with rule :	query TABLE TABLE  (join)") ;
											}

			|    query FIELD EOL  			{    sprintf(ret_string,"SELECT %s  FROM %s", $2, tbl_name[get_table($2)]) ;	
													sprintf(error_string,"Success with rule :	  query FIELD") ;
											}
		
			|    query FIELD WORDQ FIELD EOL{  
												int table1 = get_table($2);
												int table2 = get_table($4);
												if(table1==table2)
												{
													sprintf(ret_string,"SELECT %s ,%s FROM %s ", $2 , $4 ,tbl_name[table1]) ;
													sprintf(error_string,"Success with rule :	 query FIELD WORDQ FIELD") ;
												}
												else
												{
												char common[20];
													strcpy(common,get_common(table1,table2));
													sprintf(ret_string,"SELECT %s.%s , %s.%s FROM %s , %s  WHERE %s.%s = %s.%s", tbl_name[table1] , $2 , tbl_name[table2] , $4 ,tbl_name[table1] , tbl_name[table2] , tbl_name[table1] , common , tbl_name[table2] , common) ;
													sprintf(error_string,"Success with rule :	 query FIELD WORDQ FIELD (join)") ;
												}
											 }
			
			;



count   :  		ask_count TABLE EOL							{ sprintf(ret_string,"SELECT COUNT(*) FROM %s", $2) ;	sprintf(error_string,"Success with rule :	 ask_count TABLE ") ;}
		|  		ask_count TABLE ENQUIRE EOL  				{ sprintf(ret_string,"SELECT COUNT(*) FROM %s", $2) ; 	sprintf(error_string,"Success with rule :	 ask_count TABLE ENQUIRE ") ;}

    	|    	query TABLE MOJ EOL   						{ sprintf(ret_string,"SELECT COUNT(*) FROM %s", $2) ; sprintf(error_string,"Success with rule :	 query TABLE MOJ ") ;}
               
        |    	ask_count TABLE  FIELD  INPUT ENQUIRE EOL	{ 
																	int table1 = table_id($2);
																	int ftable2 = get_table($3);
																	if(table1==ftable2)
																	{
																		sprintf(ret_string,"SELECT COUNT(*) FROM %s WHERE %s = %s", $2,$3,$4) ;
																		sprintf(error_string,"Success with rule :	 ask_count TABLE  FIELD  INPUT ENQUIRE") ;
																	}
																	else
																	{
																		char common[20];
																		strcpy(common,get_common(table1,ftable2));
																		sprintf(ret_string,"SELECT COUNT(*) FROM %s,%s WHERE %s.%s = %s.%s AND %s.%s = %s", tbl_name[table1] , tbl_name[ftable2] ,     tbl_name[table1] , common , tbl_name[ftable2] , common ,     tbl_name[ftable2],$3,$4) ;	
																		sprintf(error_string,"Success with rule :	 ask_count TABLE  FIELD  INPUT ENQUIRE (join)") ;
																	}
		
															}
               
        |    	ask_count TABLE  FIELD condition EOL		{ 	 
																char condi[50];
																strcpy(condi,tempe); 
																int table1 = table_id($2);
																int ftable2 = get_table($3);
																if(table1==ftable2){
																	sprintf(ret_string,"SELECT COUNT(*) FROM %s WHERE %s ", $2,$3) ;
																}
																else
																{
																	char common[20];
																	strcpy(common,get_common(table1,ftable2));
																	sprintf(ret_string,"SELECT COUNT(*) FROM %s,%s WHERE %s.%s = %s.%s AND %s.%s", tbl_name[table1] , tbl_name[ftable2] ,     tbl_name[table1] , common , tbl_name[ftable2] , common ,     tbl_name[ftable2],$3) ;	
																}
																strcat(ret_string,condi); 
																sprintf(error_string,"Success with rule :	 	ask_count TABLE  FIELD condition") ;
															}
               
		|    	ask_count TABLE  ENQUIRE FIELD condition EOL{ 	
																char condi[20];
																strcpy(condi,tempe); 
																int table1 = table_id($2);
																int ftable2 = get_table($4);
																if(table1==ftable2){
																	sprintf(ret_string,"SELECT COUNT(*) FROM %s WHERE %s ", $2,$4) ;
																}
																else
																{
																	char common[20];
																	strcpy(common,get_common(table1,ftable2));
																	sprintf(ret_string,"SELECT COUNT(*) FROM %s,%s WHERE %s.%s = %s.%s AND %s.%s", tbl_name[table1] , tbl_name[ftable2] ,     tbl_name[table1] , common , tbl_name[ftable2] , common ,     tbl_name[ftable2],$4) ;	
																}
																strcat(ret_string,condi);  
																sprintf(error_string,"Success with rule :	 ask_count TABLE  ENQUIRE FIELD condition") ;
															}

		;








query 			: 	ask|QUESTION;
ask				: 	REPLY | REPLY TO_ME ;

ask_count		:	ask MOJ | MOJ  ;

condition   	:   equal
				|   greater_than
				|   less_than
				|   between
				;

equal       	:  	PRE_EQUAL INPUT					{ 	strcpy(tempe," = ");strcat(tempe,$2);}
				|	INPUT							{ 		strcpy(tempe," = ");strcat(tempe,$1);}
				;

greater_than   	:   PRE_GREATER INPUT				{    strcpy(tempe , " > ") ; strcat(tempe , $2) ;}
	      		;

less_than   	:   PRE_LESS INPUT					{strcpy(tempe , " < ") ; strcat(tempe , $2) ;}
				;

between    		:   PRE_BETWEEN INPUT WORDQ INPUT	{
													strcpy(tempe , " BETWEEN " ) ;
													strcat(tempe , $2 ) ;
													strcat(tempe , " AND ") ;
													strcat(tempe , $4 ) ;
												}
				;






	
%%
int get_table(char *field)
{

			int i,j,cmp , out = 0 ;
			for(i=0 ; i < tbl_count && out ==0 ; i++)
			{
				//printf("\n%d. ---%s\n",i+1,tbl_name[i]);
				for(j=0 ; j<tbl_column_count[i] ; j++)
				{
					cmp = strcmp(field ,tbl_column_name[i][j]);
					if(cmp == 0)
					{
						out = 1 ;
					}
				}
			}
			
		return i-1;
}
int table_id(char *field)
{

			int i,cmp , out = 0 ;
			for(i=0 ; i < tbl_count && out ==0 ; i++)
			{
				
					cmp = strcmp(field ,tbl_name[i]);
					if(cmp == 0)
					{
						out = 1 ;
					}
				
			}
			
		return i-1;
}
char* get_common(int table1,int table2)
{
		int i, result = 1  ;
			
		for(i=0 ; i<tbl_column_count[table2] && result != 0; i++)
		{	
					result = strcmp(tbl_column_name[table1][0] , tbl_column_name[table2][i] ) ;
					if(result == 0)
					{
						strcpy(tempe , tbl_column_name[table1][0] ) ;
					}
		}
		for(i=0 ; i<tbl_column_count[table1] && result != 0; i++)
		{	
					result = strcmp(tbl_column_name[table2][0] , tbl_column_name[table1][i] ) ;
					if(result == 0)
					{
						strcpy(tempe , tbl_column_name[table2][0] ) ;
					}
		}
		return tempe;
}


