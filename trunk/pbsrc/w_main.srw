HA$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type mdi_1 from mdiclient within w_main
end type
type st_tip2 from uo_tooltip within w_main
end type
type lv_log from uo_log within w_main
end type
type st_tip from uo_tooltip within w_main
end type
type tab_1 from tab within w_main
end type
type tab_1 from tab within w_main
end type
type hpb_1 from hprogressbar within w_main
end type
type st_split from uo_split_bar within w_main
end type
type win32_find_data from structure within w_main
end type
type thwnd2obj from structure within w_main
end type
end forward

type WIN32_FIND_DATA from structure
    long	dwFileAttributes 
    long ftCreationTime_lo 
    long ftCreationTime_hi
    long ftLastAccessTime_lo
    long ftLastAccessTime_hi
    long ftLastWriteTime_lo 
    long ftLastWriteTime_hi
    long nFileSizeHigh 
    long    nFileSizeLow 
    long    dwReserved0 
    long    dwReserved1 
    char   cFileName[600] 
end type

global type w_main from window
integer width = 3150
integer height = 5028
boolean titlebar = true
string title = "ASE isql"
string menuname = "m_main"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = mdihelp!
long backcolor = 67108864
event ue_sybexec_resultset pbm_custom01
event ue_sybexec_newrow pbm_custom02
event ue_sybexec_setfield pbm_custom03
event ue_sybexec_message pbm_custom04
event ue_sybexec_sqlerror pbm_custom06
event getminmaxinfo pbm_getminmaxinfo
event ue_men_connect ( )
event ue_men_disconnect ( )
event ue_men_open ( )
event ue_men_save ( )
event ue_men_execute ( )
event ue_men_close ( )
event ue_men_cancel ( )
event ue_sybexec_resinfo pbm_custom07
event ue_men_newsession ( )
event ue_statusbar_clicked ( )
event ue_select_database ( )
event type boolean ue_find_next ( )
event ue_men_viewprocesses ( )
event ue_men_closeall ( )
event ue_men_queryprocessplan ( )
event ue_men_noexecute ( )
event ue_men_querytimestat ( )
event ue_men_print ( )
event ue_men_showrssql ( )
event ue_men_sqlhistory ( )
event ue_men_querytab ( )
event ue_men_formatsql ( )
event ue_men_browser ( )
event ue_db_change ( readonly string database )
event ue_men_cancel_suicide ( )
event ue_men_windownext ( )
event ue_men_windowprev ( )
event ue_men_closeallrs ( )
event ue_men_markerset ( )
event ue_men_markerprev ( )
event ue_men_markernext ( )
event ue_men_convertlineend ( )
event ue_men_showlineendings ( )
event ue_sqlexec_preview ( long al_pos,  readonly string as_query,  long al_id )
event ue_sqlexec_end ( )
event type boolean ue_sqlexec_wantstop ( )
event ue_men_copyrtf ( )
event ue_men_reselect ( )
event ue_men_wrappages ( )
event ue_men_lineendings_unix ( )
event ue_men_lineendings_win ( )
event ue_men_options ( )
event ue_men_saveas ( )
event ue_men_showlog ( )
event ue_men_executeline ( )
event ue_men_deleteline ( )
event ue_men_comment ( )
event ue_men_uncomment ( )
event ue_men_help ( )
event ue_men_dbg_detach ( )
event ue_men_dbg_attach ( )
event ue_men_dbg_stop ( )
event ue_men_dbg_step ( )
event ue_men_dbg_continue ( )
event ue_men_dbg_stepout ( )
event ue_men_dbg_stepin ( )
event ue_men_dbg_deleteall ( )
event ue_men_copyvarprint ( )
event ue_men_case_key_up ( )
event ue_men_case_key_lo ( )
event ue_men_case_up ( )
event ue_men_case_lo ( )
event ue_men_case_ti ( )
event ue_men_insertstub ( )
event ue_men_workspacesave ( )
event ue_men_workspaceload ( )
event ue_men_cancel_all ( )
event ue_men_cancel_current ( )
event dropfiles pbm_dropfiles
event ncrbuttondown pbm_ncrbuttondown
event ue_find ( )
event ue_men_showspaces ( )
event ue_men_executeexport ( )
event ue_men_exportdata ( )
event ue_sybexec_setfieldinfo pbm_custom10
mdi_1 mdi_1
st_tip2 st_tip2
lv_log lv_log
st_tip st_tip
tab_1 tab_1
hpb_1 hpb_1
st_split st_split
end type
global w_main w_main

type prototypes
//getminmaxinfo
subroutine RtlMoveMemory( long dest, ref long src, long srclen ) library 'kernel32.dll'
//disable mdiclient window
function boolean EnableWindow(long hWnd,boolean bEnable)library "user32"
//new session
function long GetModuleFileName(long hModule,ref string lpFilename,long nSize)library 'kernel32' alias for "GetModuleFileNameW"
//of_openfile
function long GetFullPathName(string src,long nBufferLength,ref string dst,ref long fnameoff)library "Kernel32" Alias for "GetFullPathNameW"
function long FindFirstFile(string lpFileName,ref WIN32_FIND_DATA ffd)library "kernel32.dll" alias for "FindFirstFileW"
function boolean FindNextFile(long hFindFile,ref WIN32_FIND_DATA ffd)library "kernel32.dll" alias for "FindNextFileW"
function boolean FindClose(long hFindFile)library "kernel32.dll"

//drag and drop files
subroutine DragAcceptFiles(long _hWnd,boolean fAccept)library 'shell32'
subroutine DragFinish(long hDrop)library 'shell32'
function long DragQueryFile(long hDrop,long iFile,ref string filename, long buflen)library 'shell32' alias for 'DragQueryFileW'


//??????????deprecated??????????????
//get system colors
//function long GetSysColor(long index)library "user32"

//subroutine RtlMoveMemory2( ref long dest, long src, long srclen ) library 'kernel32.dll' alias for RtlMoveMemory
//
//subroutine RtlMoveMemory( ref t_cs_servermsg dest, long src, long srclen ) library 'kernel32.dll' alias for "RtlMoveMemory"
//function long SendMessage(long w, long msg,long wparm,ref long lparm[])library 'user32.dll' alias for SendMessageA
//function long sql_execute(long DBHandle,ref string sql, long hwnd) LIBRARY "syb_exec.dll" alias for "sql_execute"


end prototypes

type variables
string is_workspacename
string is_workspacepath

uo_editpage iuo_lastexecpage

long il_execerror

//long row_number=0

//uo_resultSet irs[]
//long rs_current=0
uo_resultSet irs_current


//boolean executing=false
//boolean stop=false //replaced with il_stop_code
long il_stop_code=0 //0 no stop, 6000 : CS_CANCEL_CURRENT, 6001 : CS_CANCEL_ALL


boolean ib_showlog=true
boolean ib_saveonexec=false
long il_logshowlevel=2
//a flag that shows that we are waiting for a remote process to rich breakpoint
//executing is also set to disallow any executions
boolean ib_DebugWait=false  

n_sqlexec in_sqlexec
n_sqlexec in_sqlexec_trig //for no post
n_sqlexeclocator in_locator

//find text parameters
string find_text
//long find_flags
boolean find_back=false
boolean find_case=false
boolean find_wword=false
boolean find_wstart=false



boolean noexecute=false
boolean showplan=false
boolean timestat=false

boolean isproclist=false

long il_currentquery_id
string currentquery
long currentpos=0
long currentselpos=0
long spid
long il_reselect_id=0

boolean suicidepending=false

n_sqlmessage in_sqlmsg

end variables

forward prototypes
public function boolean of_getcurrentedit (ref uo_editpage e)
public function boolean of_pastetext (readonly string s)
public function boolean of_pastetextnomove (readonly string s)
public function uo_tabpage of_getcurrentpage ()
public subroutine of_showpos (readonly uo_editpage e)
public subroutine of_setexec (boolean b)
public subroutine of_settitle ()
public function boolean of_iseditoractive ()
public subroutine of_setconnect (boolean b)
public function boolean of_findresultset (ref uo_resultset ars_after, long al_id)
public function boolean of_getprocesspage (ref uo_resultset ars)
public subroutine of_updatemenustatus ()
public subroutine of_updateview ()
public function boolean of_openobject (readonly string as_name, long al_objtype, boolean ab_clone)
public subroutine of_checkdb ()
public function long of_gettabindex ()
public function boolean of_parsecmd (string cmd)
public function boolean of_execute (readonly uo_editpage e, readonly string as_query, boolean ab_post)
public function boolean of_closetab (readonly uo_tabpage o)
public function boolean of_dbg_control (readonly string parm)
public function boolean of_dbg_wait ()
public function boolean of_dbg_setwait (boolean b)
public function boolean of_canopenobject (readonly integer ai_type)
public function boolean of_workspaceopen (readonly string as_file)
public function boolean of_workspacesave (readonly string as_file)
public function boolean of_openfile (readonly string as_filename, boolean ab_clone, long encoding)
public subroutine of_log (long al_number, long al_severity, string as_procedure, long al_line, readonly string as_message)
public subroutine of_log (readonly string as_msg)
public subroutine of_setcolor (string c)
end prototypes

event ue_sybexec_resultset;uo_resultset none //to make unvalid current resultset
string rs_classname='uo_resultset_'


if timestat then of_log(0,-1,'',0,'------------ Result  '+string(now(),'hh:mm:ss.ffff')+' ------------')

if isproclist then
	irs_current=none
	of_getprocesspage(irs_current)
elseif il_reselect_id<>0 then
	of_findresultset(irs_current,il_reselect_id)
else
	//reset resultset only if it is not a ib_multi_resultsets
	if isValid(irs_current) then
		if not irs_current.ib_multi_resultsets then irs_current=none
	end if
end if

//create if not created
if not isValid(irs_current) then 
	if isproclist or lower(cfg.is_resultset_mode)='grid' then
		rs_classname+='grid'
	else
		rs_classname+=cfg.is_resultset_mode
	end if
	tab_1.OpenTab(irs_current,rs_classname,0)
	
	irs_current.of_setsql(currentquery)
	irs_current.il_query_id=il_currentquery_id
	if isproclist then
		irs_current.of_init( '', irs_current.typeRsProcess, 0, '')
	elseif wparam=2 then //rs_type=RS_TYPE_OUT
		irs_current.of_init( '', irs_current.typeRsOutput, 0, '')
	else
		irs_current.of_init( '', irs_current.typeRs, 0, '')
	end if
end if
irs_current.of_sybexec_resultset( wparam, lparam)
tab_1.SelectTab(irs_current)

end event

event ue_sybexec_newrow;if il_stop_code<>0 then return il_stop_code //stop!!!

irs_current.of_sybexec_newrow( wparam )

return 0

end event

event ue_sybexec_setfield;string s
uo_resultset none

if lparam=0 then
	setNull(s)
else
	gn_unicode.of_mblong2string(sqlca.of_utf8(), lparam,s) //in_sqlmsg.of_l2s(lparam,s) //normally from the database we should receive unicode data...//maybe in the future...
end if

if isValid(irs_current) then irs_current.of_sybexec_setfield(wparam,s)

end event

event ue_sybexec_message;//this is only for debug messages from syb_exec.dll
string s

return 0

if lparam=0 then 
	s='<NULL>'
else
	gn_unicode.of_mblong2string(sqlca.of_utf8(), lparam,s) //in_sqlmsg.of_l2s(lparam,s) //normally from the database we should receive unicode data...//maybe in the future...
end if

of_log(0,-1,'<dbg>',0,s)

end event

event ue_sybexec_sqlerror;in_sqlmsg.of_translatemessage(wparam,lparam)

if in_sqlmsg.proclen=0 then
	if isValid(iuo_lastexecpage) then
		//message not from procedure and executed from the interface
		in_sqlmsg.line+=iuo_lastexecpage.uo_edit.of_send(iuo_lastexecpage.uo_edit.SCI_LINEFROMPOSITION,currentselpos+currentpos,0)
	end if
end if

of_log(in_sqlmsg.msgnumber,in_sqlmsg.severity,in_sqlmsg.proc,in_sqlmsg.line,in_sqlmsg.text)

return 0

end event

event getminmaxinfo;long ww=500
long hh=300

RtlMoveMemory(minmaxinfo+24,ww,4)
RtlMoveMemory(minmaxinfo+28,hh,4)

end event

event ue_men_connect();if keydown(KeyControl!) and sqlca.servername>'' and sqlca.logid>'' then
	setPointer(HourGlass!)
	//reconnect case
	if sqlca.of_isconnected() then this.event ue_men_disconnect()
	if sqlca.of_connect() then
		this.of_setconnect(true)
		return
	end if
end if
//
if sqlca.of_isconnected() then
	if cfg.ib_confirm_disconnect then
		if MessageBox(app().displayname, 'You are already connected to server "'+sqlca.ServerName+'"~r~n Do you want to disconnect now?',Question!,YesNo!)=2 then return
	end if
	this.triggerEvent('ue_men_disconnect')
end if

open(w_connect)
if message.doubleparm=1 then
	of_setconnect(true)
end if

end event

event ue_men_disconnect();
sqlca.of_disconnect()

of_setconnect(false)

w_statusbar.f_setText('server','')
w_statusbar.f_setText('login','')
of_checkdb()

end event

event ue_men_open();n_file f

string pathname, lsa_files[]
long index=1, ll_i
string filter

filter= "SQL Files (Autodetect),*.sql;*.pro,"+&
			"SQL Files (ANSI),*.sql;*.pro,"+&
			"SQL Files (UTF8),*.sql;*.pro,"+&
			"SQL Files (UTF16),*.sql;*.pro,"+&
			"All Files (Autodetect),*.*,"

if f.of_getopenname(this, "Open SQL File", pathname, lsa_files, "sql", filter, index) then
	if upperbound(lsa_files)=0 then
		of_openfile(pathname,false,index)
	else
		for ll_i = lowerbound(lsa_files) to upperbound(lsa_files)
			of_openfile(pathname+'\'+lsa_files[ll_i],false,index)
		next
	end if
end if


end event

event ue_men_save();uo_tabpage t

t=of_getcurrentpage()
if isValid(t) then
	t.of_save(false)
end if

end event

event ue_men_execute();uo_editpage e

if not of_getcurrentedit(e) then return
of_execute(e,'',true)

end event

event ue_men_close();long i

i=of_gettabindex()

if i>1 then
	of_closeTab(tab_1.control[i])
	tab_1.SelectTab(i - 1)
end if

of_updatemenustatus()

end event

event ue_men_cancel();if this.ib_debugwait then
	//stop the debugger waiting timer
	of_dbg_setwait(false)
else
	m_main m
	m=this.menuid
	m.m_command.m_cancel.popmenu( this.pointerx(), hpb_1.y /*this.pointery()*/ )
end if

end event

event ue_sybexec_resinfo;//
string s
if lparam=0 then return

//in_sqlmsg.of_l2s(lparam,s)
gn_unicode.of_mblong2string(sqlca.of_utf8(), lparam,s)
choose case wparam
	case 1 /*RS_INFO_ROWS*/
		if isValid(irs_current) then irs_current.event ue_resultset_end()
		of_log(0,0,'',0,'('+s+' rows affected)')
	case 2 /*RS_INFO_RET*/
		of_log(0,0,'',0,'return status = '+s)
	case 3 /*RS_INFO_BR_TABLE*/
		if isValid(irs_current) then irs_current.of_sybexec_tabname(s)
end choose

end event

event ue_men_newsession();//
string s=space(4000)

GetModuleFileName(0,s,len(s))
s='"'+s+'"'
if sqlca.of_isconnected( ) and keydown(KeyControl!) then s+=' -S'+sqlca.servername+' -U'+sqlca.logid+' -P'+sqlca.logpass +' -D'+sqlca.database+' -J'+sqlca.is_charset
run(s)

end event

event ue_statusbar_clicked();string obj
string dbname
Menu m
m_dbitem mdb
m_main lm_main
long count=0

obj=message.StringParm

if obj='database' then
	if sqlca.DBHandle()=0 then return
	if sqlca.ib_executing then return
	SetPointer(HourGlass!)
	m=create menu
	
	DECLARE ddlb_cursor DYNAMIC CURSOR FOR SQLSA;
	PREPARE SQLSA FROM 'select name from master..sysdatabases';
	OPEN DYNAMIC ddlb_cursor;
	if sqlca.sqlcode=-1 then return
	
	FETCH ddlb_cursor INTO :dbname;
	do while sqlca.sqlcode=0
		count++
		mdb=create m_dbitem
		mdb.text=dbname
		if dbname=sqlca.database then mdb.checked=true
		m.item[count]=mdb
		FETCH ddlb_cursor INTO :dbname;
	loop
	CLOSE ddlb_cursor;
	if upperbound(m.item) >0 then
		t_rect r
		w_statusbar.f_getrect('database',r)
		m.popmenu(w_statusbar.x+r.left,w_statusbar.y+r.top)
		//m.popmenu(this.pointerX(),this.pointerY())
	else
		this.of_log( 0, -1, '', 0, 'No database selection available.')
	end if
	
	destroy m
elseif obj='eol' then
	lm_main=this.menuid
	lm_main.m_view.m_lineendings.Popmenu(this.pointerX(),this.pointerY())
end if

end event

event ue_select_database();string dbname
if sqlca.ib_executing then return

dbname=String(Message.LongParm, "address")
dbname='use '+dbname
execute immediate :dbname;
of_checkdb()

end event

event type boolean ue_find_next();boolean ret=false
uo_tabpage t

if len(find_text)>0 then
	t=of_getcurrentpage()
	ret=t.of_find(find_text,find_case,find_wword,find_wstart,find_back)
	if not ret then this.SetMicrohelp('Not found')
end if	
of_updatemenustatus()
return ret

end event

event ue_men_viewprocesses();//
string s
long ipaddr=0
uo_editpage e

s=gn_sqlmenu.of_getmenustub('View Processes','','')
//select count(*) into :ipaddr from master..syscolumns 
//	where id=object_id('master..sysprocesses') and name='ipaddr';
//
//s= 'select spid, blk_spid=blocked, status, login=convert(char(12), suser_name(suid)),'
//s+=' hostname, appname=CASE WHEN program_name like "<astc>%" THEN "<astc>" ELSE convert(char(15),program_name) END,'
//s+=' dbname=convert(char(15), db_name(dbid)),'
//if ipaddr>0 then s+=' ipaddr,'
//s+=' cmd=lower(cmd), cpu,mem=memusage, io=physical_io, logged_in=loggedindatetime'
//s+=' from master..sysprocesses'

isproclist=true
of_execute(e,s,true)

end event

event ue_men_closeall();long i

tab_1.SelectTab(1)

for i=Upperbound(tab_1.control) to 2 step -1
	of_closeTab(tab_1.control[i])
next

of_updatemenustatus()

end event

event ue_men_queryprocessplan();//

m_main m
m=this.menuid

m.m_command.m_queryprocessplan.checked=not m.m_command.m_queryprocessplan.checked
showplan=m.m_command.m_queryprocessplan.checked


end event

event ue_men_noexecute();//
m_main m
m=this.menuid

m.m_command.m_noexecute.checked=not m.m_command.m_noexecute.checked
noexecute=m.m_command.m_noexecute.checked

end event

event ue_men_querytimestat();//
m_main m
m=this.menuid

m.m_command.m_querytimestat.checked=not m.m_command.m_querytimestat.checked
timestat=m.m_command.m_querytimestat.checked

end event

event ue_men_print();of_getcurrentpage().of_print()

end event

event ue_men_showrssql();cfg.of_invertoption(cfg.is_showrssql)
of_updateview()

end event

event ue_men_sqlhistory();string s
uo_tabpage t
uo_editpage e

t=of_getcurrentpage()
if t.of_iseditor() then
	//opened from editor
	e=t
	openWithParm(w_history,1)
	s=message.stringparm
	if len(s)>0 then e.of_replaceselected(s)
else
	openWithParm(w_history,0)
end if

end event

event ue_men_querytab();//
tab_1.selectTab(1)

end event

event ue_men_formatsql();//
long ls,le,len
string s
n_asql ln_asql
uo_editpage e
if not of_getcurrentedit(e) then return

ls=e.uo_edit.of_send(e.uo_edit.SCI_GETSELECTIONSTART,0,0)
le=e.uo_edit.of_send(e.uo_edit.SCI_GETSELECTIONEND,0,0)
len=e.uo_edit.of_send(e.uo_edit.SCI_GETLENGTH,0,0)
if len=0 then return

//get text
if ls=le then
	currentselpos=0
	s=space(len+1)
	e.uo_edit.of_sendRef(e.uo_edit.SCI_GETTEXT,len+1, s)
else
	currentselpos=ls
	s=space(le -ls + 1)
	e.uo_edit.of_sendRef(e.uo_edit.SCI_GETSELTEXT,0, s)
end if


ln_asql=create n_asql

open(w_progress)
ln_asql.progressbar=w_progress.hpb_1
s=ln_asql.of_format(s)
close(w_progress)

destroy ln_asql

if ls=le then
	//replace all
	e.uo_edit.of_send(e.uo_edit.SCI_SETTEXT,0,s)
else
	//replace selected
	e.uo_edit.of_send(e.uo_edit.SCI_REPLACESEL,0,s)
end if

end event

event ue_men_browser();open(w_browser)
w_browser.visible=true

end event

event ue_db_change(readonly string database);//
boolean b

b=database<>''
if b then cfg.of_setString('connect','database',database)
w_statusbar.f_setText('database',database)

if b and isValid(w_browser) then
	w_browser.event ue_changestatus()
end if
of_settitle()

end event

event ue_men_cancel_suicide();//
m_main m
n_tr tr
string s
boolean b


m=this.menuid

m.m_command.m_cancel.m_cancel_suicide.enabled=false
m.m_command.m_cancel.enabled=false

tr=create n_tr

tr.autocommit=sqlca.autocommit
tr.database=sqlca.database
tr.dbms=sqlca.dbms
tr.dbparm=sqlca.dbparm
tr.dbpass=sqlca.dbpass
tr.lock=sqlca.lock
tr.logid=sqlca.logid
tr.logpass=sqlca.logpass
tr.servername=sqlca.servername
tr.userid=sqlca.userid

connect using tr;

s=gn_sqlmenu.of_getmenustub( 'Kill Process', 'spid', string(spid))
//s="kill "+string(spid)
execute immediate :s using tr;
b=tr.sqlcode=0
s=tr.sqlerrtext

disconnect using tr;
destroy tr

if b then
	suicidepending=true
else
	f_error(s)
end if
of_updatemenustatus()

end event

event ue_men_windownext();long i,count

count=upperbound(tab_1.control)
if count<2 then return
if of_gettabindex()<count then
	i=of_gettabindex()+1
else
	i=1
end if

tab_1.selecttab(i)

end event

event ue_men_windowprev();long i,count

count=upperbound(tab_1.control)
if count<2 then return
if of_gettabindex()<2 then
	i=count
else
	i=of_gettabindex() - 1
end if

tab_1.selecttab(i)

end event

event ue_men_closeallrs();long i
uo_tabpage t

t=of_getcurrentpage()
if not t.of_iseditor() then tab_1.SelectTab(1)

for i=Upperbound(tab_1.control) to 2 step -1
	t=tab_1.control[i]
	if not t.of_iseditor() then 
		of_closeTab(t)
	end if
next

of_updatemenustatus()

end event

event ue_men_markerset();//
uo_editpage e
long pos,line,mark
if not of_getcurrentedit(e) then return

pos=e.uo_edit.of_send(e.uo_edit.SCI_GETCURRENTPOS,0,0)
line=e.uo_edit.of_send(e.uo_edit.SCI_LINEFROMPOSITION,pos,0)
mark=e.uo_edit.of_send(e.uo_edit.SCI_MARKERGET,line,0)
if mod(mark,2)=1 then
	e.uo_edit.of_send(e.uo_edit.SCI_MARKERDELETE,line, 0)
else
	e.uo_edit.of_send(e.uo_edit.SCI_MARKERADD,line, 0)
end if

end event

event ue_men_markerprev();//
uo_editpage e
long pos,line,nextline
if not of_getcurrentedit(e) then return

pos=e.uo_edit.of_send(e.uo_edit.SCI_GETCURRENTPOS,0,0)
line=e.uo_edit.of_send(e.uo_edit.SCI_LINEFROMPOSITION,pos,0)

nextline=e.uo_edit.of_send(e.uo_edit.SCI_MARKERPREVIOUS,line - 1, 1)
if nextline>=0 then 
	e.uo_edit.of_send(e.uo_edit.SCI_ENSUREVISIBLE,nextline,0)
	e.uo_edit.of_send(e.uo_edit.SCI_GOTOLINE,nextline,0)
else
	this.post SetMicroHelp ( 'No previous markers.' )
end if


end event

event ue_men_markernext();//
uo_editpage e
long pos,line,nextline
if not of_getcurrentedit(e) then return

pos=e.uo_edit.of_send(e.uo_edit.SCI_GETCURRENTPOS,0,0)
line=e.uo_edit.of_send(e.uo_edit.SCI_LINEFROMPOSITION,pos,0)

nextline=e.uo_edit.of_send(e.uo_edit.SCI_MARKERNEXT,line + 1, 1)
if nextline>=0 then 
	e.uo_edit.of_send(e.uo_edit.SCI_ENSUREVISIBLE,nextline,0)
	e.uo_edit.of_send(e.uo_edit.SCI_GOTOLINE,nextline,0)
else
	this.post SetMicroHelp ( 'No next markers.' )
end if


end event

event ue_men_convertlineend();//
uo_editpage e

if not of_getcurrentedit(e) then return

e.uo_edit.of_send(e.uo_edit.SCI_CONVERTEOLS,0,0)

end event

event ue_men_showlineendings();//
uo_editpage e
m_main m
long i

if not of_getcurrentedit(e) then return
m=this.MenuID

i=e.uo_edit.of_send(e.uo_edit.SCI_GETVIEWEOL,0,0)
if i<>0 then
	i=0
	m.m_view.m_lineendings.m_showlineendings.checked=false
else
	i=1
	m.m_view.m_lineendings.m_showlineendings.checked=true
end if
e.uo_edit.of_send(e.uo_edit.SCI_SETVIEWEOL,i,0)
e.uo_edit.of_send(e.uo_edit.SCI_SETVIEWWS, i,0) //1=SCWS_VISIBLEALWAYS

end event

event ue_sqlexec_preview(long al_pos, readonly string as_query, long al_id);currentquery=as_query
currentpos=al_pos
il_currentquery_id=al_id

end event

event ue_sqlexec_end();uo_resultset none //to make unvalid current resultset
cfg.of_popmode()
of_setexec(false)
if not suicidepending then of_checkdb()
if il_execerror>0 then
	of_log(0,-1,'',0,'----------------- Done ( '+string(il_execerror)+' errors ) ------------------')
else
	of_log(0,-1,'',0,'------------------------- Done --------------------------')
end if
SetMicroHelp('Ready')
isproclist=false
//reset reselect flag
il_reselect_id=0
irs_current=none


if suicidepending then
	suicidepending = false
	this.event ue_men_disconnect()
	if sqlca.of_connect() then
		this.of_setconnect(true)
	end if
end if
if isValid(iuo_lastexecpage) then
	iuo_lastexecpage.event ue_sqlexec_end(il_execerror)
end if


end event

event type boolean ue_sqlexec_wantstop();return il_stop_code<>0

end event

event ue_men_copyrtf();//
uo_editpage e
if not of_getcurrentedit(e) then return

e.of_copyrtf()

end event

event ue_men_reselect();uo_tabpage t
uo_resultset r
uo_editpage e

t=of_getcurrentpage()
if t.of_iseditor() then return
if t.il_pagetype=t.typersprocess then return
r=t
il_reselect_id=r.il_query_id
of_execute(e,r.mle_1.text,true)

end event

event ue_men_wrappages();cfg.of_invertoption(cfg.is_WrapPages)
of_updateview()

end event

event ue_men_lineendings_unix();cfg.of_setoption(cfg.is_UnixEOL,true)
of_updateview()

end event

event ue_men_lineendings_win();cfg.of_setoption(cfg.is_UnixEOL,false)
of_updateview()

end event

event ue_men_options();open(w_options)

end event

event ue_men_saveas();uo_tabpage t

t=of_getcurrentpage()
if isValid(t) then
	t.of_save(true)
end if

end event

event ue_men_showlog();//
m_main m
m=this.menuid

this.ib_showlog=not this.ib_showlog
m.m_view.m_showlog.checked=this.ib_showlog

if this.ib_showlog then
	lv_log.visible=true
	st_split.visible=true
	tab_1.height = st_split.y - workspacey()
else
	lv_log.visible=false
	st_split.visible=false
	tab_1.height=lv_log.y+lv_log.height - workspacey()
end if

end event

event ue_men_executeline();uo_editpage e
long i,l,k

if not of_getcurrentedit(e) then return
i=e.uo_edit.of_send( e.uo_edit.SCI_GETCURRENTPOS, 0, 0)
l=e.uo_edit.of_send( e.uo_edit.SCI_LINEFROMPOSITION,i,0)
i=e.uo_edit.of_send( e.uo_edit.SCI_POSITIONFROMLINE,l,0)
k=e.uo_edit.of_send( e.uo_edit.SCI_GETLINEENDPOSITION,l,0)

e.uo_edit.of_send( e.uo_edit.SCI_SETSEL,k,i)


of_execute(e,'',true)

end event

event ue_men_deleteline();uo_editpage e
long i,l,k

if not of_getcurrentedit(e) then return
i=e.uo_edit.of_send( e.uo_edit.SCI_GETCURRENTPOS, 0, 0)
l=e.uo_edit.of_send( e.uo_edit.SCI_LINEFROMPOSITION,i,0)
i=e.uo_edit.of_send( e.uo_edit.SCI_POSITIONFROMLINE,l,0)
k=e.uo_edit.of_send( e.uo_edit.SCI_LINELENGTH,l,0)

e.uo_edit.of_send( e.uo_edit.SCI_SETSEL,i,i+k)
e.uo_edit.of_send( e.uo_edit.SCI_CLEAR,0,0)


end event

event ue_men_comment();//
long ls,le,i,j
uo_editpage e

if not of_getcurrentedit(e) then return

ls=e.uo_edit.of_send(e.uo_edit.SCI_GETSELECTIONSTART,0,0)
le=e.uo_edit.of_send(e.uo_edit.SCI_GETSELECTIONEND,0,0)

ls=e.uo_edit.of_send( e.uo_edit.SCI_LINEFROMPOSITION,ls,0)
le=e.uo_edit.of_send( e.uo_edit.SCI_LINEFROMPOSITION,le,0)

e.uo_edit.of_send(e.uo_edit.SCI_BEGINUNDOACTION,0,0)
for i=ls to le
	j=e.uo_edit.of_send( e.uo_edit.SCI_POSITIONFROMLINE,i,0)
	e.uo_edit.of_send( e.uo_edit.SCI_INSERTTEXT,j,"--")
next
e.uo_edit.of_send(e.uo_edit.SCI_ENDUNDOACTION,0,0)

ls=e.uo_edit.of_send( e.uo_edit.SCI_POSITIONFROMLINE,ls,0)
le=e.uo_edit.of_send( e.uo_edit.SCI_GETLINEENDPOSITION,le,0)

e.uo_edit.of_send( e.uo_edit.SCI_SETSEL,ls,le)

end event

event ue_men_uncomment();long ls,le,i,j
uo_editpage e

if not of_getcurrentedit(e) then return

ls=e.uo_edit.of_send(e.uo_edit.SCI_GETSELECTIONSTART,0,0)
le=e.uo_edit.of_send(e.uo_edit.SCI_GETSELECTIONEND,0,0)

ls=e.uo_edit.of_send( e.uo_edit.SCI_LINEFROMPOSITION,ls,0)
le=e.uo_edit.of_send( e.uo_edit.SCI_LINEFROMPOSITION,le,0)

e.uo_edit.of_send(e.uo_edit.SCI_BEGINUNDOACTION,0,0)
for i=ls to le
	j=e.uo_edit.of_send( e.uo_edit.SCI_POSITIONFROMLINE,i,0)
	if e.uo_edit.of_send( e.uo_edit.SCI_GETCHARAT,j,0)=asc('-') then
		if e.uo_edit.of_send( e.uo_edit.SCI_GETCHARAT,j+1,0)=asc('-') then
			e.uo_edit.of_send( e.uo_edit.SCI_SETSEL,j,j+2)
			e.uo_edit.of_send( e.uo_edit.SCI_CLEAR,0,0)
		end if
	end if
next
e.uo_edit.of_send(e.uo_edit.SCI_ENDUNDOACTION,0,0)

ls=e.uo_edit.of_send( e.uo_edit.SCI_POSITIONFROMLINE,ls,0)
le=e.uo_edit.of_send( e.uo_edit.SCI_GETLINEENDPOSITION,le,0)

e.uo_edit.of_send( e.uo_edit.SCI_SETSEL,ls,le)

end event

event ue_men_help();string fname
if handle(app())<>0 then
	fname=space(4000)
	w_main.GetModuleFileName(0,fname,len(fname))
	fname=f_getfilepart(fname,1)
else
	fname=getCurrentDirectory()+'\'
end if

long ls,le,pos
uo_editpage e
string word

if of_getcurrentedit(e) then
	
	ls=e.uo_edit.of_send(e.uo_edit.SCI_GETSELECTIONSTART,0,0)
	le=e.uo_edit.of_send(e.uo_edit.SCI_GETSELECTIONEND,0,0)
	
	if ls=le then
		pos=ls
		ls=e.uo_edit.of_send(e.uo_edit.SCI_WORDSTARTPOSITION,pos,1)
		le=e.uo_edit.of_send(e.uo_edit.SCI_WORDENDPOSITION,pos,1)
	end if

	if ls<>le and le -ls<255 then
		word=space(le -ls + 1)
		e.uo_edit.of_send(e.uo_edit.SCI_SETSEL,ls, le)
		e.uo_edit.of_sendRef(e.uo_edit.SCI_GETSELTEXT,0, word)
		if pos(word,'~r')=0 and pos(word,'~n')=0 then
			ShowHelp ( fname+"aseqr.hlp", Keyword! , word )
			return
		end if
	end if
end if

ShowHelp ( fname+"aseqr.hlp", Index! )

end event

event ue_men_dbg_detach();uo_tabpage t
uo_resultset_grid rs
long row
long ll_spid
string msg="You are not currently debugging this process.~r~nAnd you are going to stop debugging of it.~r~nUse this only in case if you want to unblock the process.~r~nAre you sure you want to continue?"

if sqlca.il_dbg_spid>0 then 
	//detach currently attached process
	sqlca.of_dbg_detach( 0 )
	of_updatemenustatus()
	uo_editpage e
	
	if w_main.of_getcurrentedit(e) then
		e.of_dbg_updatestops( )
	end if
else
	//detach selected process
	t=of_getcurrentpage()
	if isValid(t) then
		if t.il_pagetype=t.typersprocess then
			rs=t
			row=rs.dw_1.getrow()
			if row>0 then
				ll_spid=long(rs.dw_1.getItemString(row,1))
				if ll_spid>0 then
					if MessageBox(app().displayname,msg,exclamation!,YesNo!,2)=1 then
						sqlca.of_dbg_detach( ll_spid )
					end if
				end if
			end if
		end if
	end if
end if

end event

event ue_men_dbg_attach();//

uo_tabpage t
uo_resultset_grid rs
long row
long ll_spid

t=of_getcurrentpage()

if isValid(t) then
	if t.il_pagetype=t.typersprocess then
		rs=t
		row=rs.dw_1.getrow()
		if row>0 then
			ll_spid=long(rs.dw_1.getItemString(row,1))
			if ll_spid>0 then
				sqlca.of_dbg_attach( ll_spid )
				of_updatemenustatus()
			end if
		end if
	end if
end if

end event

event ue_men_dbg_stop();uo_editpage e
long i,k

if not of_getcurrentedit(e) then return

if e.il_objtype=gn_sqlmenu.typeprocedure or e.il_objtype=gn_sqlmenu.typetrigger then
	i=e.uo_edit.of_send( e.uo_edit.SCI_GETCURRENTPOS, 0, 0)
	i=e.uo_edit.of_send( e.uo_edit.SCI_LINEFROMPOSITION,i,0)+1
	
	k=e.uo_edit.of_send(e.uo_edit.SCI_MARKERGET,i - 1,0)
	if f_and(k,2^e.marker_stop)<>0 then
		//we have a breakpoint here
		w_browser.tab_1.page_dbg.of_dbg_deletestop(e.is_obj_database+'.'+e.is_obj_owner+'.'+e.is_obj_name,i)
	else
		w_browser.tab_1.page_dbg.of_dbg_stop(e.is_obj_database+'.'+e.is_obj_owner+'.'+e.is_obj_name,i)
	end if
	e.of_dbg_updatestops( )
	of_updatemenustatus()
end if

end event

event ue_men_dbg_step();uo_editpage e

if not of_getcurrentedit(e) then return

if e.il_objtype=gn_sqlmenu.typeprocedure or e.il_objtype=gn_sqlmenu.typetrigger then
	if w_browser.tab_1.page_dbg.of_dbg_step('') then
		of_dbg_wait()
	end if
end if

end event

event ue_men_dbg_continue();if w_browser.tab_1.page_dbg.is_where_obj>'' then
	w_browser.tab_1.page_dbg.of_dbg_continue()
end if
of_dbg_wait()

end event

event ue_men_dbg_stepout();uo_editpage e

if not of_getcurrentedit(e) then return

if e.il_objtype=gn_sqlmenu.typeprocedure or e.il_objtype=gn_sqlmenu.typetrigger then
	if w_browser.tab_1.page_dbg.of_dbg_step('out') then
		of_dbg_wait()
	end if
end if

end event

event ue_men_dbg_stepin();uo_editpage e

if not of_getcurrentedit(e) then return

if e.il_objtype=gn_sqlmenu.typeprocedure or e.il_objtype=gn_sqlmenu.typetrigger then
	if w_browser.tab_1.page_dbg.of_dbg_step('into') then
		of_dbg_wait()
	end if
end if

end event

event ue_men_dbg_deleteall();//
uo_editpage e

w_browser.tab_1.page_dbg.of_dbg_deletestop('',0)
of_updatemenustatus()
if of_getcurrentedit(e) then e.of_dbg_updatestops( )

end event

event ue_men_copyvarprint();//

//
uo_editpage e
if not of_getcurrentedit(e) then return

e.of_copyvarprint()

end event

event ue_men_case_key_up();uo_editpage e
if not of_getcurrentedit(e) then return
e.of_changecase('ku')

end event

event ue_men_case_key_lo();uo_editpage e
if not of_getcurrentedit(e) then return
e.of_changecase('kl')

end event

event ue_men_case_up();uo_editpage e
if not of_getcurrentedit(e) then return
e.of_changecase('up')

end event

event ue_men_case_lo();uo_editpage e
if not of_getcurrentedit(e) then return
e.of_changecase('lo')

end event

event ue_men_case_ti();uo_editpage e
if not of_getcurrentedit(e) then return
e.of_changecase('ti')

end event

event ue_men_insertstub();//
string s
char c
uo_editpage e
long ls,le,pos
string word

if not this.of_getcurrentedit( e ) then return

ls=e.uo_edit.of_send(e.uo_edit.SCI_GETSELECTIONSTART,0,0)
le=e.uo_edit.of_send(e.uo_edit.SCI_GETSELECTIONEND,0,0)

if ls=le then
	pos=ls
	if pos>0 then
		c=char(e.uo_edit.of_send(e.uo_edit.SCI_GETCHARAT,pos -1,0))
		if pos(e.is_wordchars,c)>0 then
			ls=e.uo_edit.of_send(e.uo_edit.SCI_WORDSTARTPOSITION,pos,1)
			le=e.uo_edit.of_send(e.uo_edit.SCI_WORDENDPOSITION,pos,1)
			e.uo_edit.of_send(e.uo_edit.SCI_SETSEL,ls, le)
		end if
	end if
end if

if ls<>le then
	word=space(le -ls + 1)
	e.uo_edit.of_sendRef(e.uo_edit.SCI_GETSELTEXT,0, word)
end if

e.of_insertstub(word,false)

end event

event ue_men_workspacesave();string filepath, filename

if is_workspacename='' then
	if GetFileSaveName ( "Save workspace", filepath, filename, 'sws', "Workspace Files (*.sws),*.sws")<>1 then return
	if FileExists(filepath) then 
		If MessageBox(app().displayname, filepath+' already exists.~r~nDo you want to replace it?',Exclamation!,YesNo!)=2 then return
	end if
else
	filepath=is_workspacepath
end if
of_workspacesave(filepath)

end event

event ue_men_workspaceload();string pathname, filename

if GetFileOpenName ( "Open Workspace File", pathname, filename, "sws", "Workspace Files (*.sws),*.sws,All files,*.*")=1 then
	of_workspaceopen(pathname)
end if

end event

event ue_men_cancel_all();//
long i
of_log(0,0,'',0,'(Cancel query.)')
post SetMicroHelp('Cancelling...')
//new cancel all
i=this.in_sqlexec_trig.of_cancel_all( sqlca )
if i<>1 then of_log(0,0,'',0,'Cancel returned '+string(i))

il_stop_code=6001
of_updatemenustatus()

end event

event ue_men_cancel_current();//
il_stop_code=6000

of_log(0,0,'',0,'(Cancel query.)')
post SetMicroHelp('Cancelling...')
of_updatemenustatus()

end event

event dropfiles;long i,count,len
string s

count=DragQueryFile(handle,-1,s, 0)

for i=0 to count -1
	setnull(s)
	len=DragQueryFile(handle,i,s, 0)
	s=space(len+1)
	DragQueryFile(handle,i,s, len+1)
	post of_openfile(s,false,0)
next


DragFinish(handle)
return 0

end event

event ue_find();long ls,le
string s
uo_editpage e

open(w_find)

if of_getcurrentedit(e) then 
	ls=e.uo_edit.of_send(e.uo_edit.SCI_GETSELECTIONSTART,0,0)
	le=e.uo_edit.of_send(e.uo_edit.SCI_GETSELECTIONEND,0,0)
	if ls<le then
		s=space(le - ls +2)
		e.uo_edit.of_sendRef(e.uo_edit.SCI_GETSELTEXT,0, s)
		w_find.of_settext(s)
	end if
end if

end event

event ue_men_showspaces();//
uo_editpage e
m_main m
long i

if not of_getcurrentedit(e) then return
m=this.MenuID

i=e.uo_edit.of_send(e.uo_edit.SCI_GETVIEWWS,0,0)
if i<>0 then
	i=0
else
	i=1
end if
e.uo_edit.of_send(e.uo_edit.SCI_SETVIEWWS, i,0) //1=SCWS_VISIBLEALWAYS
this.of_updatemenustatus()

end event

event ue_men_executeexport();uo_editpage e

if not of_getcurrentedit(e) then return

cfg.of_pushmode('export')
of_execute(e,'',true)

end event

event ue_men_exportdata();uo_editpage e
long i,n
string sa[],query

open(w_export)
if message.stringparm='' then return

gf_parsestring(message.stringparm,'~t',sa,false)
n=upperbound(sa)

for i=1 to n
	if trim(sa[i])<>'' then 
		query+='select * from '+trim(sa[i])+' for browse~r~n'
	end if
next
if query<>'' then
	cfg.of_pushmode('export')
	of_execute(e,query,true)
end if




end event

event ue_sybexec_setfieldinfo;string s
uo_resultset none

if lparam=0 then
	setNull(s)
else
	gn_unicode.of_mblong2string(sqlca.of_utf8(), lparam,s)
end if

if isValid(irs_current) then irs_current.of_sybexec_setfieldinfo(wparam,s)


end event

public function boolean of_getcurrentedit (ref uo_editpage e);uo_tabpage t
t=of_getcurrentpage()
if t.of_iseditor() then 
	e=t
	return true
end if
return false

end function

public function boolean of_pastetext (readonly string s);uo_editpage e
if not of_getcurrentedit(e) then return false

if len(s)>0 then e.uo_edit.of_send(e.uo_edit.SCI_REPLACESEL,0,s)
return true

end function

public function boolean of_pastetextnomove (readonly string s);long pos
uo_editpage e

if not of_getcurrentedit(e) then return false

if len(s)>0 then 
	pos=e.uo_edit.of_send(e.uo_edit.SCI_GETSELECTIONSTART,0,0)
	e.uo_edit.of_send(e.uo_edit.SCI_REPLACESEL,0,s)
	pos=e.uo_edit.of_send(e.uo_edit.SCI_GOTOPOS,pos,0)
end if
return true

end function

public function uo_tabpage of_getcurrentpage ();long l

//let's use windows message to get current tabpage instead of 
//PB tab_1.selectedtab because in some situations it's not updated
l=send(handle(tab_1),4864+11 /*TCM_GETCURSEL*/ ,0,0)+1
return tab_1.control[l]

end function

public subroutine of_showpos (readonly uo_editpage e);
long pos,line,col

if isNull(e) then return
if not isvalid(e) then return

pos=e.uo_edit.of_send(e.uo_edit.SCI_GETCURRENTPOS,0,0)
line=e.uo_edit.of_send(e.uo_edit.SCI_LINEFROMPOSITION,pos,0)+1
col=e.uo_edit.of_send(e.uo_edit.SCI_GETCOLUMN,pos,0)+1
if isValid(w_statusbar) then w_statusbar.f_setText ( "pos", string(line)+":"+string(col) )

end subroutine

public subroutine of_setexec (boolean b);sqlca.ib_executing=b

if noexecute and not sqlca.ib_executing then 
	execute immediate 'set noexec off';
end if

of_updatemenustatus()
of_settitle()

if showplan then
	if sqlca.ib_executing then
		execute immediate 'set showplan on';
	else
		execute immediate 'set showplan off';
	end if
end if

if timestat then
	if sqlca.ib_executing then
		execute immediate 'set statistics time,io on';
	else
		execute immediate 'set statistics time,io off';
	end if
end if

if noexecute and sqlca.ib_executing then 
	execute immediate 'set noexec on';
end if

end subroutine

public subroutine of_settitle ();string s

if sqlca.ib_executing then s='* '
if is_workspacename>'' then s+=is_workspacename+' :: '
if sqlca.of_isconnected() then s+=sqlca.serverName+'.'+sqlca.database+' - '
s+=app().displayname

s+=' ['+of_GetCurrentPage().text +']'


this.title=s

end subroutine

public function boolean of_iseditoractive ();return of_getcurrentpage().of_iseditor()

end function

public subroutine of_setconnect (boolean b);if b then
	string ls_spid
	execute immediate "dbcc traceon (3604)"; //redirect dbcc output to the client session
	spid=long(f_selectstring("select convert(varchar(20),@@spid)","0"))
	w_statusbar.f_setText('server',sqlca.servername)
	w_statusbar.f_setText('login',sqlca.LogID)
	sqlca.database=''
	of_checkdb()
end if

of_updatemenustatus()
of_settitle()

end subroutine

public function boolean of_findresultset (ref uo_resultset ars_after, long al_id);uo_tabpage t
uo_resultset r,none
long i,count,start=1

count=upperbound(tab_1.control)

if isValid(ars_after) then
	start=count+1
	for i=1 to count
		if ars_after=tab_1.control[i] then start=i+1
	next
else
	start=1
end if

for i=start to count
	t=tab_1.control[i]
	if not t.of_iseditor() then
		r=t
		if r.il_query_id=al_id then 
			ars_after=r
			return true
		end if
	end if
next
ars_after=none
return false

end function

public function boolean of_getprocesspage (ref uo_resultset ars);uo_tabpage t
uo_resultset none
long i,count

count=upperbound(tab_1.control)

for i=1 to count
	t=tab_1.control[i]
	if t.il_pagetype=t.typersprocess then
		ars=t
		return true
	end if
next
ars=none
return false

end function

public subroutine of_updatemenustatus ();m_main m
m=this.menuid
uo_tabpage p
uo_editpage e
boolean con

//updates menu status enable/disable management

con=sqlca.of_isconnected()
p=of_getcurrentpage()
if p.of_iseditor() then e=p
//---------------------------------------------------------
m.m_file.m_exit.enabled=not sqlca.ib_executing
m.m_file.m_save.enabled=p.of_iseditor()
if p.of_iseditor() then
	m.m_file.m_save.enabled=e.uo_edit.of_send( e.uo_edit.SCI_GETMODIFY , 0, 0)<>0
end if


m.m_file.m_saveas.enabled=p.of_iseditor() or not sqlca.ib_executing

m.m_edit.m_copyrtf.enabled= p.of_iseditor()
m.m_edit.m_copyvarprint.enabled= p.of_iseditor()
m.m_edit.m_formatsql.enabled= p.of_iseditor()
m.m_edit.m_findnext.enabled=(/*p.of_iseditor() and*/ len(find_text)>0)
/*m.m_edit.m_find.enabled= p.of_iseditor()*/
m.m_edit.m_replace.enabled= p.of_iseditor()
m.m_edit.m_deleteline.enabled= p.of_iseditor()
m.m_edit.m_marker.enabled= p.of_iseditor()
m.m_edit.m_marker.m_markerset.enabled= p.of_iseditor()
m.m_edit.m_marker.m_markerprev.enabled= p.of_iseditor()
m.m_edit.m_marker.m_markernext.enabled= p.of_iseditor()

m.m_command.m_execute.enabled=not sqlca.ib_executing and con and p.of_iseditor()
//disable exec if current object is under dedug
if p.il_pagetype=p.typeeditobject and ( p.il_objtype = gn_sqlmenu.typeprocedure or p.il_objtype = gn_sqlmenu.typetrigger ) then
	if e.of_equals(w_browser.tab_1.page_dbg.is_where_obj) then m.m_command.m_execute.enabled=false
end if

m.m_command.m_executeline.enabled=m.m_command.m_execute.enabled
m.m_command.m_executex.enabled=m.m_command.m_execute.enabled
//reexecute is different from execute
m.m_command.m_reexecute.enabled=not sqlca.ib_executing and con and not p.of_iseditor() and p.il_pagetype<>p.typersprocess

m.m_tools.m_executeexport.enabled=false and not sqlca.ib_executing and con
m.m_tools.m_exportdatatosql.enabled=not sqlca.ib_executing and con


m.m_command.m_cancel.m_cancel_all.enabled=sqlca.ib_executing and il_stop_code=0 and not suicidepending and con
m.m_command.m_cancel.m_cancel_current.enabled=m.m_command.m_cancel.m_cancel_all.enabled
m.m_command.m_cancel.m_cancel_suicide.enabled=sqlca.ib_executing and con and not suicidepending and sqlca.il_dbg_spid<=0 //disable suicide if debugger is active
m.m_command.m_cancel.enabled=m.m_command.m_cancel.m_cancel_all.enabled or m.m_command.m_cancel.m_cancel_suicide.enabled
m.m_command.m_cmd_cancel.enabled=m.m_command.m_cancel.enabled

m.m_command.m_cancel.visible=sqlca.il_dbg_spid<=0
m.m_command.m_cmd_cancel.visible=sqlca.il_dbg_spid>0

m.m_command.m_queryprocessplan.enabled=not sqlca.ib_executing and con
m.m_command.m_querytimestat.enabled=not sqlca.ib_executing and con
m.m_command.m_noexecute.enabled=not sqlca.ib_executing and con

m.m_command.m_connect.enabled=not sqlca.ib_executing
m.m_command.m_reconnect.enabled=not sqlca.ib_executing and sqlca.servername>'' and sqlca.logid>'' and sqlca.database>''
m.m_command.m_disconnect.enabled=not sqlca.ib_executing and con

m.m_command.m_viewprocesses.enabled=not sqlca.ib_executing and con
//m.m_command.m_browser.enabled=not executing and con

//debug menu
m.m_debug.m_dbg_attach.enabled = con and not sqlca.ib_executing and sqlca.il_dbg_spid<=0 and p.il_pagetype=p.typersprocess
m.m_debug.m_dbg_detach.enabled = con and not sqlca.ib_executing and (sqlca.il_dbg_spid>0 or p.il_pagetype=p.typersprocess)
m.m_debug.m_dbg_breakpoint.enabled = con and not sqlca.ib_executing and sqlca.il_dbg_spid>0 and p.il_pagetype=p.typeeditobject and ( p.il_objtype = gn_sqlmenu.typeprocedure or p.il_objtype = gn_sqlmenu.typetrigger )
m.m_debug.m_dbg_deleteall.enabled = con and not sqlca.ib_executing and sqlca.il_dbg_spid>0 and w_browser.tab_1.page_dbg.il_stopcount>0

m.m_debug.m_dbg_step.enabled = con and not sqlca.ib_executing and sqlca.il_dbg_spid>0 and w_browser.tab_1.page_dbg.is_where_obj>''
m.m_debug.m_dbg_stepin.enabled = m.m_debug.m_dbg_step.enabled 
m.m_debug.m_dbg_stepout.enabled = m.m_debug.m_dbg_step.enabled 
m.m_debug.m_dbg_continue.enabled = con and not sqlca.ib_executing and sqlca.il_dbg_spid>0 and w_browser.tab_1.page_dbg.il_stopcount>0

m.m_debug.m_dbg_step.toolbaritemvisible=con and sqlca.il_dbg_spid>0
m.m_debug.m_dbg_stepin.toolbaritemvisible=con and sqlca.il_dbg_spid>0
m.m_debug.m_dbg_stepout.toolbaritemvisible=con and sqlca.il_dbg_spid>0
m.m_debug.m_dbg_continue.toolbaritemvisible=con and sqlca.il_dbg_spid>0
//debug end

m.m_view.m_lineendings.m_showlineendings.enabled=p.of_iseditor()
if p.of_iseditor() then
	m.m_view.m_lineendings.m_showlineendings.checked=(e.uo_edit.of_send(e.uo_edit.SCI_GETVIEWEOL,0,0)<>0)
end if

m.m_view.m_showspaces.enabled=p.of_iseditor()
if p.of_iseditor() then
	m.m_view.m_showspaces.checked=(e.uo_edit.of_send(e.uo_edit.SCI_GETVIEWWS,0,0)<>0)
end if

m.m_window.m_close.enabled=(not sqlca.ib_executing or p.of_iseditor()) and of_gettabindex()>1
m.m_window.m_closeresultsets.enabled=not sqlca.ib_executing and p.of_getresultsetcount()>0

if isValid(w_browser) then
	w_browser.event ue_changestatus()
end if

end subroutine

public subroutine of_updateview ();m_main m
uo_tabpage t
long i,count

//updates the controls view according to the options set

m=this.MenuID

m.m_view.m_lineendings.m_lineendings_unix.checked=cfg.of_getoption(cfg.is_UnixEOL)
m.m_view.m_lineendings.m_lineendings_win.checked=not m.m_view.m_lineendings.m_lineendings_unix.checked
if m.m_view.m_lineendings.m_lineendings_unix.checked then
	w_statusbar.f_setText ( "eol", "<LF>" )
else
	w_statusbar.f_setText ( "eol", "<CRLF>" )
end if

count=upperbound(tab_1.control)
for i=1 to count
	t=tab_1.control[i]
	t.of_updateview()
next
tab_1.multiline=cfg.of_getoption(cfg.is_WrapPages)

end subroutine

public function boolean of_openobject (readonly string as_name, long al_objtype, boolean ab_clone);long i,count,h
uo_editpage e,ei
uo_tabpage t
long ver
boolean lb_activate
treeviewitem tvi

string ls_db,ls_owner,ls_name,ls_text

lb_activate=not keydown(KeyShift!)

if al_objtype=0 then
	al_objtype=gn_sqlmenu.of_getobjtypei(as_name)
	if not of_canopenobject(al_objtype) then return false
end if

gn_sqlmenu.of_parsename(as_name,ls_db,ls_owner,ls_name)

//may be object is already opened?

count=upperbound(tab_1.control)
for i=1 to count
	t=tab_1.control[i]
	if t.il_pageType=t.typeEditObject then
		ei=t
		if ei.is_obj_database=ls_db and ei.is_obj_owner=ls_owner and ei.is_obj_name=ls_name then
			if not ab_clone then
				if lb_activate then tab_1.selecttab( ei )
				return true
			end if
			ver=ei.il_clone+1
		end if
	end if
next

tab_1.openTab(e,0)

if ls_owner<>'dbo' then ls_text+=ls_owner+'.'
ls_text+=ls_name
if ver>0 then ls_text+=' :'+string(ver)

e.of_init(ls_text,e.typeEditObject,al_objtype,sqlca.servername+'.'+ls_db+'.'+ls_owner+'.'+ls_name)
e.is_obj_database=ls_db
e.is_obj_owner=ls_owner
e.is_obj_name=ls_name
e.il_clone=ver

e.of_settext( gn_sqlmenu.of_proctext(as_name) )

//e.of_setobjectfooter(gn_sqlmenu.of_getobjectfooter(as_name)) //moved to uo_editpage.of_getobjfooter()
if lb_activate then tab_1.selectTab(e)

return true

end function

public subroutine of_checkdb ();any ss[]={'',''}
string query


if sqlca.of_isconnected( ) then
	//s=f_selectstring('select db_name()','')
	query="select db_name()"
	if sqlca.is_charset_var>'' then query+=","+sqlca.is_charset_var
	f_selectfirst(query,ss)
else
//	s=''
end if
if ss[1]<>sqlca.database then
	if ss[1]<>'' then sqlca.database=ss[1] //database
	this.event ue_db_change(ss[1])
end if

if sqlca.is_charset_var>'' and ss[2]<>'' then 
	sqlca.is_charset=ss[2]
end if
w_statusbar.f_setText ( "charset", ss[2] )

end subroutine

public function long of_gettabindex ();long l

//let's use windows message to get current tabpage instead of 
//PB tab_1.selectedtab because in some situations it's not updated
l=send(handle(tab_1),4864+11 /*TCM_GETCURSEL*/ ,0,0)+1
return l

end function

public function boolean of_parsecmd (string cmd);long i,len
string chr
string state=''
string parm=''
string srv,db,uid,pwd,cs
string host
string file
boolean lb_pwenc,lb_datenc

len=len(cmd)
for i=1 to len
	chr=mid(cmd,i,1)
	choose case state
		case ''
			choose case chr
				case '"'
					state='parms'
				case ' ','~t'
					//keep the default status and just skip spaces
				case else
					state='parm'
					parm+=chr
			end choose
		case 'parms'
			choose case chr
				case '"'
					state=''
				case else
					parm+=chr
					if i=len then state=''
			end choose
		case 'parm'
			choose case chr
				case ' ','~t'
					state=''
				case else
					parm+=chr
					if i=len then state=''
			end choose
	end choose
	if state='' and parm>'' then
		//we got a parameter
		if mid(parm,1,1)='-' then
			choose case mid(parm,2,1)
				case 'D'
					db=mid(parm,3)
				case 'S'
					srv=mid(parm,3)
				case 'U'
					uid=mid(parm,3)
				case 'P'
					pwd=mid(parm,3)
				case 'J'
					cs=mid(parm,3)
				case 'H'
					host=mid(parm,3)
				case 'X'
					lb_pwenc=true
				case 'z'
					lb_datenc=true
				case else
					file=parm
			end choose
		else
			file=parm
		end if
		parm=''
	end if
next

if srv>'' and uid>'' then
	if sqlca.of_connect(srv,db,uid,pwd,cs,host,lb_pwenc, lb_datenc) then
		of_setconnect(true)
	end if
end if
if file>'' then
	if f_getfilepart(file,4)='.sws' then
		this.post of_workspaceopen(file)
	else
		this.post of_openfile(file,false,0)
	end if
end if
return true

end function

public function boolean of_execute (readonly uo_editpage e, readonly string as_query, boolean ab_post);long i,ls,le,len
string qarray[]

if isValid(e) then
	ls=e.uo_edit.of_send(e.uo_edit.SCI_GETSELECTIONSTART,0,0)
	le=e.uo_edit.of_send(e.uo_edit.SCI_GETSELECTIONEND,0,0)
	len=e.uo_edit.of_send(e.uo_edit.SCI_GETLENGTH,0,0)
	if len=0 then return false
	//exec
	if ls=le then
		//nothing selected: execute all
		currentselpos=0
		qarray[2]=space(len+1)
		e.uo_edit.of_sendRef(e.uo_edit.SCI_GETTEXT,len+1, qarray[2])
		if e.of_match() then
			if e.il_pagetype=e.typeEditFile and ib_saveonexec then e.of_save(false)
			qarray[1]=f_converteol(e.of_getobjheader())
			qarray[3]=f_converteol(e.of_getobjfooter(false))
		else
			this.setMicrohelp("Script does not match object creation pattern.")
		end if
	else
		//execute only selection
		currentselpos=ls
		qarray[2]=space(le -ls + 1)
		e.uo_edit.of_sendRef(e.uo_edit.SCI_GETSELTEXT,0, qarray[2])
	end if
	//add to histo only if executed by user
	history.of_add(qarray[2])
	qarray[2]=f_converteol(qarray[2])
	
	if not sqlca.of_utf8( ) then
		//check if no data will be lost during ansi conversation
		if not gn_unicode.of_hasonlyansi(qarray[2]) then
			i=MessageBox(app().displayname, 'The SQL commands contains Unicode characters that could be lost if you execute it with non-Unicode charser.~r~nDo you want to Continue?',Exclamation!,YesNo!)
			if i=2 then return false
		end if
	end if
	

else
	if len(as_query)>0 then
		qarray[1]=as_query
	else
		return false
	end if
end if

iuo_lastexecpage=e
lv_log.DeleteItems ( )

of_log(0,-1,'',0,'------------------------ Execute ------------------------')
SetMicroHelp('Executing...')
if gn_sqlmenu.si_fm then sleep(mod(second(now()),4)+2)
il_stop_code=0
of_setexec(true)
il_execerror=0
if ab_post then 
	in_sqlexec.post of_go(sqlca.dbHandle(),sqlca.of_utf8( ) ,qarray, handle(this),in_locator)
else
	in_sqlexec_trig.of_go(sqlca.dbHandle(),sqlca.of_utf8( ) ,qarray, handle(this),in_locator)
end if

return true

end function

public function boolean of_closetab (readonly uo_tabpage o);long tcm_first=4864
long TCM_GETROWCOUNT=tcm_first+44
long count,oldheight

if o.event ue_closeprompt() then
	count=Send(handle(tab_1),TCM_GETROWCOUNT,0,0)
	tab_1.closetab( o )
	
	if count<>Send(handle(tab_1),TCM_GETROWCOUNT,0,0) then
		oldheight=tab_1.height
		tab_1.height +=10
		tab_1.height  =oldheight
	end if
else
	return false
end if
return true

end function

public function boolean of_dbg_control (readonly string parm);uo_editpage e

iuo_lastexecpage=e
lv_log.DeleteItems ( )

of_log(0,-1,'',0,'------------------------ Debug ------------------------')
il_stop_code=0

sqlca.ib_executing=true //not using set exec because
of_updatemenustatus()
of_settitle()

il_execerror=0
in_sqlexec.post dbgrpc_control(sqlca.dbHandle(),sqlca.il_dbg_spid,parm,handle(this),in_locator)

return true

end function

public function boolean of_dbg_wait ();//checks if we have active breakpoint,
//if no  - activate debug wait timer
//if yes - stop wait timer and goto active breakpoint 
uo_editpage e
long ll

//request where info (active breakpoint)
if not w_browser.tab_1.page_dbg.of_dbg_where() then
	//if error stop and exit
	of_dbg_setwait(false)
	return false
end if

if w_browser.tab_1.page_dbg.is_where_obj>'' then
	//the breakpoint is active?
	//so, stop the waiting timer
	//and update all debugger info
	of_dbg_setwait(false)
	
	//update all debug info
	w_browser.tab_1.page_dbg.of_dbg_variables()
	w_browser.tab_1.page_dbg.of_dbg_stops()
	//here we should activate and editor with active breakpoint
	if of_openobject(w_browser.tab_1.page_dbg.is_where_obj,0,false) then
		if w_main.of_getcurrentedit(e) then
			//e.of_dbg_updatestops( ) //already called by selecting current page
			//goto the current breakpoint line
			ll=w_browser.tab_1.page_dbg.il_where_line
			if cfg.ib_debug_correctrow then ll=e.of_getcorrectedline( ll )
			e.uo_edit.of_send( e.uo_edit.SCI_ENSUREVISIBLE,ll -1/*start from 0*/,0)
			e.uo_edit.of_send( e.uo_edit.SCI_GOTOLINE,ll -1/*start from 0*/,0)
		end if
	end if
	w_browser.show()
	w_browser.tab_1.selectTab(4)
	return true
end if


if this.ib_debugwait then
	return true
else
	//lv_log.DeleteItems ( )
	of_log(0,-1,'debugger',0,'Waiting for remote process #'+string(sqlca.il_dbg_spid)+' rich the breakpoint ...')
	of_dbg_setwait(true)
	return true
end if

end function

public function boolean of_dbg_setwait (boolean b);il_stop_code=0
this.ib_debugwait=b
this.il_execerror=0

sqlca.ib_executing=b //not using set exec because
of_updatemenustatus()
of_settitle()

if b then
	timer( 2, this ) //one second interval
else
	timer( 0, this ) //switch off timer
	uo_editpage e
	
	if this.of_getcurrentedit(e) then
		e.of_dbg_updatestops( )
	end if
end if
return true

end function

public function boolean of_canopenobject (readonly integer ai_type);
CHOOSE CASE ai_type
	CASE gn_sqlmenu.typeProcedure, gn_sqlmenu.typeTrigger, gn_sqlmenu.typeView
		//it's ok.
	CASE ELSE
		return false
END CHOOSE

return true

end function

public function boolean of_workspaceopen (readonly string as_file);int li_f
long i
string ls,ls_srv,ls_uid,ls_pwd,ls_db,ls_cs,ls_host
boolean lb_pwenc,lb_datenc
string ls_stat='default'
string ls_open[]
string ls_query
uo_editpage e

li_f=fileopen(as_file,LineMode!,Read!,LockWrite!)

if li_f<>-1 then
	do while FileRead ( li_f, ls)>=0
		//
		choose case ls_stat
			case 'default'
				if ls<>'#aseisql workspace' then
					fileclose(li_f)
					return false
				end if
				ls_stat='waitconnect'
			case 'waitconnect'
				if lower(trim(ls))='[connect]' then
					ls_stat='connect'
				end if
			case 'connect'
				ls=trim(ls)
				if lower(ls)='[open]' then
					ls_stat='open'
				else
					i=pos(ls,'=')
					choose case lower(trim(left(ls,i - 1)))
						case 'server'
							ls_srv=trim(mid(ls,i+1))
						case 'database'
							ls_db=trim(mid(ls,i+1))
						case 'charset'
							ls_cs=trim(mid(ls,i+1))
						case 'login'
							ls_uid=trim(mid(ls,i+1))
						case 'password'
							ls_pwd=trim(mid(ls,i+1))
						case 'hostname'
							ls_host=trim(mid(ls,i+1))
						case 'encryptedpassword'
							ls_pwd=f_crypt(trim(mid(ls,i+1)),false)
						case 'encrypt.password'
							lb_pwenc=( lower(trim(mid(ls,i+1)))='true' )
						case 'encrypt.data'
							lb_datenc=( lower(trim(mid(ls,i+1)))='true' )
					end choose
				end if
			case 'open'
				ls=trim(ls)
				if lower(ls)='[query]' then
					ls_stat='query'
				else
					i=pos(ls,'=')
					if i>0 then
						ls_open[upperbound(ls_open)+1]=trim(lower(left(ls,i -1)))+'='+mid(ls,i+1)
					end if
				end if
			case 'query'
				ls_query	+= ls +'~r~n'
		end choose
	loop
	fileclose(li_f)
	if ls_srv>'' then 
		setPointer(HourGlass!)
		this.event ue_men_disconnect()
		if trim(ls_host)='' then ls_host=cfg.of_gethostname()
		if sqlca.of_connect( ls_srv, ls_db, ls_uid, ls_pwd, ls_cs, ls_host, lb_pwenc, lb_datenc ) then
			this.of_setconnect(true)
		end if
	end if
	for i=1 to upperbound(ls_open)
		if left(ls_open[i],5)='file=' then
			ls=mid(ls_open[i],6)
			if left(ls,2)='\\' or left(ls,2)='//' or pos(ls,':')>0 then
				w_main.of_openfile(ls,false,0)
			else
				w_main.of_openfile(f_getfilepart(as_file,1)+ls,false,0)
			end if
		elseif left(ls_open[i],4)='obj=' then
			if sqlca.of_isconnected() then
				ls=mid(ls_open[i],5)
				w_main.of_openobject(ls,0,false)
			end if
		elseif left(ls_open[i],4)='dir=' then
			ChangeDirectory(mid(ls_open[i],5))
		else
			//unknown , so ignore
		end if
	next
	w_main.tab_1.selecttab(1)
	if w_main.of_getcurrentedit(e) then
		e.of_settext( ls_query )
	end if
	is_workspacepath=as_file
	is_workspacename=f_getfilepart(is_workspacepath,2)
	of_settitle()
else
	MessageBox(app().displayname,"Can't open file~r~n"+as_file)
	return false
end if

return true


end function

public function boolean of_workspacesave (readonly string as_file);int li_f
long i
uo_tabpage t
uo_editpage e
string ls_wspath

li_f=FileOpen ( as_file, LineMode!,Write!,LockWrite!,Replace!)
ls_wspath=lower(f_getfilepart(as_file,1))
if li_f<>-1 then
	FileWrite ( li_f, '#aseisql workspace' )
	FileWrite ( li_f, '#you should not change the place of the sections' )
	FileWrite ( li_f, '' )
	FileWrite ( li_f, '[connect]' )
	if sqlca.of_isconnected( ) then
		FileWrite ( li_f, 'Server           =' +sqlca.servername)
		FileWrite ( li_f, 'Database         =' +sqlca.database)
		FileWrite ( li_f, 'Charset          =' +sqlca.is_charset)
		FileWrite ( li_f, 'Login            =' +sqlca.logid)
		FileWrite ( li_f, '#Password         =' )
		FileWrite ( li_f, 'EncryptedPassword=' +f_crypt(sqlca.logpass,true))
	else
		FileWrite ( li_f, '#connection not defined' )
		FileWrite ( li_f, '#Server           =' +sqlca.servername)
		FileWrite ( li_f, 'Database         =' +sqlca.database)
		FileWrite ( li_f, 'Charset          =' +sqlca.is_charset)
		FileWrite ( li_f, 'Login            =' +sqlca.logid)
		FileWrite ( li_f, '#Password         =' )
		FileWrite ( li_f, 'EncryptedPassword=' +f_crypt(sqlca.logpass,true))
	end if
	if pos(sqlca.dbparm,',Sec_Confidential=1')>0 then FileWrite ( li_f, 'Encrypt.Data     =true')
	if pos(sqlca.dbparm,",PWEncrypt='No'")<1     then FileWrite ( li_f, 'Encrypt.Password =true')
	
	FileWrite ( li_f, '')
	FileWrite ( li_f, '[open]')
	FileWrite ( li_f, 'dir ='+GetCurrentDirectory())
	
	for i=2 to Upperbound(tab_1.control)
		t=tab_1.control[i]
		if t.of_iseditor() then 
			e=t
			choose case e.il_pagetype
				case e.typeeditfile
					if ls_wspath=lower(left(e.powertiptext,len(ls_wspath))) then
						FileWrite ( li_f, 'file='+mid(e.powertiptext,len(ls_wspath)+1) )
					else
						FileWrite ( li_f, 'file='+e.powertiptext )
					end if
				case e.typeeditobject
					FileWrite ( li_f, 'obj ='+e.is_obj_database+'.'+e.is_obj_owner+'.'+e.is_obj_name )
			end choose
		end if
	next
	FileWrite ( li_f, '')
	FileWrite ( li_f, '[query]')
	e=tab_1.control[1]
	FileWrite ( li_f, e.of_gettext())
	FileClose(li_f)
	is_workspacepath=as_file
	is_workspacename=f_getfilepart(is_workspacepath,2)
	of_settitle()
else
	
end if

return false

end function

public function boolean of_openfile (readonly string as_filename, boolean ab_clone, long encoding);uo_tabpage t
uo_editpage ei
long i,count,ver
string ls_filename,ls_text
WIN32_FIND_DATA ffd

ls_filename=as_filename
i=GetFullPathName(as_filename,0,ls_filename,count)
if i>0 then
	ls_filename=space(i+1)
	GetFullPathName(as_filename,i+1,ls_filename,count)
	i=FindFirstFile(ls_filename,ffd)
	if i<>-1 then
		ls_filename=f_getFilePart(ls_filename,1)+ffd.cfilename
		FindClose(i)
	end if
end if


//may be file is already opened?
count=upperbound(tab_1.control)
for i=1 to count
	t=tab_1.control[i]
	if t.il_pagetype=t.typeeditfile and lower(t.powertiptext)=lower(ls_filename) then
		if not ab_clone then
			tab_1.selecttab( t )
			return true
		end if
		ei=t
		ver=ei.il_clone+1
	end if
next

//open the file in a separated page
uo_editpage e

tab_1.openTab(e,0)
ls_text=f_getfilepart(ls_filename,6)
if ver>0 then ls_text+=' :'+string(ver)
e.of_init(ls_text,e.typeEditFile,0,ls_filename)
if not e.of_open(ls_filename,encoding) then
	of_closeTab(e)
	return false
end if

tab_1.selectTab(e)
e.il_clone=ver
return true

end function

public subroutine of_log (long al_number, long al_severity, string as_procedure, long al_line, readonly string as_message);integer li_picture
string ls_label
string ls_errno

ls_label = string(now(),  "hh.mm.ss:fff")
if al_severity > 0 then
	li_picture = 2
	if al_severity < 11 then li_picture = 1
	if as_procedure = "" then as_procedure = "<SQL>"
	as_procedure = as_procedure + " (" + string(al_line) + ")"
	ls_errno = string(al_number)
else
	ls_errno = ""
end if

if isValid( this.irs_current ) and al_severity>=0 and sqlca.ib_executing then
	if this.irs_current.ib_multi_resultsets then
		this.irs_current.event ue_message(li_picture, ls_label, ls_errno, as_procedure, as_message )
		return
	end if
end if

//add into standard logger
lv_log.of_log(li_picture, MAX(al_severity, 0), {ls_label, ls_errno, as_procedure, as_message})

if li_picture = 2 then
	il_execerror ++
end if

if (not ib_showlog) and (li_picture >= il_logshowlevel) and (il_logshowlevel > -1) then
	post event ue_men_showlog()
end if

end subroutine

public subroutine of_log (readonly string as_msg);of_log(0,-1,'',0,as_msg)

end subroutine

public subroutine of_setcolor (string c);c=lower(c)
if c='' or c='default' then 
	this.icon=''
else
	this.icon='img\aseisql-'+c+'.ico'
end if

end subroutine

on w_main.create
if this.MenuName = "m_main" then this.MenuID = create m_main
this.mdi_1=create mdi_1
this.st_tip2=create st_tip2
this.lv_log=create lv_log
this.st_tip=create st_tip
this.tab_1=create tab_1
this.hpb_1=create hpb_1
this.st_split=create st_split
this.Control[]={this.mdi_1,&
this.st_tip2,&
this.lv_log,&
this.st_tip,&
this.tab_1,&
this.hpb_1,&
this.st_split}
end on

on w_main.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
destroy(this.st_tip2)
destroy(this.lv_log)
destroy(this.st_tip)
destroy(this.tab_1)
destroy(this.hpb_1)
destroy(this.st_split)
end on

event resize;long xpix,ypix
long xxx,yyy,www,hhh

if sizetype=1 then return 0

xxx=workspacex()
yyy=workspacey()
www=this.workspacewidth( )
hhh=this.workspaceheight( )

newwidth=xxx+www
newheight=yyy+hhh

xpix=PixelsToUnits(1,XPixelsToUnits!)
ypix=PixelsToUnits(1,YPixelsToUnits!)

hpb_1.move(xxx -xpix,yyy)
hpb_1.width=www+xpix*2

st_split.move(xxx,max(st_split.frombegin,newheight - lv_log.height - st_split.height - mdi_1.microhelpheight))
st_split.width=www

tab_1.move(xxx,yyy+ypix)
tab_1.resize(www+xpix,st_split.y - workspacey() )

lv_log.move(xxx,st_split.y+st_split.height)
lv_log.resize(www ,newheight - lv_log.y - mdi_1.microhelpheight)

tab_1.move(xxx,yyy+ypix)
if this.ib_showlog then
	tab_1.resize(www+xpix,st_split.y - yyy )
else
	tab_1.resize(www+xpix,lv_log.y+lv_log.height - yyy )
end if


if isValid(w_statusbar) then w_statusbar.event ue_frame_resize ( )

end event

event close;w_browser.hide()
this.hide()
cfg.of_savepos(this)
cfg.of_toolbar_save( this )
cfg.of_setLong(this.classname(),'log',lv_log.height)

this.event ue_men_disconnect()
SharedObjectUnRegister('sqlexec')
destroy in_sqlexec_trig
destroy in_locator
//destroy in_sqlexec
if isvalid(in_sqlmsg) then destroy in_sqlmsg

end event

event open;uo_editpage e

long tcm_first=4864
//set tabpages smaller
Send(handle(tab_1),tcm_first+43,0,196611)


SharedObjectRegister('n_sqlexec','sqlexec')
SharedObjectGet('sqlexec',in_sqlexec)
in_sqlexec_trig=create n_sqlexec
in_locator=create n_sqlexeclocator
in_sqlmsg=create n_sqlmessage
//in_sqlexec=create n_sqlexec


cfg.of_toolbar_restore( this )
EnableWindow(handle(mdi_1),false)

open(w_statusbar,this)
w_statusbar.f_addtext ( "filecp", 220, Center! )//a file encoding
w_statusbar.f_addtext ( "change", 50, Center! )//a flag of object/file change
w_statusbar.f_addtext ( "eol", 200, Center! )//end of line
w_statusbar.f_addtext ( "pos", 260, Left! )
w_statusbar.f_addtext ( "server", 400, Left! )
w_statusbar.f_addtext ( "charset", 200, Left! )
w_statusbar.f_addtext ( "login", 260, Left! )
w_statusbar.f_addtext_ex ( "database", 400, Left!, '' )

w_statusbar.f_setText ( "pos", "1:1" )

openWithParm(w_browser,'hide')

tab_1.OpenTab(e,0)
e.of_init('Query',e.typeEdit,0,'Ctrl+Q to activate')
tab_1.selecttab( e )


cfg.of_restorepos(this)
lv_log.height=cfg.of_getLong(this.classname(),'log',lv_log.height)

of_updateview()

string s
s=CommandParm ( )
if len(s)>0 then
	this.post of_parsecmd(s)
else
	this.postEvent('ue_men_connect')
end if

st_tip.of_settooltip( lv_log )
st_tip2.of_settooltip( w_statusbar.dw_status )

if cfg.of_getoption( 'log.hide') then
	this.event ue_men_showlog()
end if
il_logshowlevel=cfg.of_getlong( cfg.is_options,'log.show.level',2 )
ib_saveonexec=cfg.of_getoption( 'save.on.exec' )

//register this window for dropping files
DragAcceptFiles(handle(this),true)


end event

event closequery;m_main m
m=this.menuID
long i,count
uo_tabpage t
uo_editpage e
boolean b=false

if not m.m_file.m_exit.enabled then 
	SetMicroHelp("Can't exit while executing!")
	return 1
end if

tab_1.SelectTab(1)

count=Upperbound(tab_1.control)
//check if any editor was modified
for i=2 to count
	t=tab_1.control[i]
	if t.of_iseditor( ) then
		e=t
		if e.uo_edit.of_send( e.uo_edit.SCI_GETMODIFY , 0, 0)<>0 then
			b=true
			exit
		end if
	end if
next
//open save request if modified
if b then 
	open(w_save)
	if message.doubleparm=0 then return 1
end if
//close tabpages...
for i=count to 2 step -1
	if not of_closeTab(tab_1.control[i]) then
		of_updatemenustatus()
		return 1
	end if
next

return 0

end event

event timer;if ib_debugwait then
	//this if - just in case if timer events were posted
	of_dbg_wait()
end if

end event

event toolbarmoved;int ai_toolbars[]
long count,i
boolean lb_visible

this.event resize(0,0,0)

//do not allow to hide toolbars...
count=cfg.of_gettoolbars( this.menuid, ai_toolbars )
for i=1 to count
	this.GetToolbar ( ai_toolbars[i], lb_visible )
	if not lb_visible then
		this.post SetToolbar( ai_toolbars[i], true, alignAtTop! )
	end if
next

end event

type mdi_1 from mdiclient within w_main
long BackColor=268435456
end type

type st_tip2 from uo_tooltip within w_main
integer x = 896
integer y = 72
end type

event needtext;call super::needtext;string s,r

s=w_statusbar.dw_status.getObjectAtPointer()

s=left(s,pos(s,'~t')-1)

CHOOSE CASE s
	CASE 'filecp'
		return 'File codepage'
	CASE 'eol'
		return 'Default line endings.~r~nAffect during execution and file save.'
	CASE 'pos'
		return 'Cursor position'
	CASE 'server'
		return 'Server:~r~n'+sqlca.servername+'~r~n'+sqlca.is_server_version
	CASE 'charset'
		r='Current client charset'
		if sqlca.is_charset_var>'' then r+='~r~n'+sqlca.is_charset_var+' = '+sqlca.is_charset
		return r
	CASE 'login'
		return 'Current login'
	CASE 'database'
		return 'Current database.~r~nClick to select.'
	CASE 'change'
		return 'Edit change flag'
END CHOOSE
return ''


end event

event constructor;call super::constructor;this.of_setDelay(5000)

end event

type lv_log from uo_log within w_main
integer x = 82
integer y = 1652
integer width = 2359
integer taborder = 20
end type

event rightclicked;call super::rightclicked;
m_pop_log m

m=create m_pop_log

m.of_init(this)
m.popmenu(parent.pointerx(),parent.pointery())

destroy m

end event

event doubleclicked;call super::doubleclicked;////
long pos,p1,p2
long line
string ls_obj
uo_editpage e
uo_tabpage t

this.GetItem ( index, 3, ls_obj )
pos=pos(ls_obj,'(')
if pos>0 then
	line=long(mid(ls_obj,pos + 1, len(ls_obj)-pos -1 ))
	ls_obj=left(ls_obj,pos - 2)
end if

if ls_obj='<SQL>' then
	if isValid(iuo_lastexecpage) then
		tab_1.selectTab(iuo_lastexecpage)
		iuo_lastexecpage.uo_edit.setFocus()
		iuo_lastexecpage.of_selectline(line)
	end if
else
	if isValid(iuo_lastexecpage) then
		if iuo_lastexecpage.of_equals( ls_obj ) then
			tab_1.selectTab(iuo_lastexecpage)
			iuo_lastexecpage.uo_edit.setFocus()
			iuo_lastexecpage.of_selectline(line)
			return 0
		end if
	end if
	if sqlca.of_isconnected() and not sqlca.ib_executing then
		if gn_sqlmenu.of_getobjtype(ls_obj)>'' then
			if w_main.of_openobject(ls_obj,0,false) then
				if of_getcurrentedit(e) then
					e.of_selectline(line)
				end if
			end if
		end if
	end if
end if

end event

type st_tip from uo_tooltip within w_main
integer x = 1458
integer y = 72
integer width = 306
string text = "Tooltip log"
end type

event needtext;call super::needtext;string ls_tip,ls
long ll_severity
listViewItem lvi
long item,pos
icon ico

if Handle(lv_log)=handle then
	item=lv_log.of_getitematpointer()
	if item>0 then
		lv_log.getItem(item,lvi)
		ll_severity=long(lvi.data)
		CHOOSE CASE lvi.pictureindex
			CASE 1
				ico=information!
			CASE 2
				ico=StopSign!
			CASE ELSE
				ico=None!
		END CHOOSE
		this.of_settitle( ico, lvi.label)

		if ll_severity<>0 then
			ls_tip ='Server message:~n'
			lv_log.GetItem ( item, 2, ls )
			ls_tip+='number :~t'+ls+'~n'
			ls_tip+='severity :~t'+string(ll_severity)+'~n'
			lv_log.GetItem ( item, 3, ls )
			pos=pos(ls,'(')
			ls_tip+='object :~t~t'+left(ls,pos - 1)+'~n'
			ls_tip+='line :~t~t'+mid(ls,pos + 1, len(ls)-pos -1 )+'~n'
		end if
		lv_log.GetItem ( item, 4, ls )
		ls_tip+='message :~t'+ls
			
	end if
end if

return ls_tip

end event

event constructor;call super::constructor;this.of_setDelay(15000)

end event

type tab_1 from tab within w_main
integer y = 224
integer width = 2446
integer height = 1344
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long backcolor = 67108864
boolean raggedright = true
boolean powertips = true
integer selectedtab = 1
end type

event selectionchanged;uo_tabpage p
uo_editpage e


p=tab_1.control[of_gettabindex()]
p.of_setFocus()
if p.of_iseditor() then parent.of_showpos(p)

of_updatemenustatus()
of_settitle()
p.event ue_selected()

end event

event rightclicked;this.selectTab(index)
if index>1 then
	m_main m
	m=parent.menuid
	m.m_window.popmenu(parent.pointerx(),parent.pointery())
end if

end event

event doubleclicked;m_main m
m=parent.menuid
if m.m_window.m_close.enabled then m.m_window.m_close.event clicked( )


end event

type hpb_1 from hprogressbar within w_main
integer x = 197
integer y = 20
integer width = 1957
integer height = 8
unsignedinteger maxposition = 100
integer setstep = 10
end type

type st_split from uo_split_bar within w_main
integer y = 1600
integer width = 1723
integer height = 12
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string pointer = "SizeNS!"
long textcolor = 33554432
borderstyle borderstyle = styleraised!
boolean vertical = false
integer fromend = 400
end type

event ue_moved;call super::ue_moved;tab_1.height=st_split.y - tab_1.y +PixelsToUnits(1,YPixelsToUnits!)

lv_log.height+=lv_log.y - (st_split.y+st_split.height)
lv_log.move(0,st_split.y+st_split.height)
tab_1.setFocus()

end event

