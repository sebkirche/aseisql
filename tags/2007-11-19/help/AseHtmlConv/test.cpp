#include <windows.h>
#include <stdlib.h>
#include <stdio.h>
#include <io.h>
#include <SHARE.H>

bool swap(char*src,char*dst){
	if(!CopyFile(src,dst,false)){
		printf("can't copy \"%s\" to \"%s\"\n",src,dst);
		return false;
	}
	if(remove(src)){
		printf("can't remove \"s\"\n",src);
		return false;
	}
	return true;
}

bool Access(char*f,DWORD dwDesiredAccess){
	//dwDesiredAccess=0 | GENERIC_READ | GENERIC_WRITE
	HANDLE h=CreateFile(f,dwDesiredAccess,FILE_SHARE_READ|FILE_SHARE_WRITE,NULL,OPEN_EXISTING,
		FILE_ATTRIBUTE_NORMAL,
		NULL);
	if(h==INVALID_HANDLE_VALUE){
		//printf("file not accessible \"%s\"\n",f);
		return false;
	}
	CloseHandle(h);
	return true;
}

bool format(char*src){
	if(!Access(src,GENERIC_WRITE))return false;
	
	char * tmp="format.tmp";
	FILE* fr=_fsopen(src,"rt",SH_DENYRW);
	if(!fr){
		printf("can't open file %s\n",src);
		return false;
	}
	FILE* fw=_fsopen(tmp,"wt",SH_DENYRW);
	bool nlf=true;
	char c;
	
	if(fw){
		while( (c = getc( fr )) != EOF ){
			if( c=='<' ){
				if(!nlf)putc('\n',fw);
				nlf=true;
				putc(c,fw);
			}else if( c=='>' ){
				putc(c,fw);
				if(!nlf)putc('\n',fw);
				nlf=true;
			}else if( c=='\n' ){
				//if(!nlf)putc('\n',fw);
				//nlf=true;
				putc(' ',fw);
			}else{
	        	putc(c,fw);
				nlf=false;
			}
		}
	}else{
		printf("can't open file %s\n",tmp);
		fclose(fr);
		return false;
	}
	fclose(fr);
	fflush(fw);
	fclose(fw);
	return swap(tmp,src);
}

bool unformat(char*src){
	if(!Access(src,GENERIC_WRITE))return false;
	
	char * tmp="unformat.tmp";
	FILE* fr=_fsopen(src,"rt",SH_DENYRW);
	if(!fr){
		printf("can't open file %s\n",src);
		return false;
	}
	FILE* fw=_fsopen(tmp,"wt",SH_DENYRW);
	char c;
	
	if(fw){
		while( (c = getc( fr )) != EOF ){
			if( c=='\n' ){
				//putc(c,fw);
			}else if( c=='\r' ){
				//putc(c,fw);
			}else{
	        	putc(c,fw);
			}
		}
	}else{
		printf("can't open file %s\n",tmp);
		fclose(fr);
		return false;
	}
	fclose(fr);
	fflush(fw);
	fclose(fw);
	return swap(tmp,src);
}



bool chtitle(char*src,char*title,int nest){
//	for(int i=1;i<nest;i++)printf("  ");
//	printf("processing \"%s\"\n",src);
	char buf[4000];
	char link[4000];
	if(!format(src))return false;
	FILE*tmp=tmpfile();
	if(!tmp){
		printf("can't create temp file\n");
		return false;
	}
	FILE*f=_fsopen(src,"rt",SH_DENYRW);
	if(!f){
		fclose(tmp);
		printf("can't open file \"%s\"\n",src);
		return false;
	}
	while(fgets(buf,sizeof(buf),f)){
		if( !strcmpi("<title>\n",buf) ){
			fputs(buf,tmp);
			fputs(title,tmp);
			fputs("\n",tmp);
			while(fgets(buf,sizeof(buf),f)){
				if( !strcmpi("</title>\n",buf) )break;
			}
			fputs(buf,tmp);
		}else if( !strnicmp("<a name=\"#",buf,10) ){
			fputs("<a name=\"",tmp);
			fputs(buf+10,tmp);
		}else if( !strnicmp("<a href=\"",buf,9) ){
			fputs(buf,tmp);
			strcpy(link,buf+9);
			char*cc=strchr(link,'\"');
			if(cc)cc[0]=0;
			if( !Access(link,0) ){
				printf("\"%s\" wrong link? \"%s\"\n",src,link);
			}else{
//				strncat(title," :: ",4000-1);
				strcpy(title,"");
				while(fgets(buf,sizeof(buf),f)){
					fputs(buf,tmp);
					if( !strcmpi("</a>\n",buf) )break;
					strncat(title,buf,4000-1);
				}
				chtitle(link,title,nest+1);
			}
		}else{
			fputs(buf,tmp);
		}
	}
	
	//now copy tmp back to original file
	fflush(tmp);
	fseek( tmp, 0, SEEK_SET );
	fclose(f);
	f=_fsopen(src,"wt",SH_DENYRW);
	if(!f){
		fclose(tmp);
		printf("can't open file \"%s\"\n",src);
		return false;
	}
	char c;
	while( (c = fgetc( tmp )) != EOF )
		fputc( c, f );
	fflush( f );
	fclose( f );
	fclose( tmp );
	
	unformat(src);
	return true;
	
}


int main(int argc, char* argv[])
{
	if(argc!=3){printf("two parameters required\n");return 1;}
	char title[4000];
	strcpy(title,argv[2]);
	chtitle(argv[1],title,1);
	return 0;
}

