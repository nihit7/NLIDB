#include<stdio.h>
#include"nlp.h"

int main() 
{
		initialize_db("data\\database.txt");
			
			int i,j;
			for(i=0;i<tbl_count;i++)
			{
				printf("\n%s\n",tbl_name[i]);
					for(j=0;j<tbl_column_count[i];j++)
					{
                        printf("--%s\n",tbl_column_name[i][j]);
					}
			}
			for(i=0;i<alias_count;i++)
			{
                 printf("%s<=>%s\n",alias_name[i],alias_map[i]);
			}
			
		char line[200];
		int temp=0;
		int sessions=0,gtotal=0,gcorrect=0,gincorr=0,gfail=0,gsucc=0;
		FILE *f = fopen ("data\\stats.txt", "r");
  
		fscanf(f,"%s %d",line,&sessions);
    	printf("1session%d\n",sessions);
	
		fclose(f);
		sessions++;
		temp=sessions;
		char output[20];
		sprintf(output,"data\\session%d.txt",sessions);
		
   		FILE *fr = fopen ("data\\queries.txt", "rt");
   		f = fopen (output , "w") ;
		int total=0,corr=1,incorr=0,fail=0,succ=0;
		fprintf(f,"Session No. %d \n\n",sessions);
		fprintf(f,"database.txt \n");
		time_t current_time;
            char* c_time_string;
              current_time = time(NULL);
             c_time_string = ctime(&current_time);
             fprintf(f,"Start Time  -> %s  \n\n\n\n",c_time_string);
   		while(fgets(line, 200, fr) != NULL)
   		{
            //convert_sql(line);
            total++;
            line[strlen(line)-1]='\0';
            //printf("\n%d. Query : %s\n",total,line);
			//printf("\t\t%s\n",convert_sql(line));
				//if(!success())printf("\n%s\n\n",message());
			 fprintf(f,"\n%2d. Query: %-80s",total,line);
		fprintf(f," %-100s",convert_sql(line));
		fprintf(f,"  %s",message());
			
			if(success())
			{
					succ++;
					/*printf("Is the query correct?(y/n)");
					char ch = 'y';
					if(ch=='y')
					{
					    fprintf(f,"\nCORRECT QUERY!!!\n\n");
					    correct++;
					}
					else
					{
					     fprintf(f,"\nINCORRECT QUERY!!!\n\n");
					     incorr++;
					}*/
			}
			else
			{
				fail++;
				/*gfail++;
					printf("Do you want to view the error?(y/n)");
				//	char ch = getch();
					//if(ch=='y')
					    fprintf(f,"\n%s\n\n",message());*/
			}
		}
		fclose(fr);
		corr=succ;
		
		
		printf("1session%d\n",sessions);
		
		 fprintf(f,"\n\n\n\nSTATISTICS\n");
            fprintf(f,"Total queries fired -> %d\n",total);
            fprintf(f,"Success             -> %d\n",succ);
            fprintf(f,"Correct results     -> %d\n",corr);
            fprintf(f,"Incorrect reults    -> %d\n",incorr);
            fprintf(f,"Failures            -> %d\n\n",fail);
            if(total)fprintf(f,"Success Rate        -> %d%%   \n",succ*100/total);
            if(corr+incorr)fprintf(f,"Correctness         -> %d%%  \n",corr*100/(corr+incorr));

           
              current_time = time(NULL);
             c_time_string = ctime(&current_time);
             fprintf(f,"End Time            -> %s  \n",c_time_string);

            fclose(f);

            char sline[40];
            sprintf(sline,"data\\stats.txt");
            f = fopen (sline, "w");
            fprintf(f,"Sessions %d",temp);
            fclose(f);

            char sessionpath[50];
            sprintf(sessionpath,"data\\sessioninfo.csv");

            int exist =0;
            if( (f = fopen (sessionpath , "r")) )
            {
                exist=1;
                fclose(f);
            }

            f = fopen (sessionpath , "a") ;
            if(exist==0)
            {
                fprintf(f,"Session,Total,Success,Failure,Correct,Incorrect,Successrate,Correctness,");
            }
            fprintf(f,"\n%d,%d,%d,%d,%d,%d,",sessions,total,succ,fail,corr,incorr);
            if(total)fprintf(f,"%d,",succ*100/total);
            else fprintf(f,"0,");
            if(corr+incorr)fprintf(f,"%d,",corr*100/(corr+incorr));
            else fprintf(f,"0,");
            fclose(f);
		getch();
		return 0 ;
}
