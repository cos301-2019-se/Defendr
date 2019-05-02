#include <stdio.h>
#include <stdlib.h>

int main(){
	FILE *fp,*outputfile;
	char var[40];
	//inster commad here
	fp = popen("sudo ./test", "r");
	while (fgets(var, sizeof(var), fp) != NULL) 
	{
	  printf("%s", var);
	}
	pclose(fp);
	//wirte answer to file text
	outputfile = fopen("text.txt", "a");
	fprintf(outputfile,"%s\n",var);
	return 0;
}
