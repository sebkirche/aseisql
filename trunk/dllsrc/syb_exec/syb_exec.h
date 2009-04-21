#define WIN32_LEAN_AND_MEAN		// Exclude rarely-used stuff from Windows headers
#include <windows.h>
#include <ctpublic.h>
#include <stdlib.h>
#include <stdio.h>

#define APP_NAME "syb exec"

#define PEM_RESULTSET	WM_USER+0	//pbm_custom01
#define PEM_INSERT_ROW	WM_USER+1
#define PEM_SET_FIELD	WM_USER+2
#define PEM_LOG_MESSAGE	WM_USER+3
#define PEM_DIRECTORY	WM_USER+4
#define PEM_SQL_MESSAGE	WM_USER+5
#define PEM_RES_INFO	WM_USER+6
#define PEM_DIR_INFO	WM_USER+7

#define LOG_MSG_INFO	0
#define LOG_MSG_ERROR	1

#define RS_INFO_ROWS      1
#define RS_INFO_RET       2
#define RS_INFO_BR_TABLE  3


#define RS_TYPE_DAT	0
#define RS_TYPE_RET	1
#define RS_TYPE_OUT	2

#define RET_CANCEL	1
#define RET_CONTINUE	0

#define PROP_FORMAT_DATETIME	0

#define DATETIME_FORMAT_NATIVE	1
#define DATETIME_FORMAT_SQL_S	2
#define DATETIME_FORMAT_SQL_MS	3


typedef struct{
	long msgnumber;
	long severity;
	char *proc;
	long line;
	char *text;
}SQLMESSAGE;


#define LOG(hwnd,msg)	SendMessage(hwnd,PEM_LOG_MESSAGE,LOG_MSG_INFO,(LPARAM)msg)
//#define ERR(hwnd,msg)	SendMessage(hwnd,PEM_LOG_MESSAGE,LOG_MSG_ERROR,(LPARAM)msg)
#define RES(hwnd,type,colcount)	SendMessage(hwnd,PEM_RESULTSET,type,colcount)
//moved to function//#define ROW(hwnd,row)	SendMessage(hwnd,PEM_INSERT_ROW,row,0)
#define FLD(hwnd,col,val)	SendMessage(hwnd,PEM_SET_FIELD,col,(LPARAM)val)
#define DIR(hwnd,val)	SendMessage(hwnd,PEM_DIRECTORY,0,(LPARAM)val)
#define DIR_INFO(hwnd,key,val)	SendMessage(hwnd,PEM_DIR_INFO,(WPARAM)key,(LPARAM)val)
//#define SQLERR(hwnd,errnumber,severity,errtext)	SendMessage(hwnd,PEM_SQL_ERROR,MAKELONG(errnumber,severity),(LPARAM)errtext)
//#define SQLERR(hwnd,errinf,errtext)	SendMessage(hwnd,PEM_SQL_ERROR,(WPARAM)errinf,(LPARAM)errtext)
#define INFO(hwnd,type,sdata)	SendMessage(hwnd,PEM_RES_INFO,type,(LPARAM)sdata)

#define RET_ON_FAIL(ret, hwnd, msg)	if(ret!=CS_SUCCEED){ERR(hwnd,msg);return CS_FAIL;} 

#define MAX(a,b)	(a>b?a:b)
#define MIN(a,b)	(a<b?a:b)

//#define MAX_VALUE_BUF 800


extern "C" CS_RETCODE ERR(HWND hwnd, char * msg, int i=0);

//
#define MAX_FLD_NAME CS_MAX_NAME+10+40

typedef struct _columndata{
	char		*data;
	CS_INT		len;  //fetched length
	CS_SMALLINT ind; //-1 if null
	CS_INT		charlen; //display length
	CS_INT		bytelen; //number of bytes needed to receive data as multibyte characters (suppose utf8)
	CS_INT		type;    //destination type, used to do final conversion
}COLUMNDATA;

//#define MYDEBUG

#ifdef MYDEBUG

extern FILE *flog;
#define DBG(i) i

#else
#define DBG(i) 
#endif
