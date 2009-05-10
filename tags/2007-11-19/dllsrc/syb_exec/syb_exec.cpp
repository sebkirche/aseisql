
#include "syb_exec.h"
#include "mstring.h"
//#include <locale.h>
extern "C"{

DBG(FILE *flog=NULL);

HWND public_hwnd;
long public_datetime_format=1;
long MAXBUFSIZE=32767;

CS_RETCODE ERR(HWND hwnd, char * msg, int i){
	if(msg){
		char*buf=new char[strlen(msg)+20];
		sprintf(buf,msg,i);
		SendMessage(hwnd,PEM_LOG_MESSAGE,LOG_MSG_INFO,(LPARAM)buf);
		delete []buf;
	}
	return CS_FAIL;
}

//sends notification to intervace about new row incoming
//returns false if user want to cancel data transfer
BOOL ROW(HWND hwnd, CS_COMMAND *cmd, long row){
	CS_INT code=SendMessage(hwnd,PEM_INSERT_ROW,row,0);
	switch(code){
		case 0:
			return true;
		case CS_CANCEL_ALL:
			ct_cancel(NULL, cmd, CS_CANCEL_ALL);
			return false;
	}
	ct_cancel(NULL, cmd, CS_CANCEL_CURRENT);
	return false;
}

char*rtrim(char*c){
	char*ns=c;
	char*space=" \t\r\n";
	for(int i=0;c[i];i++)
		if(!strchr(space,c[i]))
			ns=c+i+1;
	ns[0]=0;
	return c;
}


void SQLERR(HWND hwnd, long msgnumber, long severity, char  *proc, long line, char *text ){
	SQLMESSAGE m;
	memset(&m,0,sizeof(SQLMESSAGE) );
	m.msgnumber=msgnumber;
	m.severity=severity;
	m.proc=proc;
	m.line=line;
	m.text=text;
	
	m.text[CS_MAX_MSG-1]=0;
	m.proc[CS_MAX_NAME-1]=0;
	rtrim(m.text);
	rtrim(m.proc);
	
	SendMessage(hwnd,PEM_SQL_MESSAGE,sizeof(SQLMESSAGE),(LPARAM)&m);
}




void * old_srv_msg_callback=NULL;
void * old_cli_msg_callback=NULL;


CS_RETCODE CS_PUBLIC ex_servermsg_cb(CS_CONTEXT*context, CS_CONNECTION*connection, CS_SERVERMSG*srvmsg){
	SQLERR(public_hwnd, srvmsg->msgnumber, srvmsg->severity, srvmsg->proc, srvmsg->line, srvmsg->text );
	return CS_SUCCEED;
}


CS_RETCODE CS_PUBLIC clientmsg_callback(CS_CONTEXT*ctx, CS_CONNECTION*con, CS_CLIENTMSG*cmsg){
	SQLERR(public_hwnd, cmsg->msgnumber, cmsg->severity, "", 0, cmsg->msgstring );
	return CS_SUCCEED;
}


CS_RETCODE install_message_callback(HWND hwnd,CS_COMMAND *cmd){
	CS_CONNECTION	*connection;

	LOG(hwnd,"installing server message callback...");
	//get connection
	RET_ON_FAIL(ct_cmd_props(cmd,CS_GET,CS_PARENT_HANDLE,&connection,CS_UNUSED,NULL),hwnd,"install_message_callback: ct_cmd_props() failed");
	//get old callback message
	RET_ON_FAIL(ct_callback(NULL, connection, CS_GET, CS_SERVERMSG_CB,(void*)&old_srv_msg_callback),hwnd,"install_message_callback: ct_callback(CS_GET) failed");
	DBG(fprintf(flog,"old_srv_msg_callback :%X\n",old_srv_msg_callback));
	//set the new one
	if(ct_callback(NULL, connection, CS_SET, CS_SERVERMSG_CB,(void*)ex_servermsg_cb)!=CS_SUCCEED){
		ERR(hwnd,"install_message_callback: ct_callback(CS_SET) failed");
		old_srv_msg_callback=NULL;
		return CS_FAIL;
	}
	LOG(hwnd,"server message callback installed");
	return CS_SUCCEED;
}

CS_RETCODE return_message_callback(HWND hwnd,CS_COMMAND *cmd){
	CS_CONNECTION	*connection;

	LOG(hwnd,"uninstalling server message callback...");
	//get connection
	RET_ON_FAIL(ct_cmd_props(cmd,CS_GET,CS_PARENT_HANDLE,&connection,CS_UNUSED,NULL),hwnd,"return_message_callback: ct_cmd_props() failed");
	//return the old cb
	if(ct_callback(NULL, connection, CS_SET, CS_SERVERMSG_CB,(void*)old_srv_msg_callback)!=CS_SUCCEED){
		ERR(hwnd,"return_message_callback: ct_callback(CS_SET) failed");
		return CS_FAIL;
	}
	old_srv_msg_callback=NULL;
	LOG(hwnd,"server message callback uninstalled");
	return CS_SUCCEED;
}

CS_RETCODE install_cli_message_callback(HWND hwnd,CS_COMMAND *cmd){
	CS_CONNECTION	*connection;

	LOG(hwnd,"installing client message callback...");
	//get connection
	RET_ON_FAIL(ct_cmd_props(cmd,CS_GET,CS_PARENT_HANDLE,&connection,CS_UNUSED,NULL),hwnd,"install_cli_message_callback: ct_cmd_props() failed");
	//get old callback message
	RET_ON_FAIL(ct_callback(NULL, connection, CS_GET, CS_CLIENTMSG_CB,
			(CS_VOID *)&old_cli_msg_callback),hwnd,
		    "install_cli_message_callback: ct_callback(CS_GET) failed");
	DBG(fprintf(flog,"old_cli_msg_callback :%X\n",old_cli_msg_callback));
	//set the new one
	if(ct_callback(NULL, connection, CS_SET, CS_CLIENTMSG_CB,(void*)clientmsg_callback)!=CS_SUCCEED){
		ERR(hwnd,"install_cli_message_callback: ct_callback(CS_SET) failed");
		old_cli_msg_callback=NULL;
		return CS_FAIL;
	}
	LOG(hwnd,"client message callback installed");
	return CS_SUCCEED;
}

CS_RETCODE return_cli_message_callback(HWND hwnd,CS_COMMAND *cmd){
	CS_CONNECTION	*connection;

	LOG(hwnd,"uninstalling client message callback...");
	//get connection
	RET_ON_FAIL(ct_cmd_props(cmd,CS_GET,CS_PARENT_HANDLE,&connection,CS_UNUSED,NULL),hwnd,"return_message_callback: ct_cmd_props() failed");
	//return the old cb
	if(ct_callback(NULL, connection, CS_SET, CS_CLIENTMSG_CB,(void*)old_cli_msg_callback)!=CS_SUCCEED){
		ERR(hwnd,"return_cli_message_callback: ct_callback(CS_SET) failed");
		return CS_FAIL;
	}
	old_cli_msg_callback=NULL;
	LOG(hwnd,"client message callback uninstalled");
	return CS_SUCCEED;
}

char* DisplayType(CS_DATAFMT*column){
	static char buf[50];
	switch ((int) column->datatype){
		case CS_CHAR_TYPE:
			sprintf(buf,"char(%i)",column->maxlength);
			break;
		case CS_VARCHAR_TYPE:
			sprintf(buf,"varchar(%i)",column->maxlength);
			break;
		case CS_TEXT_TYPE:
			sprintf(buf,"text");
			break;
		case CS_IMAGE_TYPE:
			sprintf(buf,"image");
			break;
		case CS_BINARY_TYPE:
			sprintf(buf,"binary");
			break;
		case CS_VARBINARY_TYPE:
			sprintf(buf,"varbinary");
			break;
		case CS_BIT_TYPE:
			sprintf(buf,"bit");
			break;
		case CS_TINYINT_TYPE:
			sprintf(buf,"tinyint");
			break;
		case CS_SMALLINT_TYPE:
			sprintf(buf,"smallint");
			break;
		case CS_INT_TYPE:
			sprintf(buf,"int");
			break;
		case CS_REAL_TYPE:
			sprintf(buf,"real");
			break;
		case CS_FLOAT_TYPE:
			sprintf(buf,"float");
			break;
		case CS_MONEY_TYPE:
			sprintf(buf,"money");
			break;
		case CS_MONEY4_TYPE:
			sprintf(buf,"smallmoney");
			break;
		case CS_DATETIME_TYPE:
			sprintf(buf,"datetime");
			break;
		case CS_DATETIME4_TYPE:
			sprintf(buf,"smalldatedime");
			break;
		case CS_NUMERIC_TYPE:
			sprintf(buf,"numeric(%i,%i)",column->precision,column->scale);
			break;
		case CS_DECIMAL_TYPE:
			sprintf(buf,"decimal(%i,%i)",column->precision,column->scale);
			break;
		case CS_UNICHAR_TYPE:
			sprintf(buf,"unichar(%i)",column->maxlength/2);
			break;
		case CS_DATE_TYPE:
			sprintf(buf,"date");
			break;
		case CS_TIME_TYPE:
			sprintf(buf,"time");
			break;
		default:
			sprintf(buf,"type_%i",column->datatype);
			break;
	}
	return buf;
}

//Initializes the dataformat and columndata to receive the fetched data as characters if autoconvert works well
//if not then leave format as is
void InitColData(CS_DATAFMT*column,COLUMNDATA*coldata){
	//this routime must init 
	//	coldata->charlen  number of characters (unicode?) for displaying data on client
	//	coldata->bytelen  number of bytes needed to fetch data (utf8)
	//	coldata->data     initialize memory to receive fetched data and to convert it to char
	//	column->maxlength if destination type = CHAR then equals to coldata->bytelen otherwise keep the original value
	//	datafmt.datatype = CS_CHAR_TYPE;
	//	datafmt.format   = CS_FMT_NULLTERM;
	switch (column->datatype){
		case CS_CHAR_TYPE:
		case CS_VARCHAR_TYPE:
		case CS_LONGCHAR_TYPE:
		case CS_TEXT_TYPE:
			coldata->bytelen =MIN(column->maxlength, MAXBUFSIZE)+1;
			coldata->charlen =coldata->bytelen;
			column->maxlength=coldata->bytelen;
			column->datatype = CS_CHAR_TYPE;
			column->format   = CS_FMT_NULLTERM;
			break;
		case CS_UNICHAR_TYPE:
			coldata->bytelen =MIN((column->maxlength/2)*3, MAXBUFSIZE)+1; //suppose that one unichar could be presented with 3 multibyte chars
			coldata->charlen =MIN((column->maxlength/2), MAXBUFSIZE)+1;
			column->maxlength=coldata->bytelen;
			column->datatype = CS_CHAR_TYPE;
			column->format   = CS_FMT_NULLTERM;
			break;
		case CS_IMAGE_TYPE:
		case CS_BINARY_TYPE:
		case CS_LONGBINARY_TYPE:
		case CS_VARBINARY_TYPE:
			coldata->bytelen =MIN((2 * column->maxlength) + 2, MAXBUFSIZE)+1;
			coldata->charlen =coldata->bytelen;
			column->maxlength=coldata->bytelen;
			column->datatype = CS_CHAR_TYPE;
			column->format   = CS_FMT_NULLTERM;
			break;
		case CS_BIT_TYPE:
		case CS_TINYINT_TYPE:
			coldata->bytelen =3+1;
			coldata->charlen =coldata->bytelen;
			column->maxlength=coldata->bytelen;
			column->datatype = CS_CHAR_TYPE;
			column->format   = CS_FMT_NULLTERM;
			break;
		case CS_SMALLINT_TYPE:
			coldata->bytelen =6+1;
			coldata->charlen =coldata->bytelen;
			column->maxlength=coldata->bytelen;
			column->datatype = CS_CHAR_TYPE;
			column->format   = CS_FMT_NULLTERM;
			break;
		case CS_INT_TYPE:
			coldata->bytelen =11+1;
			coldata->charlen =coldata->bytelen;
			column->maxlength=coldata->bytelen;
			column->datatype = CS_CHAR_TYPE;
			column->format   = CS_FMT_NULLTERM;
			break;
		case CS_REAL_TYPE:
		case CS_FLOAT_TYPE:
			coldata->bytelen =20+1;
			coldata->charlen =coldata->bytelen;
			//column->maxlength=coldata->bytelen;
			//column->datatype = CS_CHAR_TYPE;//use native
			//column->format   = CS_FMT_NULLTERM;
			break;
		case CS_MONEY_TYPE:
		case CS_MONEY4_TYPE:
			coldata->bytelen =24+1;
			coldata->charlen =coldata->bytelen;
			column->maxlength=coldata->bytelen;
			column->datatype = CS_CHAR_TYPE;
			column->format   = CS_FMT_NULLTERM;
			break;
		case CS_TIME_TYPE:
			coldata->bytelen =16+1;
			coldata->charlen =coldata->bytelen;
			column->maxlength=coldata->bytelen;
			if(public_datetime_format==DATETIME_FORMAT_NATIVE){
				//use native
				column->datatype = CS_CHAR_TYPE;
				column->format   = CS_FMT_NULLTERM;
			}
			break;
		case CS_DATETIME4_TYPE:
		case CS_DATETIME_TYPE:
			coldata->bytelen =max(sizeof(CS_DATETIME),30+1);
			coldata->charlen =coldata->bytelen;
			column->maxlength=coldata->bytelen;
			if(public_datetime_format==DATETIME_FORMAT_NATIVE){
				//use native
				column->datatype = CS_CHAR_TYPE;
				column->format   = CS_FMT_NULLTERM;
			}
			break;
		case CS_DATE_TYPE:
			coldata->bytelen =max(sizeof(CS_DATETIME),16+1);
			coldata->charlen =coldata->bytelen;
			column->maxlength=coldata->bytelen;
			if(public_datetime_format==DATETIME_FORMAT_NATIVE){
				//use native
				column->datatype = CS_CHAR_TYPE;
				column->format   = CS_FMT_NULLTERM;
			}
			break;
		case CS_NUMERIC_TYPE:
		case CS_DECIMAL_TYPE:
			coldata->bytelen =column->precision+3;
			coldata->charlen =coldata->bytelen;
			column->maxlength=coldata->bytelen;
			column->datatype = CS_CHAR_TYPE;
			column->format   = CS_FMT_NULLTERM;
			break;
		default:
			coldata->bytelen =MIN(column->maxlength, MAXBUFSIZE)+1;
			coldata->charlen =coldata->bytelen;
			column->maxlength=coldata->bytelen;
			column->datatype = CS_CHAR_TYPE;
			column->format   = CS_FMT_NULLTERM;
			break;
	}
	coldata->type=column->datatype;
	coldata->data=(char*)malloc( MAX(column->maxlength,coldata->bytelen)+2 );
}

CS_CONTEXT * getContext(CS_COMMAND*cmd){
	static CS_CONTEXT * ctx=NULL;
	CS_CONNECTION * con=NULL;
	if(!ctx){
		ct_cmd_props(cmd,CS_GET,CS_PARENT_HANDLE,&con,CS_UNUSED,NULL);
		ct_con_props(con,CS_GET,CS_PARENT_HANDLE,&ctx,CS_UNUSED,NULL);
	}
	return ctx;
}

//function that makes conversion to string of all nonstring fields.
void ToString( CS_COMMAND*cmd, COLUMNDATA*coldata ){
	//CS_CHAR		tmpbuf[100];
	CS_FLOAT      f;
	CS_REAL       r;
	CS_DATEREC    daterec;
	
	if(coldata->type!=CS_CHAR_TYPE){
		if(coldata->ind!=-1){
			//if not char then let's do the conversion
			if(coldata->type==CS_FLOAT_TYPE){
				f=((CS_FLOAT*)coldata->data)[0];
				sprintf(coldata->data,"%.18g",f);
				
			}else if(coldata->type==CS_REAL_TYPE){
				f=((CS_REAL*)coldata->data)[0];
				sprintf(coldata->data,"%.18g",f);
				
			}else if(coldata->type==CS_DATE_TYPE){
				cs_dt_crack(getContext(cmd), coldata->type, coldata->data, &daterec);
				sprintf(coldata->data,"%04i-%02i-%02i",daterec.dateyear, daterec.datemonth+1, daterec.datedmonth);
				
			}else if(coldata->type==CS_TIME_TYPE){
				cs_dt_crack(getContext(cmd), coldata->type, coldata->data, &daterec);
				if(public_datetime_format==DATETIME_FORMAT_SQL_S){
					sprintf(coldata->data,"%02i:%02i:%02i",daterec.datehour, daterec.dateminute, daterec.datesecond);
				}else{
					sprintf(coldata->data,"%02i:%02i:%02i.%03i",daterec.datehour, daterec.dateminute, daterec.datesecond, daterec.datemsecond);
				}
				
			}else if(coldata->type==CS_DATETIME_TYPE || coldata->type==CS_DATETIME4_TYPE){
				cs_dt_crack(getContext(cmd), coldata->type, coldata->data, &daterec);

				if(public_datetime_format==DATETIME_FORMAT_SQL_S){
					sprintf(coldata->data,"%04i-%02i-%02i %02i:%02i:%02i",daterec.dateyear, daterec.datemonth+1, daterec.datedmonth, daterec.datehour, daterec.dateminute, daterec.datesecond);
				}else{
					// if(public_date_format==DATE_FORMAT_SQL && public_time_format==TIME_FORMAT_FULL_MS)
					sprintf(coldata->data,"%04i-%02i-%02i %02i:%02i:%02i.%03i",daterec.dateyear, daterec.datemonth+1, daterec.datedmonth, daterec.datehour, daterec.dateminute, daterec.datesecond, daterec.datemsecond);
				}
				
			}else{
				sprintf(coldata->data,"???");
			}
		}
	}else{
		if(coldata->ind!=-1 && coldata->data[coldata->len]!=0 ){
			
			//!!!feature of sybase: if we are connected to the unicode server with nonunicode charset,
			//and there are some chars that could not be converted, sybase will not add null terminated char!!!
			//probably we should add this check after all ct_fetch
			coldata->data[coldata->len]=0;
		}
	}
	
}

//receives a calcel code
//CS_CANCEL_CURRENT , CS_CANCEL_ATTN , CS_CANCEL_ALL , or 0
//returns true if canceled , false if zero code received
BOOL FetchCancel(CS_COMMAND *cmd,CS_INT code){
	switch(code){
		case 0:
			return false;
		case CS_CANCEL_ALL:
			ct_cancel(NULL, cmd, CS_CANCEL_ALL);
			return true;
		default:
			ct_cancel(NULL, cmd, CS_CANCEL_CURRENT);
			return true;
	}
}

CS_STATIC CS_RETCODE CS_INTERNAL FetchComputeResults(HWND hwnd,CS_COMMAND *cmd){
	CS_RETCODE		retcode;
	CS_INT			num_cols;
	CS_INT			i;
	CS_INT			j;
	CS_INT			rows_read;
	CS_INT			disp_len;
//	CS_INT			outlen;
	CS_INT			compinfo;
	char			*operation;
	CS_DATAFMT		datafmt;
	COLUMNDATA		*coldata=NULL;
	
	RET_ON_FAIL(ct_res_info(cmd, CS_NUMDATA, &num_cols, CS_UNUSED, NULL),hwnd,"FetchComputeResults: ct_res_info() failed")

	if (num_cols <= 0){
		ERR(hwnd,"FetchComputeResults: ct_res_info() returned zero columns");
		return CS_FAIL;
	}
	
	if( !ROW(hwnd,cmd,0) ){
		return CS_SUCCEED;
	}
	
	coldata=(COLUMNDATA*)malloc(num_cols * sizeof (COLUMNDATA));
	if (coldata == NULL){
		ERR(hwnd,"FetchComputeResults: malloc() failed");
		return CS_FAIL;
	}
	memset( coldata, 0, num_cols * sizeof (COLUMNDATA) );

	for (i = 0; i < num_cols; i++){
		retcode = ct_compute_info(cmd, CS_COMP_OP, (i + 1), &compinfo, CS_UNUSED, NULL);
		if (retcode != CS_SUCCEED){
			ERR(hwnd,"FetchComputeResults: ct_compute_info() failed");
			break;
		}
		switch(compinfo){
			case CS_OP_SUM:  operation="SUM";break;
			case CS_OP_AVG:  operation="AVG";break;
			case CS_OP_MIN:  operation="MIN";break;
			case CS_OP_MAX:  operation="MAX";break;
			case CS_OP_COUNT:operation="COUNT";break;
			default:         operation="???";
		}
		retcode = ct_compute_info(cmd, CS_COMP_COLID, (i + 1), &compinfo, CS_UNUSED, NULL);
		if (retcode != CS_SUCCEED){
			ERR(hwnd,"FetchComputeResults: ct_compute_info() failed");
			break;
		}
		FLD(hwnd,compinfo,operation);
		
		retcode = ct_describe(cmd, (i + 1), &datafmt);
		if (retcode != CS_SUCCEED){
			ERR(hwnd,"FetchComputeResults: ct_describe() failed");
			break;
		}
		
		InitColData(&datafmt,&coldata[i]);
		
		retcode = ct_bind(cmd, i+1, &datafmt,coldata[i].data, &coldata[i].len,&coldata[i].ind);
		if (retcode != CS_SUCCEED){
			ERR(hwnd,"FetchComputeResults: ct_bind() failed");
			break;
		}
	}
	
	if (retcode != CS_SUCCEED){
		for (i = 0; i < num_cols; i++){
			if(coldata[i].data)free(coldata[i].data);
			coldata[i].data=NULL;
		}
		free(coldata);
		return retcode;
	}

	/*
	** Fetch the rows.  Loop while ct_fetch() returns CS_SUCCEED or 
	** CS_ROW_FAIL
	*/
	while (((retcode = ct_fetch(cmd, CS_UNUSED, CS_UNUSED, CS_UNUSED,
			&rows_read)) == CS_SUCCEED) || (retcode == CS_ROW_FAIL))
	{
		if (retcode == CS_ROW_FAIL){
			ERR(hwnd, "Error fetching row.");
		}
		if(rows_read==1){
			if( !ROW(hwnd,cmd,0) ){
				retcode=CS_SUCCEED;
				break;
			}
			for (i = 0; i < num_cols; i++){	  
				ToString(cmd,&coldata[i]);
				retcode = ct_compute_info(cmd, CS_COMP_COLID, (i + 1), &compinfo, CS_UNUSED, NULL);
				if (retcode != CS_SUCCEED){
					ERR(hwnd,"FetchComputeResults: ct_compute_info() failed");
					break;
				}
				FLD(hwnd,compinfo,(coldata[i].ind==-1?0:coldata[i].data));
			}
		}
	}

	for (i = 0; i < num_cols; i++){
		if(coldata[i].data)free(coldata[i].data);
		coldata[i].data=NULL;
	}
	free(coldata);

	switch ((int)retcode){
		case CS_END_DATA:
			LOG(hwnd, "All done processing rows.");
			retcode = CS_SUCCEED;
			break;

		case CS_FAIL:
			ERR(hwnd,"FetchComputeResults: ct_fetch() failed");
			return retcode;

		default:
			ERR(hwnd,"FetchComputeResults: ct_fetch() returned an expected retcode");
			return retcode;
	}

	return retcode;
}


CS_RETCODE FetchData(HWND hwnd,CS_COMMAND *cmd,int res_type,bool append){
	CS_RETCODE		retcode;
	CS_INT			num_cols;
	CS_INT			i;
	CS_INT			j;
	CS_INT			row_count = 0;
	CS_INT			rows_read;
	CS_INT			disp_len;
	CS_DATAFMT		datafmt;
	COLUMNDATA		*coldata=NULL;
	char			fname[MAX_FLD_NAME];
	CS_BOOL			has_br_info=false;
	CS_INT			br_tabnum;
	char			br_tabname[CS_OBJ_NAME+5];
	
	
	
	LOG(hwnd, "FetchData enter.");
	RET_ON_FAIL(ct_res_info(cmd, CS_NUMDATA, &num_cols, CS_UNUSED, NULL),hwnd,"FetchData: ct_res_info() failed")

	if (num_cols <= 0){
		ERR(hwnd,"FetchData: ct_res_info() returned zero columns");
		return CS_FAIL;
	}
	//notify about new resultset
	if(!append && res_type!=RS_TYPE_RET)RES(hwnd,res_type,num_cols);
	//check if there is a browse information, then dispatch it
	if(!append && res_type==RS_TYPE_DAT){
		ct_res_info(cmd, CS_BROWSE_INFO, &has_br_info, CS_UNUSED, NULL);
		if(has_br_info){
			RET_ON_FAIL(ct_br_table(cmd, CS_UNUSED, CS_TABNUM, &br_tabnum, CS_UNUSED, NULL),hwnd,"FetchData: ct_br_table(CS_TABNUM) failed");
			if(br_tabnum>0){
				retcode=ct_br_table(cmd, 1, CS_TABNAME, br_tabname, CS_OBJ_NAME+5, NULL);
				if(retcode==CS_SUCCEED){
					if(br_tabnum>1)strcat(br_tabname,"...");
					INFO(hwnd,RS_INFO_BR_TABLE,br_tabname);
				}
			}
		}
	}
	
	coldata=(COLUMNDATA*)malloc(num_cols * sizeof (COLUMNDATA));
	if (coldata == NULL){
		ERR(hwnd,"FetchData: malloc() failed");
		return CS_FAIL;
	}
	memset( coldata, 0, num_cols * sizeof (COLUMNDATA) );
	
	
	for (i = 0; i < num_cols; i++){
		retcode = ct_describe(cmd, (i + 1), &datafmt);
		if (retcode != CS_SUCCEED){
			ERR(hwnd,"FetchData: ct_describe() failed");
			break;
		}
		
		strcpy(fname,DisplayType(&datafmt));
		
		InitColData(&datafmt, &coldata[i]);
		
		sprintf(fname+strlen(fname),"?%i?%s",coldata[i].charlen,datafmt.name);
		if(!append && res_type!=RS_TYPE_RET)FLD(hwnd,i+1,fname);
		
		retcode = ct_bind(cmd, i+1, &datafmt,coldata[i].data, &coldata[i].len,&coldata[i].ind);
		if (retcode != CS_SUCCEED){
			ERR(hwnd,"FetchData: ct_bind() failed");
			break;
		}
	}
	
	if (retcode != CS_SUCCEED){
		for (i = 0; i < num_cols; i++){
			if(coldata[i].data)free(coldata[i].data);
			coldata[i].data=NULL;
		}
		free(coldata);
		return retcode;
	}

	/*
	** Fetch the rows.  Loop while ct_fetch() returns CS_SUCCEED or 
	** CS_ROW_FAIL
	*/
	while (((retcode = ct_fetch(cmd, CS_UNUSED, CS_UNUSED, CS_UNUSED,
			&rows_read)) == CS_SUCCEED) || (retcode == CS_ROW_FAIL))
	{
		row_count = row_count + rows_read;
		if (retcode == CS_ROW_FAIL){
			ERR(hwnd, "Error fetching row %i.",row_count);
		}
		if(rows_read==1){
			if(res_type==RS_TYPE_RET){
				INFO(hwnd,RS_INFO_RET,(coldata[0].ind==-1?0:coldata[0].data));
			}else{
				if( !ROW(hwnd,cmd,row_count) ){
					retcode=CS_SUCCEED;
					break;
				}
				for (i = 0; i < num_cols; i++){
					ToString(cmd, &coldata[i]);
					FLD(hwnd,i+1,(coldata[i].ind==-1?0:coldata[i].data));
				}
			}
		}
	}

	for (i = 0; i < num_cols; i++){
		if(coldata[i].data)free(coldata[i].data);
		coldata[i].data=NULL;
	}
	free(coldata);

	switch ((int)retcode){
		case CS_END_DATA:
			LOG(hwnd, "All done processing rows.");
			retcode = CS_SUCCEED;
			break;

		case CS_FAIL:
			ERR(hwnd,"FetchData: ct_fetch() failed");
			return retcode;

		default:
			ERR(hwnd,"FetchData: ct_fetch() returned an expected retcode");
			return retcode;
	}

	return retcode;
}
CS_RETCODE SendRowCount(HWND hwnd,CS_COMMAND *cmd,char * info){
	CS_INT	outlen,rowcount;
	CS_RETCODE	ret;
	char c[100];
	ret=ct_res_info(cmd, CS_ROW_COUNT, &rowcount, sizeof(rowcount), &outlen);
//	sprintf(c,"%i %s",rowcount,info);
	if(rowcount < 0)return ret; //don't show -1 lines affected
	sprintf(c,"%i",rowcount);
	INFO(hwnd,RS_INFO_ROWS,c);
	return ret;
}



CS_RETCODE HandleResults(HWND hwnd,CS_COMMAND *cmd){
	CS_RETCODE	retcode;
	CS_INT		res_type;
	BOOL		append=false;
	
	while( (retcode=ct_results(cmd, &res_type))==CS_SUCCEED ){
		switch(res_type){
			case CS_CMD_SUCCEED:
				LOG(hwnd,"ct_results: result_type=CS_CMD_SUCCEED");
				//SendRowCount(hwnd,cmd,"CS_CMD_SUCCEED");
				break;
			case CS_CMD_DONE:
				append=false;
				LOG(hwnd,"ct_results: result_type=CS_CMD_DONE");
				SendRowCount(hwnd,cmd,"CS_CMD_DONE");
				break;
			case CS_CMD_FAIL:
				ERR(hwnd,"ct_results: result_type=CS_CMD_FAIL");
				SendRowCount(hwnd,cmd,"CS_CMD_FAIL");
				ct_cancel(NULL, cmd, CS_CANCEL_ALL);
				return CS_FAIL;
				
				
			case CS_STATUS_RESULT:
				LOG(hwnd,"ct_results: result_type=CS_STATUS_RESULT");
				FetchData(hwnd,cmd,RS_TYPE_RET,false);
				break;
			case CS_PARAM_RESULT:
				LOG(hwnd,"ct_results: result_type=CS_PARAM_RESULT");
				FetchData(hwnd,cmd,RS_TYPE_OUT,false);
				break;
			case CS_ROW_RESULT:
				LOG(hwnd,"ct_results: result_type=CS_ROW_RESULT");
				FetchData(hwnd,cmd,RS_TYPE_DAT,append);
				break;
			case CS_COMPUTE_RESULT:
				append=true;
				LOG(hwnd,"ct_results: result_type=CS_COMPUTE_RESULT");
				FetchComputeResults(hwnd,cmd);
				break; 
			default:
				ERR(hwnd,"ct_results returned unexpected result type: %i",res_type);
				return CS_FAIL;
		}
	}
	if(retcode!=CS_END_RESULTS){
		ERR(hwnd,"ct_results() returns unexpected code: %i",retcode);
		return CS_FAIL;
	}
	return CS_SUCCEED;
}



CS_RETCODE _sql_execute(HWND hwnd,CS_COMMAND *cmd,char * query){
	RET_ON_FAIL(ct_command(cmd,CS_LANG_CMD,query,CS_NULLTERM,CS_UNUSED),hwnd,"ct_command(CS_LANG_CMD) failed");
	RET_ON_FAIL(ct_send(cmd),hwnd,"ct_send() failed");
	RET_ON_FAIL(HandleResults(hwnd,cmd),hwnd,"HandleResults() failed");
	
	return CS_SUCCEED;
}


CS_RETCODE _sql_dbgrpc_control(HWND hwnd,CS_COMMAND *cmd,CS_INT spid, char * parm){
	CS_DATAFMT	datafmt;
	
	RET_ON_FAIL(ct_command(cmd, CS_RPC_CMD, "$dbgrpc_control", CS_NULLTERM, CS_NO_RECOMPILE),hwnd,"_sql_dbgrpc_control: ct_command() failed");
	
	memset(&datafmt, 0, sizeof (datafmt));
//	datafmt.name[0]=0;
//	datafmt.namelen = CS_NULLTERM;
	datafmt.datatype = CS_INT_TYPE;
	datafmt.maxlength = CS_UNUSED;
	datafmt.status = CS_INPUTVALUE;
	RET_ON_FAIL(ct_param(cmd, &datafmt, (CS_VOID *)&spid,CS_SIZEOF(CS_INT), CS_UNUSED ),hwnd,"_sql_dbgrpc_control: ct_param(CS_INT) failed");

	memset(&datafmt, 0, sizeof (datafmt));
//	datafmt.name[0]=0;
//	datafmt.namelen = 0;
	datafmt.datatype = CS_CHAR_TYPE;
	datafmt.maxlength = CS_NULLTERM;
	datafmt.status = CS_INPUTVALUE;
	RET_ON_FAIL(ct_param(cmd, &datafmt, parm, CS_NULLTERM, ( (parm&&parm[0])?1:-1) ),hwnd,"_sql_dbgrpc_control: ct_param(char) failed");
		
	RET_ON_FAIL(ct_send(cmd),hwnd,"ct_send() failed");
	RET_ON_FAIL(HandleResults(hwnd,cmd),hwnd,"HandleResults() failed");
	
	return CS_SUCCEED;
}



BOOL APIENTRY DllMain( HANDLE hModule, DWORD  reason, LPVOID lpReserved){
    return TRUE;
}
//-----------------------------------------------------------------------------
// Main exported function
//
int __stdcall sql_execute(CS_CONNECTION	*connection,char * query,HWND hwnd){
	CS_RETCODE		retcode;
	CS_COMMAND		*cmd;
	DBG(flog = fopen("syb_exec.log","at"));
	DBG(fprintf(flog,"sql_execute enter\n"));
	if(!connection)return 0;
	public_hwnd=hwnd;
	retcode=ct_cmd_alloc(connection, &cmd);
	if ( retcode==CS_SUCCEED ){
		install_cli_message_callback(hwnd,cmd);
		install_message_callback(hwnd,cmd);
		retcode=_sql_execute(hwnd,cmd,query);
		return_message_callback(hwnd,cmd);
		return_cli_message_callback(hwnd,cmd);
		ct_cmd_drop(cmd);
	}else{
		ERR(hwnd,"sql_execute: ct_cmd_alloc() failed");
	}
	DBG(fprintf(flog,"sql_execute exit\n"));
	DBG(fflush(flog));
	DBG(fclose(flog));
	return (retcode == CS_SUCCEED) ? 1 : 0;
}

//returns true if client library supports version specified by parameter
int __stdcall sql_ctversion(int ver){
	CS_RETCODE		retcode;
	CS_CONTEXT		*ctx;

	// Get a context handle to use.
	retcode = cs_ctx_alloc(ver, &ctx);
	if (retcode == CS_SUCCEED){
		cs_ctx_drop(ctx);
	}else{
		remove("sybinit.err");
	}
	return (retcode == CS_SUCCEED) ? 1 : 0;
}

int __stdcall sql_dbgrpc_control(CS_CONNECTION	*connection,int spid, char * parm,HWND hwnd){
	CS_RETCODE		retcode;
	CS_COMMAND		*cmd;
	DBG(flog = fopen("syb_exec.log","at"));
	DBG(fprintf(flog,"sql_dbgrpc_control enter\n"));
	if(!connection)return 0;
	public_hwnd=hwnd;
	retcode=ct_cmd_alloc(connection, &cmd);
	if ( retcode==CS_SUCCEED ){
		install_cli_message_callback(hwnd,cmd);
		install_message_callback(hwnd,cmd);
		retcode=_sql_dbgrpc_control(hwnd,cmd, spid, parm);
		return_message_callback(hwnd,cmd);
		return_cli_message_callback(hwnd,cmd);
		ct_cmd_drop(cmd);
	}else{
		ERR(hwnd,"sql_dbgrpc_control: ct_cmd_alloc() failed");
	}
	DBG(fprintf(flog,"sql_dbgrpc_control exit\n"));
	DBG(fflush(flog));
	DBG(fclose(flog));
	return (retcode == CS_SUCCEED) ? 1 : 0;
}

//-------------------------------------------------------------------
//----------------------     UTF8 check       -----------------------
//-------------------------------------------------------------------
// taken from ftp://www.unicode.org/Public/PROGRAMS/CVTUTF



static const unsigned char trailingBytesForUTF8[256] = {
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3,4,4,4,4,5,5,5,5
}; 

//determines if the sequence of chars represents legal utf8 character
bool isLegalUTF8Char(const unsigned char *source, int length) {
	unsigned char a;
	const unsigned char *srcptr = source+length;
	switch (length) {
		default: return false;
		// Everything else falls through when "true"
		case 4: if ((a = (*--srcptr)) < 0x80 || a > 0xBF) return false;
		case 3: if ((a = (*--srcptr)) < 0x80 || a > 0xBF) return false;
		case 2: if ((a = (*--srcptr)) > 0xBF) return false;

		switch (*source) {
			// no fall-through in this inner switch
			case 0xE0: if (a < 0xA0) return false; break;
			case 0xED: if (a > 0x9F) return false; break;
			case 0xF0: if (a < 0x90) return false; break;
			case 0xF4: if (a > 0x8F) return false; break;
			default:   if (a < 0x80) return false;
		}

		case 1: if (*source >= 0x80 && *source < 0xC2) return false;
	}
	if (*source > 0xF4) return false;
	return true;
}

long __stdcall isLegalUTF8(const unsigned char *s,DWORD len,bool defaultUTF8) {
	bool hasMultibyteChars=false;
	DWORD i = 0, charBytes = 0;
	
	
	if(len>2){
		//if there is utf8 bom then skip it
		if(s[0]==0xEF && s[1]==0xBB && s[2]==0xBF){
			i=3;
		}
	}
	while(i<len){
		charBytes = trailingBytesForUTF8[s[i]] + 1;
		if(charBytes>1){
			hasMultibyteChars=true;
		}
		if ( !isLegalUTF8Char(s+i, charBytes) ) {
			return false;
		}
		i+=charBytes;
	}
	if(hasMultibyteChars || defaultUTF8)return true;
	return false;
}

bool __stdcall sql_property_set(int prop, int value){
	switch(prop){
		case PROP_FORMAT_DATETIME:
			public_datetime_format=value;
			break;
		default:
			return false;
	}
	return true;
}

}//extern "C"
