#include<stdio.h>
#include<stdlib.h>
#include<string.h>

const char* findIp(char ip[]){
    //get file name
    int length = strlen(ip);
    int counter=0;
    char fileName[length];
    for(counter=0;counter<length;counter++){
        if(ip[counter]=='.'){
            fileName[counter]='_';
        }else{
            fileName[counter]=ip[counter];
        }
    }
    char type[]=".txt";
    strcat(fileName,type);

    //excute commad for ip
    char command[50]="wget -O ";
    strcat(command, fileName);
    char url[]=" http://api.ipfind.com/?ip=";
    strcat(command, url);
    strcat(command, ip);

    system(command);
    system("reset");

    //get code
    char code[50]="";
    char file[1000]="";
    char ch;
    int pos=0;
    FILE *fptr;
    fptr = fopen(fileName,"r");
    if(fptr ==NULL){
        printf("error");
        return "error";
    }
    for(counter=0; (counter<1000)&&((ch= fgetc(fptr))!=EOF); counter++){
        file[counter]=ch;
    }
    for(counter=28+length; counter<1000;counter++){
       if(file[counter]=='y'&&file[counter+1]=='_'&&file[counter+2]=='c'&&file[counter+3]=='o'&&file[counter+4]=='d'&&file[counter+5]=='e'){
           counter=counter+9;
           while(file[counter]!='"'){
               code[pos]=file[counter];
               pos=pos+1;
               counter=counter+1;
           }
       }
    }

    //remove file
    char commentRemove[] ="rm ";
    strcat(commentRemove,fileName);
    system(commentRemove);

    printf("%s\n",code);

    return code;
}

int main(){
    findIp("8.8.8.8");
    return 0;
}