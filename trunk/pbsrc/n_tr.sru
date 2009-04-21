HA$PBExportHeader$n_tr.sru
forward
global type n_tr from transaction
end type
end forward

global type n_tr from transaction
end type
global n_tr n_tr

type prototypes
function boolean sql_ctversion(long ver) LIBRARY "syb_exec.dll"

function long dbgrpc_attach(long spid) RPCFUNC ALIAS FOR "$dbgrpc_attach"
function long dbgrpc_detach(long spid) RPCFUNC ALIAS FOR "$dbgrpc_detach"


end prototypes

type variables
public PRIVATEWRITE long il_dbg_spid
public PRIVATEWRITE string is_server_version
public string is_charset
public PRIVATEWRITE string is_charset_var //the variable that contains client charset. @@client_csname or empty if not supported
public boolean ib_executing=false //true if transaction currently used

end variables

forward prototypes
public function boolean of_error ()
public function boolean of_isconnected ()
public function boolean of_connect ()
public function boolean of_disconnect ()
public function boolean of_dbg_attach (long al_spid)
public function boolean of_dbg_detach (long al_spid)
public function boolean of_dbg_error (long ret)
public function boolean of_utf8 ()
public function boolean of_connect (readonly string as_srv, readonly string as_db, readonly string as_uid, readonly string as_pwd, readonly string as_charset, string as_hostname, readonly boolean ab_pwencrypt, readonly boolean ab_dataencrypt)
end prototypes

public function boolean of_error ();if this.sqlcode=-1 then 
	if isValid(w_main) then
		w_main.of_log(0,0,'<SQL>',0,this.sqlerrtext)
	else
		f_error(this.sqlerrtext)
	end if
	return true
end if
return false

end function

public function boolean of_isconnected ();return dbhandle()<>0

end function

public function boolean of_connect ();string s
connect using this;

if this.sqlcode<>0 and this.sqldbcode=911 and this.database<>'' then
	w_main.of_log(911,16,'',0,this.sqlerrtext)
	w_main.of_log(0,0,'',0,'using default database.')
	this.database=''
	connect using this;
end if


if this.sqlcode<>0 then
	MessageBox(app().displayname,this.sqlerrtext,StopSign!)
	return false
end if

s=f_selectstring('select @@version','')
is_server_version=f_replaceall(s,'/','~r~n')

this.is_charset_var=f_selectstring('select @@client_csname','')
if this.is_charset_var>'' then this.is_charset_var='@@client_csname'


return true

end function

public function boolean of_disconnect ();if of_isconnected() then
	of_dbg_detach(0)
	disconnect using this;
end if

return true

end function

public function boolean of_dbg_attach (long al_spid);long i

//detach current debugged process if attached
of_dbg_detach(0)

if al_spid<=0 then return false
if al_spid=w_main.spid then 
	w_main.of_log(0,-1,'debugger',0,"Can't debug yourself.")
	return false
end if

w_main.lv_log.deleteitems()
w_browser.tab_1.page_dbg.lv_stop.DeleteItems()
w_browser.tab_1.page_dbg.il_stopcount=0
i=this.dbgrpc_attach( al_spid )
if of_dbg_error(i) then return false
il_dbg_spid=al_spid

w_main.of_log(0,-1,'debugger',0,'successfully attached to the process #'+string(il_dbg_spid))

return true

end function

public function boolean of_dbg_detach (long al_spid);long ret

if al_spid<=0 then al_spid=il_dbg_spid

if al_spid<=0 then return true

w_main.lv_log.deleteitems()
ret=this.dbgrpc_detach( al_spid )
if not of_dbg_error(ret) then
	w_main.of_log(0,-1,'debugger',0,'successfully detached from the process #'+string(al_spid))
end if

if al_spid=il_dbg_spid then il_dbg_spid=0
return true

end function

public function boolean of_dbg_error (long ret);//
string msg

//no error
if ret=0 and this.sqlcode=0 then return false

//error

choose case ret
	case  -1
		msg = "Cannot allocate resource in ASE"
	case  -2
		msg = "Cannot create Debugger handle in ASE"
	case  -3
		msg = "The spid is invalid"
	case  -4
		msg = "You cannot debug a task that is not owned by you"
	case  -5
		msg = "Spid is already being debugged"
	case  -6
		msg = "Spid is not debugged currently"
	case  -9
		msg = "Invalid command"
	case -10
		msg = "Invalid procedure name"
	case -11
		msg = "Invalid line number"
	case -12
		msg = "Variable not found"
	case -13
		msg = "Illegal conversion attemped"
	case -14
		msg = "Conversion from text to datatype failed"
	case else
		if this.sqlcode<>0 then 
			msg=this.sqlerrtext
		else
			msg="Expected a 0 return status, got "+string (ret)+" ."
		end if
end choose

w_main.of_log(ret,-1,'debugger',0,msg)

return true

end function

public function boolean of_utf8 ();//returns true if charset is utf8
return is_charset='utf8'

end function

public function boolean of_connect (readonly string as_srv, readonly string as_db, readonly string as_uid, readonly string as_pwd, readonly string as_charset, string as_hostname, readonly boolean ab_pwencrypt, readonly boolean ab_dataencrypt);boolean v125

if trim(as_hostname)='' then
	as_hostname=cfg.of_gethostname()
end if

v125=sql_ctversion(12500)

this.is_charset=as_charset
if lower(this.is_charset)='utf8' then this.is_charset=lower(this.is_charset)

this.DBMS = "SYC"
this.Database = ""
this.LogPass = as_pwd
this.ServerName = as_srv
this.Database   = as_db
this.LogId = as_uid
this.AutoCommit = true
this.DBParm = /*"TrimSpaces=0,*/"Host='"+as_hostname+"',AppName='"+app().displayname+"'"
if as_charset<>'' then this.DBParm +=",CharSet='"+as_charset+"'"
if this.of_utf8() then this.DBParm += ",UTF8=1"
if not ab_pwencrypt then this.DBParm += ",PWEncrypt='No'"
if ab_dataencrypt then this.DBParm += ",Sec_Confidential=1"
if v125 then 
	this.DBParm +=",Release='12.5'"
else
	if ab_dataencrypt then this.DBParm +=",Release='11'"
end if

return of_connect()

end function

on n_tr.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_tr.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

