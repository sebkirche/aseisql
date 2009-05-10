#include "syb_exec.h"


#define STRLEN(s)  (CS_INT)((s) == NULL ? 0 : strlen(s))
int match_OID(CS_OID *oid,CS_CHAR *oid_string){
	return ( (oid->oid_length == (CS_INT)STRLEN(oid_string))
	  && (strncmp(oid_string, oid->oid_buffer, oid->oid_length) == 0));
} /* match_OID() */

CS_RETCODE attr_get_by_type(SQLCONTEXT*sct,CS_DS_OBJECT       *ds_object,
				CS_CHAR            *attr_type_str,
				CS_ATTRIBUTE       *attr_metadata,
				CS_ATTRVALUE      **p_attrvals) {
	CS_RETCODE          ret;
	CS_INT              num_attrs;
	CS_INT              cur_attr;
	CS_INT              outlen;
	CS_INT              buflen;
	CS_BOOL             found = CS_FALSE;

	/*
	** Check input pointers. If not NULL, make them fail safe.
	*/
	if (attr_metadata == NULL || p_attrvals == NULL){
		return CS_FAIL;
	}
	attr_metadata->attr_numvals = 0;
	*p_attrvals = NULL;

	/*
	** Get number of attributes.
	*/
	ret = ct_ds_objinfo(ds_object, CS_GET, CS_DS_NUMATTR, CS_UNUSED,
			    (CS_VOID *)&num_attrs, CS_SIZEOF(num_attrs),
			    NULL);
	if (ret != CS_SUCCEED) {
		ERR(sct, "attr_get_by_type: get number of attributes failed.");
		return CS_FAIL;
	}

	/*
	** Look for the matching attribute, get the values if found.
	*/
	for (cur_attr = 1; (cur_attr <= num_attrs) && (found != CS_TRUE); cur_attr++) {

		/*
		** Get the attribute's metadata.
		*/
		ret = ct_ds_objinfo(ds_object, CS_GET, CS_DS_ATTRIBUTE, 
				    cur_attr, (CS_VOID *)attr_metadata, 
				    CS_SIZEOF(CS_ATTRIBUTE), NULL);
		RET_ON_FAIL(ret,sct,"attr_get_by_type: get attribute failed.");

		// Check for a match.
		if (match_OID(&(attr_metadata->attr_type), attr_type_str)) {
			found = CS_TRUE;
			/*
			** Get the values -- we first allocate an array of
			** CS_ATTRVALUE unions.
			*/
			if (attr_metadata->attr_numvals <= 0) {
				ERR(sct,"attr_get_by_type: bad numvals field!");
				return CS_FAIL;
			}
			*p_attrvals = (CS_ATTRVALUE *) 
			     malloc(sizeof(CS_ATTRVALUE)
				    * (attr_metadata->attr_numvals));
			if (p_attrvals == NULL) {
				ERR(sct,"attr_get_by_type: out of memory!");
				return CS_FAIL;
			}

			buflen = CS_SIZEOF(CS_ATTRVALUE) 
			  * (attr_metadata->attr_numvals);
			ret = ct_ds_objinfo(ds_object, CS_GET, 
					    CS_DS_ATTRVALS, cur_attr,
					    (CS_VOID *)(*p_attrvals), 
					    buflen, &outlen);
			if (ret != CS_SUCCEED) {
				ERR(sct, "attr_get_by_type: get attribute values failed.");
				free(*p_attrvals);
				*p_attrvals = NULL;
				attr_metadata->attr_numvals = 0;
				return CS_FAIL;
			}
		}
	}

	/*
	** Got the attribute.
	*/
	if (found == CS_TRUE) {
		return CS_SUCCEED;
	}

	/*
	** Not found.
	*/
	attr_metadata->attr_numvals = 0;
	return CS_FAIL;

} /* attr_get_by_type() */


CS_RETCODE attr_val_as_string(CS_ATTRIBUTE *attr_metadata, CS_ATTRVALUE *val, CS_CHAR *buffer, CS_INT buflen, CS_INT *outlen) {
	CS_CHAR             outbuf[CS_MAX_DS_STRING * 4];

	if (buflen == 0 || buffer == NULL){
		return CS_FAIL;
	}
	if (outlen != NULL){
		*outlen = 0;
	}

	switch ((int)attr_metadata->attr_syntax){
		case CS_ATTR_SYNTAX_STRING:
			sprintf(outbuf, "%.*s",
				(int)(val->value_string.str_length),
				val->value_string.str_buffer);
			break;
		default:
			sprintf(outbuf, "Unknown attribute value syntax");
			break;
	} /* switch */

	if (STRLEN(outbuf) + 1 > buflen || buffer == NULL){
		return CS_FAIL;
	}else{
		sprintf(buffer, "%s", outbuf);
		if (outlen != NULL)	{
			*outlen = STRLEN(outbuf) + 1;
		}
	}

	return CS_SUCCEED;
} /* attr_val_as_string() */


CS_RETCODE CS_PUBLIC directory_cb(CS_CONNECTION *conn,CS_INT reqid,CS_RETCODE status,CS_INT numentries,CS_DS_OBJECT *ds_object,CS_VOID *userdata){
	CS_RETCODE          ret;
	SQLCONTEXT			*sct=(SQLCONTEXT*)userdata;
	
	DBG(fprintf(flog,"directory_cb %i %i %X\n",status,numentries,ds_object));

	if (status != CS_SUCCEED || numentries <= 0 || ds_object == NULL){
		return CS_SUCCEED;
	}
	
	
	//CS_CHAR             s[1024];
	WCHAR				ws[CS_MAX_DS_STRING * 3];
	CS_INT              outlen;
	CS_ATTRIBUTE        attr_metadata;
	CS_ATTRVALUE       *p_attrvals;
	CS_CHAR             outbuf[CS_MAX_DS_STRING * 3];

	//ret = ct_ds_objinfo(ds_object, CS_GET, CS_DS_DIST_NAME, CS_UNUSED, (CS_VOID *)s, CS_SIZEOF(s),&outlen);
	//DBG(fprintf(flog,"directory_cb %i %s\n",ret,s));
	//RET_ON_FAIL(ret,hwnd,"directory_cb: ct_ds_objinfo failed.");
	//printf("%s\t",s);
	
	ret=attr_get_by_type(sct,ds_object, CS_OID_ATTRSERVNAME, &attr_metadata, &p_attrvals);
	RET_ON_FAIL(ret,sct,"directory_cb: attr_get_by_type failed.");
	
	ret = attr_val_as_string(&attr_metadata, p_attrvals,outbuf, CS_MAX_DS_STRING * 3, NULL);
	RET_ON_FAIL(ret,sct,"directory_cb: attr_val_as_string failed.");
	
	// Append the object to the list of servers.
	MultiByteToWideChar(CP_ACP,0,outbuf,-1,ws,CS_MAX_DS_STRING * 3);
	DIR(sct,ws);
	/*
	** Return CS_CONTINUE so Client-Library will call us again if more
	** entries are found.
	*/
	return CS_CONTINUE;

} /* directory_cb() */

CS_RETCODE get_servers(CS_CONNECTION *conn, SQLCONTEXT*sct){
	CS_RETCODE          ret;
	CS_INT              reqid;
	CS_VOID            *oldcallback;
	CS_OID              oid;
	CS_DS_LOOKUP_INFO   lookup_info;

	// Save the old directory callback and install our own
	// callback, directory_cb(), to receive the found objects.
	ret = ct_callback(NULL, conn, CS_GET, CS_DS_LOOKUP_CB, &oldcallback);
	if (ret == CS_SUCCEED){
		ret = ct_callback(NULL, conn, CS_SET, CS_DS_LOOKUP_CB, (CS_VOID *)directory_cb);
	}
	RET_ON_FAIL(ret,sct,"get_servers: Could not install directory callback.")

	// Set the CS_DS_LOOKUP_INFO structure fields.
	lookup_info.path = NULL;
	lookup_info.pathlen = 0;
	lookup_info.attrfilter = NULL;
	lookup_info.attrselect = NULL;

	strcpy(oid.oid_buffer, CS_OID_OBJSERVER);
	oid.oid_length = strlen(oid.oid_buffer);
	lookup_info.objclass = &oid;

	// Begin the search.
	ret = ct_ds_lookup(conn, CS_SET, &reqid,&lookup_info, sct);
	RET_ON_FAIL(ret,sct,"get_servers: Could not run ct_ds_lookup.");

	// Restore callbacks and properties that we changed.
	ret = ct_callback(NULL, conn, CS_SET, CS_DS_LOOKUP_CB, oldcallback);
	RET_ON_FAIL(ret,sct,"get_servers: Could not restore directory callback.");

	return CS_SUCCEED;

}


#define DIR_MAX_LEN 4098
int __stdcall sql_directory(HWND cb_hwnd){
	CS_RETCODE		retcode;
	CS_CONTEXT		*ctx;
	CS_CONNECTION	*conn;
	
	CS_CHAR         scratch_str[DIR_MAX_LEN];
	WCHAR			ws[DIR_MAX_LEN];
	SQLCONTEXT		sct;
	
	sqlctx_init(&sct,cb_hwnd,NULL);
	//LOG(cb_hwnd,"sql_directory call");
	DBG(flog = fopen("syb_exec.log","at"));
	DBG(fprintf(flog,"sql_directory enter\n"));

	if ( GetEnvironmentVariableW(L"SYBASE",	ws,	DIR_MAX_LEN)>0 ){
		DIR_INFO(&sct,L"Sybase",ws);
	}else{
		DIR_INFO(&sct,L"Sybase",L"NOT SET!");
	}
	
	HMODULE hmodule= GetModuleHandleW( L"libct.dll" );
	if(hmodule){
		GetModuleFileNameW(hmodule, ws, DIR_MAX_LEN);
		DIR_INFO(&sct,L"libct.dll",ws);
	}else{
		DIR_INFO(&sct,L"libct.dll",L"NOT FOUND!");
	}
	// Get a context handle to use.
	retcode = cs_ctx_alloc(CS_VERSION_110, &ctx);
	if (retcode == CS_SUCCEED){
		DBG(fprintf(flog,"cs_ctx_alloc\n"));
		// Initialize Open Client.
		retcode = ct_init(ctx, CS_VERSION_110);
		if (retcode == CS_SUCCEED){
			DBG(fprintf(flog,"ct_init\n"));
			retcode = ct_con_alloc(ctx, &conn);
			if (retcode == CS_SUCCEED){

				retcode = ct_config(ctx, CS_GET, CS_VER_STRING, (CS_VOID *)scratch_str, DIR_MAX_LEN, NULL);
				if(retcode == CS_SUCCEED){
					MultiByteToWideChar(CP_ACP,0,scratch_str,-1,ws,DIR_MAX_LEN);
					DIR_INFO(&sct,L"CS Version",ws);
				}
				
				retcode = ct_con_props(conn, CS_GET, CS_DS_PROVIDER, scratch_str, DIR_MAX_LEN, NULL);
				if(retcode == CS_SUCCEED){
					MultiByteToWideChar(CP_ACP,0,scratch_str,-1,ws,DIR_MAX_LEN);
					DIR_INFO(&sct,L"Provider",ws);
				}
				
				retcode = ct_config(ctx, CS_GET, CS_IFILE, (CS_VOID *)scratch_str, DIR_MAX_LEN, NULL);
				if(retcode == CS_SUCCEED){
					MultiByteToWideChar(CP_ACP,0,scratch_str,-1,ws,DIR_MAX_LEN);
					DIR_INFO(&sct,L"Interface file",ws);
				}
				
				
				DBG(fprintf(flog,"ct_con_alloc\n"));
				get_servers(conn,&sct);
				ct_con_drop(conn);
			}else{
				ERR(&sct,"sql_directory: ct_con_alloc() failed");
			}
			
		}else{
			ERR(&sct,"sql_directory: ct_init() failed");
		}
		cs_ctx_drop(ctx);
	}else{
		remove("sybinit.err");
		ERR(&sct,"sql_directory: cs_ctx_alloc() failed");
	}
	DBG(fprintf(flog,"sql_directory exit\n"));
	DBG(fflush(flog));
	DBG(fclose(flog));
	sqlctx_finit(&sct);
	return (retcode == CS_SUCCEED) ? 1 : 0;
}
