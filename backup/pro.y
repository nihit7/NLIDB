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

char tempe[50];

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
	else if(strstr (str,"EOL")!=NULL)
	{
		sprintf(error_string,"Faliure!  NLPError : %s " , str) ;
		sprintf(ret_string,"Please end the sentence with a punctuation mark") ;
	}
	else
	{
		sprintf(error_string,"Faliure!  NLPError : %s " , str) ;
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

  
select  	:   query TABLE EOL									{	sprintf ( ret_string,  "1. SELECT DISTINCT * FROM %s",$2)	;sprintf(error_string,"Success") ;}

			|   query FIELD TABLE EOL      						{
																	int table1 = table_id($3);
																	int ftable2 = get_table($2);
																	if(table1==ftable2){
																		sprintf(ret_string,"2a.SELECT %s  FROM %s",$2,$3) ;	
																		sprintf(error_string,"Success") ;
																	}
																	else
																	{
																		char common[20];
																		strcpy(common,get_common(table1,ftable2));
																		sprintf(ret_string,"2aj.SELECT %s.%s  FROM %s,%s WHERE %s.%s = %s.%s",tbl_name[ftable2] ,$2, tbl_name[table1] , tbl_name[ftable2] , tbl_name[table1] , common , tbl_name[ftable2] , common) ;	
																	}
																}
			|   query TABLE FIELD EOL							{
																	int table1 = table_id($2);
																	int ftable2 = get_table($3);
																	if(table1==ftable2){
																		sprintf(ret_string,"2b.SELECT %s  FROM %s",$3,$2) ;	
																		sprintf(error_string,"Success") ;
																	}
																	else
																	{
																		char common[20];
																		strcpy(common,get_common(table1,ftable2));
																		sprintf(ret_string,"2aj.SELECT %s.%s  FROM %s,%s WHERE %s.%s = %s.%s",tbl_name[ftable2] ,$3, tbl_name[table1] , tbl_name[ftable2] , tbl_name[table1] , common , tbl_name[ftable2] , common) ;	
																	}
																}
																
																
			|  	query  FIELD WORDQ FIELD TABLE EOL   			{	sprintf(ret_string,"3a.SELECT %s, %s FROM %s",$2 ,$4,$5) ;	sprintf(error_string,"Success") ;  }
			|  	query TABLE FIELD WORDQ FIELD EOL 				{	sprintf(ret_string,"3b.SELECT %s, %s FROM %s",$3 ,$5,$2) ; 	sprintf(error_string,"Success") ; }

			|   query TABLE condition EOL  						{ 	sprintf(ret_string,"4. SELECT  * FROM %s ", $2);
																	strcat(ret_string,tempe); 	sprintf(error_string,"Success") ;}
			|   query FIELD TABLE condition EOL					{ 	sprintf(ret_string,"5a. SELECT  %s FROM %s ", $2,$3);
																	strcat(ret_string,tempe);	sprintf(error_string,"Success") ; }
			|   query TABLE FIELD condition EOL					{ 	sprintf(ret_string,"5b. SELECT  %s FROM %s ", $3,$2);
																	strcat(ret_string,tempe); 	sprintf(error_string,"Success") ;}

			|	query FIELD WORDQ FIELD TABLE condition EOL 	{ 	sprintf(ret_string,"6a. SELECT  %s,%s FROM %s ", $2,$4,$5);
																	strcat(ret_string,tempe);	sprintf(error_string,"Success") ; }
			| 	query TABLE FIELD WORDQ FIELD condition EOL 	{ 	sprintf(ret_string,"6b. SELECT  %s,%s FROM %s ", $3,$5,$2);
																	strcat(ret_string,tempe); 	sprintf(error_string,"Success") ;}


			|	query TABLE WORDQ TABLE EOL	{
												char common[20];
												int i,res,table1=0,table2=0;
												table1=table_id($2);
												table2=table_id($4);
												strcpy(common,get_common(table1,table2));
												sprintf(ret_string,"7a. SELECT * FROM %s , %s  WHERE %s.%s = %s.%s", tbl_name[table1] , tbl_name[table2] , tbl_name[table1] , common , tbl_name[table2] , common) ;
												sprintf(error_string,"Success") ;
											}


			|	query TABLE TABLE EOL
										{
													char common[20];
													int i,res,table1=0,table2=0;
													table1=table_id($2);
													table2=table_id($3);
													strcpy(common,get_common(table1,table2));
													sprintf(ret_string,"7b.SELECT * FROM %s , %s  WHERE %s.%s = %s.%s", tbl_name[table1] , tbl_name[table2] , tbl_name[table1] , common , tbl_name[table2] , common) ;
													sprintf(error_string,"Success") ;
										}

		|    query FIELD EOL  			{    sprintf(ret_string,"8.SELECT %s  FROM %s", $2, tbl_name[get_table($2)]) ;	sprintf(error_string,"Success") ;}
	
		|    query FIELD WORDQ FIELD EOL
										{  
											char common[20];
											int table1 = get_table($2);
											int table2 = get_table($4);
											
											if(table1==table2)
											{
												sprintf(ret_string,"9.SELECT %s ,%s FROM %s ", $2 , $4 ,tbl_name[table1]) ;
											}
											else
											{
												strcpy(common,get_common(table1,table2));
												
												sprintf(ret_string,"9.SELECT %s.%s , %s.%s FROM %s , %s  WHERE %s.%s = %s.%s", tbl_name[table1] , $2 , tbl_name[table2] , $4 ,tbl_name[table1] , tbl_name[table2] , tbl_name[table1] , common , tbl_name[table2] , common) ;
												sprintf(error_string,"Success") ;
											}
										 }
	    
	    ;



count   :  		ask_count TABLE EOL				{ sprintf(ret_string,"c1a.SELECT COUNT(*) FROM %s", $2) ;	sprintf(error_string,"Success") ;}
		|  		ask_count TABLE ENQUIRE EOL  { sprintf(ret_string,"c1b.SELECT COUNT(*) FROM %s", $2) ; 	sprintf(error_string,"Success") ;}

    	|    	query TABLE MOJ EOL   		{ sprintf(ret_string,"c2.SELECT COUNT(*) FROM %s", $2) ; }
               
        |    	ask_count TABLE  FIELD  INPUT ENQUIRE EOL	{ sprintf(ret_string,"c3.SELECT COUNT(*) FROM %s WHERE %s = %s", $2,$3,$4) ; }
               

        |    	ask_count TABLE  condition EOL	{ 	 sprintf(ret_string,"c4. SELECT COUNT(*)  FROM %s ", $2);
														strcat(ret_string,tempe); }
               
		|    	ask_count TABLE  ENQUIRE condition EOL{ 	 sprintf(ret_string,"c4. SELECT COUNT(*)  FROM %s ", $2);
															strcat(ret_string,tempe); }

		;








query 		: ask|QUESTION;
ask			: REPLY | REPLY TO_ME ;

ask_count	:ask MOJ | MOJ  ;

condition   :    equal
	    	|    greater_than
		    |    less_than
		    |    between

		    ;

equal       :    FIELD PRE_EQUAL INPUT
                     	{ 	strcpy(tempe,"WHERE ");
							strcat(tempe,$1);strcat(tempe," = ");strcat(tempe,$3);
						}
			|	FIELD INPUT
                     	{ 		strcpy(tempe,"WHERE ");
							strcat(tempe,$1);strcat(tempe," = ");strcat(tempe,$2);
						}
 	    	;

greater_than   :   FIELD PRE_GREATER INPUT
								{   strcpy(tempe , "WHERE ") ;
									strcat(tempe , $1) ; strcat(tempe , " > ") ; strcat(tempe , $3) ;
								}
	      		;

less_than   	:   FIELD PRE_LESS INPUT
								{
									strcpy(tempe , "WHERE " ) ;
									strcat(tempe , $1) ;
									strcat(tempe , " < ") ; strcat(tempe , $3) ;
								}
				;

between    :    FIELD PRE_BETWEEN INPUT WORDQ INPUT
									{
										strcpy(tempe , "WHERE " ) ;
										strcat(tempe , $1 ) ;
										strcat(tempe , " >= " ) ;
										strcat(tempe , $3 ) ;
										strcat(tempe , " AND ") ;
										strcat(tempe , $1 ) ;
										strcat(tempe , " <= " ) ;
										strcat(tempe , $5 ) ;
									}
				;






	
%%
int get_table(char *field)
{

			int i,j,cmp , out = 0 ;
			char table[50] ;
			for(i=0 ; i < tbl_count && out ==0 ; i++)
			{
				//printf("\n%d. ---%s\n",i+1,tbl_name[i]);
				for(j=0 ; j<tbl_column_count[i] ; j++)
				{
					cmp = strcmp(field ,tbl_column_name[i][j]);
					if(cmp == 0)
					{
						out = 1 ;
						strcpy(table , tbl_name[i] ) ;
					}
				}
			}
			
		return i-1;
}
int table_id(char *field)
{

			int i,j,cmp , out = 0 ;
			char table[50] ;
			for(i=0 ; i < tbl_count && out ==0 ; i++)
			{
				
					cmp = strcmp(field ,tbl_name[i]);
					if(cmp == 0)
					{
						out = 1 ;
						strcpy(table , tbl_name[i] ) ;
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


