#include<stdio.h>
#include"nlp.h"
int main()
{
			initialize_db("data\\database.txt");

			char input[100] = "who wrote the book titled Hamlet?";
			char output[100];
			strcpy(output,convert_sql(input));
	        printf("%s\n",input);
	        printf("%s\n",output);
			return 0 ;
}
