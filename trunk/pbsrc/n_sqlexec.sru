HA$PBExportHeader$n_sqlexec.sru
forward
global type n_sqlexec from nonvisualobject
end type
end forward

global type n_sqlexec from nonvisualobject
end type
global n_sqlexec n_sqlexec

type prototypes
private function long sql_execute(long DBHandle,ref blob sql, long hwnd) LIBRARY "syb_exec.dll" alias for "sql_execute"
function long LoadLibrary(string s)library 'kernel32' alias for "LoadLibraryW"
function boolean FreeLibrary(long hLibModule)library 'kernel32'

function long sql_dbgrpc_control(long con,int spid, string parm,long hwnd) library "syb_exec.dll" alias for "sql_dbgrpc_control;Ansi"

private function long sql_cancel_all(long DBHandle) LIBRARY "syb_exec.dll" alias for "sql_cancel_all"

end prototypes
type variables
long sql_hinst
string terminator='go'
long terminator_len=2
string space=' ~t~r~n'
n_unicode in_unicode
n_sqlparser in_sqlparser
long il_query_id=0

end variables

forward prototypes
public subroutine of_dummy ()
public subroutine dbgrpc_control (long dbhandle, readonly long spid, readonly string parm, long locator, readonly n_sqlexeclocator an_locator)
private function blob of_s2b (readonly string s, boolean utf8)
public subroutine of_go (long dbhandle, boolean utf8, readonly string fullquery[], long locator, readonly n_sqlexeclocator an_locator)
public function string of_exec2str (readonly n_tr tr, readonly string as_query, readonly string as_cdelim, readonly string as_rdelim)
public function long of_cancel_all (readonly transaction tr)
end prototypes

public subroutine of_dummy ();return

end subroutine

public subroutine dbgrpc_control (long dbhandle, readonly long spid, readonly string parm, long locator, readonly n_sqlexeclocator an_locator);if isvalid(an_locator) then an_locator.event ue_sqlexec_preview(0,"debug: "+parm,cpu())
sql_dbgrpc_control(DBHandle,spid,parm, locator )

if isvalid(an_locator) then an_locator.event ue_sqlexec_end()

end subroutine

private function blob of_s2b (readonly string s, boolean utf8);//converts string to multibyte according to the current charset of editor (ansi or utf8)
long len
blob b

len=in_unicode.of_string2mb(utf8,s,b)

return b

end function

public subroutine of_go (long dbhandle, boolean utf8, readonly string fullquery[], long locator, readonly n_sqlexeclocator an_locator);string fullquerry_lower
string cprev,cnext,cch
long pos=1,pos0=1,flen
string query
long fullpos=0
long i
long ll_qry,ll_qrycount
blob bquery

il_query_id++
ll_qrycount=upperbound(fullquery)
for ll_qry=1 to ll_qrycount
	pos=1
	pos0=1
	flen=len(fullquery[ll_qry])
	
	do
		pos=in_sqlparser.of_findkeyword( fullquery[ll_qry], terminator, pos0)
		if pos>0 then
			query=mid(fullquery[ll_qry],pos0,pos - pos0)
			pos0 = pos+len(terminator)
		else
			query=mid(fullquery[ll_qry],pos0)
		end if
		if len(f_trim(query,space))>0 then
			an_locator.event ue_sqlexec_preview(pos0,fullquery[ll_qry],il_query_id)
			bquery=of_s2b(query,utf8)
			sql_execute(DBHandle,bquery, locator )
		end if
		//remove unnecessary spaces after go
		do while pos(' ~t', mid(fullquery[ll_qry],pos0,1))>0
			pos0++
		loop
		//remove unnecessary ~r~n after go
		if mid(fullquery[ll_qry],pos0,1)='~r' then pos0++
		if mid(fullquery[ll_qry],pos0,1)='~n' then pos0++
	loop while pos>0 and not an_locator.event ue_sqlexec_wantstop()
		
	if an_locator.event ue_sqlexec_wantstop() then exit
next

an_locator.event ue_sqlexec_end()

end subroutine

public function string of_exec2str (readonly n_tr tr, readonly string as_query, readonly string as_cdelim, readonly string as_rdelim);//executes commands divided by go and puts evetrything into a string 

long pos=1,pos0=1,flen
string query
long i
string ls_ret
boolean lb_error


pos=1
pos0=1
flen=len(as_query)

do 
	pos=in_sqlparser.of_findkeyword( as_query, terminator, pos0)
	
	if pos>0 then
		query=mid(as_query,pos0,pos - pos0)
		pos0 = pos+len(terminator)
	else
		query=mid(as_query,pos0)
	end if
	
	if len(f_trim(query,space))>0 then
		//here we are executing.....
		DECLARE TreeViewRetrieveC DYNAMIC CURSOR FOR SQLSA;
		PREPARE SQLSA FROM :query using tr;
		DESCRIBE SQLSA INTO SQLDA;
		OPEN DYNAMIC TreeViewRetrieveC USING DESCRIPTOR SQLDA;
		FETCH TreeViewRetrieveC USING DESCRIPTOR SQLDA;
		fetching:
		DO WHILE tr.sqlcode=0
			if SQLDA.NumOutputs<1 then continue
			for i=1 to SQLDA.NumOutputs
				CHOOSE CASE SQLDA.OutParmType[i]
					CASE TypeDate!
						ls_ret+=string(SQLDA.GetDynamicDate(i))
					CASE TypeDateTime!
						ls_ret+=string(SQLDA.GetDynamicDateTime(i))
					CASE TypeDecimal!,TypeDouble!,TypeReal!,TypeUInt!,TypeULong!,TypeBoolean!
						ls_ret+=string(SQLDA.GetDynamicNumber(i))
					CASE TypeLong!
						ls_ret+=string(long(SQLDA.GetDynamicNumber(i)))
					CASE TypeInteger!
						ls_ret+=string(integer(SQLDA.GetDynamicNumber(i)))
					CASE TypeString!
						ls_ret+=SQLDA.GetDynamicString(i)
					CASE TypeTime!
						ls_ret+=string(SQLDA.GetDynamicTime(i))
				END CHOOSE
				if i=SQLDA.NumOutputs then
					ls_ret+=as_rdelim
				else
					ls_ret+=as_cdelim
				end if
			next
			FETCH TreeViewRetrieveC USING DESCRIPTOR SQLDA;
		loop
		lb_error=tr.sqlcode=-1
		if tr.sqlcode=100 then
			FETCH TreeViewRetrieveC USING DESCRIPTOR SQLDA;
			if tr.sqlcode=0 then goto fetching
		end if
		CLOSE TreeViewRetrieveC;
	end if
	if lb_error then exit
	//remove unnecessary spaces after go
	do while pos(' ~t', mid(as_query,pos0,1))>0
		pos0++
	loop
	//remove unnecessary ~r~n after go
	if mid(as_query,pos0,1)='~r' then pos0++
	if mid(as_query,pos0,1)='~n' then pos0++
loop while pos>0
	

return ls_ret

end function

public function long of_cancel_all (readonly transaction tr);return sql_cancel_all( tr.dbHandle() )

end function

on n_sqlexec.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_sqlexec.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;sql_hinst=LoadLibrary('syb_exec.dll')
in_unicode=create n_unicode
in_sqlparser=create n_sqlparser

end event

event destructor;FreeLibrary(sql_hinst)
destroy in_unicode
destroy in_sqlparser

end event

