HA$PBExportHeader$n_sqlmenu.sru
forward
global type n_sqlmenu from nonvisualobject
end type
type ids_col from datastore within n_sqlmenu
end type
type ids_trig from datastore within n_sqlmenu
end type
type ids_sch from datastore within n_sqlmenu
end type
end forward

global type n_sqlmenu from nonvisualobject
event ue_copy ( )
event ue_paste ( )
event ue_view ( )
event ue_procopen ( )
event ue_procexeccopy ( )
event ue_typeinfo ( )
event ue_viewdata ( )
event ue_tableddl ( )
event ue_refby ( )
event ue_search ( )
event ue_trigger ( )
event ue_copycolumn ( )
event ue_copycolumnall ( )
event ue_exectext ( )
event ue_procreopen ( )
event ue_trigger_open ( )
event ue_view_open ( )
event ue_copytemplate ( )
event ue_stubsmenu ( )
event ue_procexec ( )
event ue_stubsmenu2 ( )
event ue_open_sfunction ( )
ids_col ids_col
ids_trig ids_trig
ids_sch ids_sch
end type
global n_sqlmenu n_sqlmenu

type prototypes
private function boolean GetUserName(ref string str,ref long buflen)library 'advapi32.dll' alias for 'GetUserNameW'
private function long GetEnvironmentVariableW(String lpName,	ref String  lpBuffer, long nSize)library 'kernel32'
//FMLOGISTIC
end prototypes

type variables
public privatewrite int typeDatabase=1
public privatewrite int typeUserTable=4
public privatewrite int typeSystemTable=11
public privatewrite int typeProcedure=5
public privatewrite int typeTrigger=13
public privatewrite int typeSFunction=14
public privatewrite int typeView=6
public privatewrite int typeUserType=7
public privatewrite int typeStubs=9
public privatewrite int typeUnknown=12
public privatewrite int typeProcess=100


private string  is_name
private integer ii_type
private string  is_data


//private datastore ids_sch

//variables filled bu of_macro function. position of selection
public privatewrite long il_macro_selb
public privatewrite long il_macro_sele
public privatewrite string is_keywords

end variables

forward prototypes
public function boolean of_generatemenu (readonly menu m, readonly string as_name, readonly string as_type, readonly string as_data, boolean ab_generic)
public subroutine of_freemenu (readonly menu m)
public function string of_objtext (readonly string name)
public function boolean of_generatemenu (readonly menu m, string as_name)
public function boolean of_parsename (readonly string as_fullname, ref string as_database, ref string as_owner, ref string as_name)
public function string of_proctext (readonly string procname)
public function integer of_stype2int (readonly string s)
public function boolean of_generatemenu (readonly menu m, readonly string as_name, readonly integer ai_type, readonly string as_data, boolean ab_generic)
public function string of_macro (readonly string s, boolean ab_prompt)
public function boolean of_addstubsmenu (readonly menu m, readonly integer ai_type)
public function boolean of_stubfortype (readonly string s, integer ai_type)
public function string of_macro (readonly string s, boolean prompt, readonly string indent)
public function string of_macro (readonly string s, string as_parms, readonly string as_indent)
public function string of_getobjtype (readonly string as_name)
public function int of_getobjtypei (readonly string as_name)
public function boolean of_generatedbmenu (readonly menu m)
private function m_dynamic of_additem (readonly menu m, readonly string as_text, readonly string as_event, boolean ab_enabled)
public function string of_getobjectfooter (readonly string as_name)
public function string of_getmenustub (readonly string as_menuname, readonly string as_param, readonly string as_value)
public function boolean of_addstubsmenu (readonly menu m, readonly integer ai_type, readonly string as_parm, readonly string as_value)
public function string of_typename (integer al_type)
public function string of_getobjectheader (readonly long al_type, readonly string as_database, readonly string as_owner, readonly string as_name)
end prototypes

event ue_copy();if ii_type=typeStubs then
	Clipboard(of_macro(is_data,true))
else
	Clipboard(is_name)
end if

end event

event ue_paste();if ii_type=typeStubs then
	w_main.of_pastetext(of_macro(is_data,true))
else
	w_main.of_pastetext(' '+is_name+' ')
end if

end event

event ue_view();if isValid(w_view_data) then
else
	open(w_view_data,w_main)
	//parentWindow.setFocus()
end if
w_view_data.of_set(of_macro(is_data,false))

end event

event ue_procopen();w_main.of_openobject(is_name,typeProcedure,false)

end event

event ue_procexeccopy();string text1,text2,text3
string value
long count,i

n_procparmparser ln_ppp

ln_ppp=create n_procparmparser

count=ln_ppp.of_getparameters( is_name )

for i=1 to count
	text1+='declare '+ln_ppp.of_getparmname(i)+' '+ln_ppp.of_getparmtype( i )+'~r~n'
	value=ln_ppp.of_getparmvalue( i )
	if value='' then value='NULL'
	text2+='select '+ln_ppp.of_getparmname(i)+' = '+value+'~r~n'
	text3+=', '+ln_ppp.of_getparmname(i)
	if ln_ppp.of_getparmout( i ) then text3+=' out'
next
if text2<>'' then text1+='~r~n'+text2+'~r~n'
text1+='execute '+is_name+mid(text3,2)+'~r~n'

destroy ln_ppp

//w_main.of_pastetext(text1)
clipboard(text1)

end event

event ue_typeinfo();string s
uo_editpage e

s ='select a.name, ~r~n'
s+='	(select name from systypes b where b.usertype=(select min(c.usertype) from systypes c where c.hierarchy=a.hierarchy)) base_type, ~r~n'
s+='	a.length, ~r~n'
s+='	a.prec,~r~n'
s+='	a.scale,~r~n'
s+='	a.ident,~r~n'
s+='	a.allownulls~r~n'
s+='from systypes a~r~n'
s+='where a.name="'+is_name+'"'


w_main.of_execute(e,s,true)

end event

event ue_viewdata();uo_editpage e
w_main.of_execute(e,"select * from "+is_name,true)

end event

event ue_tableddl();uo_editpage e

open(w_browser,"hide")

w_browser.tab_1.page_st.visible=false

w_main.of_execute(e,'query',true)

end event

event ue_refby();uo_editpage e
string s
s="select oref.name from sysreferences r,sysobjects oref &
 where r.reftabid=object_id('"+is_name+"') &
 and oref.id=r.tableid "

w_main.of_execute(e,s,true)

end event

event ue_search();open(w_browser)
w_browser.visible=true
w_browser.post of_search(is_name)

end event

event ue_trigger();string ls_trig
long pos
ls_trig=String(Message.LongParm, "address")
pos=pos(ls_trig,'~t')
if pos>0 then ls_trig=left(ls_trig,pos - 1)
w_main.of_openobject(ls_trig,typeTrigger,false)

end event

event ue_copycolumn();string ls_name
ls_name=String(Message.LongParm, "address")

clipboard(' '+ls_name+' ')

end event

event ue_copycolumnall();long i,count
string ls=' '

count=ids_col.RowCount()
for i=1 to count
	ls+=ids_col.GetItemString(i,1)
	if i<count then ls+=',~r~n'
next

clipboard(ls+' ')

end event

event ue_exectext();string ls_text
uo_editpage e

ls_text=String(Message.LongParm, "address")
w_main.of_execute(e,ls_text,true)

end event

event ue_procreopen();w_main.of_openobject(is_name,typeProcedure,true)

end event

event ue_trigger_open();w_main.of_openobject(is_name,typeTrigger,false)

end event

event ue_view_open();w_main.of_openobject(is_name,typeView,false)

end event

event ue_copytemplate();string ls_name,ls_col,ls_parm,ls_set,ls_del
long i,count

count=ids_col.rowcount()
for i=1 to count
	ls_col+=ids_col.GetItemString(i,1)
	ls_parm+='@'+ids_col.GetItemString(i,1)
	ls_set+='~t'+ids_col.GetItemString(i,1)+' = @'+ids_col.GetItemString(i,1)
	ls_del+='~t'+ids_col.GetItemString(i,1)+' = @'+ids_col.GetItemString(i,1)
	if i<count then
		ls_col+=', '
		ls_parm+=', '
		ls_set+=',~r~n'
		ls_del+=' and~r~n'
	end if
next
choose case lower(String(Message.LongParm, "address"))
	case 'select'
		clipboard('select '+ls_col+'~r~n~tfrom '+is_name)
	case 'insert'
		clipboard('insert into '+is_name+' ( '+ls_col+' )~r~n~tvalues ( '+ls_parm+' )')
	case 'update'
		clipboard('update '+is_name+' set~r~n'+ls_set)
	case 'delete'
		clipboard('delete from '+is_name+' where~r~n'+ls_del)
end choose

end event

event ue_stubsmenu();string s,o
treeviewitem tvi
uo_editpage e

if w_browser.tab_1.page_st.tv_1.getitem(message.wordparm,tvi)=1 then
	s=of_macro(mid(tvi.data,pos(tvi.data,'~n')+1),'Object name~t'+is_name,'')
	w_main.of_execute(e,s,true)
end if


end event

event ue_procexec();string text1,text2,text3
string value
long count,i

n_procparmparser ln_ppp

ln_ppp=create n_procparmparser

count=ln_ppp.of_getparameters( is_name )

for i=1 to count
	text1+='declare '+ln_ppp.of_getparmname(i)+' '+ln_ppp.of_getparmtype( i )+'~r~n'
	value=ln_ppp.of_getparmvalue( i )
	if value='' then value='NULL'
	text2+='select '+ln_ppp.of_getparmname(i)+' = '+value+'~r~n'
	text3+=', '+ln_ppp.of_getparmname(i)
	if ln_ppp.of_getparmout( i ) then text3+=' out'
next
if text2<>'' then text1+='~r~n'+text2+'~r~n'
text1+='execute '+is_name+mid(text3,2)+'~r~n'

destroy ln_ppp

n_hashtable h
h=create n_hashtable
h.of_set( 'title', ' - execute procedure '+is_name)
h.of_set( 'text', text1)
openWithParm(w_procexec,h)
if h.of_get( 'ok', false) then
	uo_editpage e
	w_main.of_execute(e,h.of_get( 'text', text1),true)
end if


destroy h
//w_main.of_pastetext(text1)
clipboard(text1)

end event

event ue_stubsmenu2();string s
treeviewitem tvi
uo_editpage e
long pos

if w_browser.tab_1.page_st.tv_1.getitem(message.wordparm,tvi)=1 then
	s=f_trim(of_macro(mid(tvi.data,pos(tvi.data,'~n')+1),string(message.longparm,'address') ,''),'~r~n')
	if left(s,10)='--CONFIRM:' then
		pos=pos(s,'~n')
		if pos<1 then return
		if MessageBox(app().displayname,mid(s,11,pos -10),Question!,YesNo!)=2 then return
		s=mid(s,pos+1)
	end if
	w_main.of_execute(e,s,true)
end if

end event

event ue_open_sfunction();w_main.of_openobject(is_name,typeSFunction,false)

end event

public function boolean of_generatemenu (readonly menu m, readonly string as_name, readonly string as_type, readonly string as_data, boolean ab_generic);return of_generatemenu(m,as_name, of_stype2int(as_type), as_data, ab_generic)

end function

public subroutine of_freemenu (readonly menu m);long i,count
menu mi

count=upperbound(m.item)
for i=count to 1 step -1
	mi=m.item[i]
	destroy mi
next

end subroutine

public function string of_objtext (readonly string name);string query
string stext,ptext=''
long slen

//select text = B.text from opale2000.dbo.sysobjects A, opale2000.dbo.syscomments B 
//where A.id = 1213348456 and A.id = B.id and number = 1 order by B.colid2, B.colid

//with ORDER BY colid2,colid' it's not working!!!

//ok. in some old versions of ASE char_length not working if "order by" is present in query
//to correct this let's play with trimspaces transaction parameter
//normally, without "space trim" char_length not needed... have to be checked

//remove default PB behavior that trims spaces
sqlca.of_trimspaces( false )

query='SELECT text,char_length(text) FROM syscomments WHERE id=object_id("'+name+'") order by colid2, colid'

DECLARE proc_text DYNAMIC CURSOR FOR SQLSA;
PREPARE SQLSA FROM :query;
OPEN DYNAMIC proc_text;
if not sqlca.of_Error() then 
	FETCH proc_text INTO :stext,:slen;
	if sqlca.sqlcode=100 then
		f_error("Can't find object ~r~n"+name)
	elseif sqlca.sqlcode=0 then
		do while sqlca.sqlcode=0
			//stext += space(slen - len(stext)) //without trimming we don't need this anymore
			ptext += stext
			FETCH proc_text INTO :stext,:slen;
		loop
		ptext=trim(ptext)
	else
		sqlca.of_Error()
	end if
	close proc_text;
end if	
//return default PB behavior that trims spaces
sqlca.of_trimspaces( true )
return ptext

end function

public function boolean of_generatemenu (readonly menu m, string as_name);string ls_type
if isNull(as_name) then return false
if not sqlca.of_isconnected() then return false


as_name=f_trim(as_name,' ~t~r~n')
if len(as_name)=0 then return false
//if we still have strange symbols - return false
if not match(as_name,'^[a-zA-Z_]+[.a-zA-Z0-9_]*$') then
//if pos(as_name,'~r')>0 or pos(as_name,'~t')>0 or pos(as_name,'~n')>0 or pos(as_name,' ')>0 then
	return false
end if

ls_type=of_getobjtype(as_name)
if ls_type>'' then
	return of_generatemenu(m,as_name,ls_type,'',false)
else
	as_name=left(as_name,30)
	is_name=as_name
	of_additem(m,'Search object...',"ue_search",true)
	return true
end if

return false

end function

public function boolean of_parsename (readonly string as_fullname, ref string as_database, ref string as_owner, ref string as_name);//make this parse as in object_id() function

string s[]
long count

count=gf_parsestring(as_fullname,'.',s,false)
if count<1 then return false

as_name=s[count]

if count>1 then
	as_owner=s[count -1]
else
	as_owner='dbo'
end if

if count>2 then
	as_database=s[count -2]
else
	as_database=sqlca.database
end if
return true

end function

public function string of_proctext (readonly string procname);//string ptext
//
//ptext=of_objtext(procname)
//ptext="use "+sqlca.database+&
//"~r~ngo~r~n~r~n&
//If Exists(Select 1~r~n&
//		From sysobjects~r~n&
//		Where id=object_id('"+procname+"')~r~n&
//		And type='P')~r~n&
//	Drop Procedure "+procname+"~r~n&
//go~r~n"+ptext
//
//ptext+="~r~n&
//go~r~n&
//grant exec on "+procname+" to public~r~n&
//go~r~n"
//
//return ptext
//
return of_objtext(procname)

end function

public function integer of_stype2int (readonly string s);CHOOSE CASE s
	CASE "U"
		return typeUserTable
	CASE "S"
		return typeSystemTable
	CASE "P"
		return typeProcedure
	CASE "TR"
		return typeTrigger
	CASE "SF"
		return typeSFunction
	CASE "V"
		return typeView
	CASE "TYPE"
		return typeUserType
	CASE "STUBS"
		return typeStubs
	CASE "PROCESS"
		return typeProcess
END CHOOSE
return typeUnknown

end function

public function boolean of_generatemenu (readonly menu m, readonly string as_name, readonly integer ai_type, readonly string as_data, boolean ab_generic);is_name=as_name
ii_type=ai_type
is_data=as_data
long i,count
string ls


CHOOSE CASE ai_type
	CASE typeProcedure, typeStubs, typeSystemTable, typeUserTable, typeUserType, typeView,typeTrigger,typeSFunction
	CASE typeDatabase
		return of_generatedbmenu(m)
	CASE ELSE
		return false
END CHOOSE

if ab_generic then
	CHOOSE CASE ai_type
		CASE typeProcedure, typeStubs, typeSystemTable, typeUserTable, typeUserType, typeView,typeTrigger,typeSFunction
			of_additem(m,"Copy","ue_copy",true)
			of_additem(m,"Paste","ue_paste",w_main.of_iseditoractive())
	END CHOOSE
	
	CHOOSE CASE ai_type
		CASE typeStubs
			of_additem(m,"View","ue_view",true)
	END CHOOSE
	
	if sqlca.dbHandle()=0 then return true
	if sqlca.ib_executing then return true
	
	CHOOSE CASE ai_type
		CASE typeProcedure, /*typeSystemTable, typeUserTable,*/ typeUserType, typeView, typeTrigger,typeSFunction
			of_additem(m,"-","",true)
	END CHOOSE
end if

if sqlca.dbHandle()=0 then return false
if sqlca.ib_executing then return false
	

CHOOSE CASE ai_type
	CASE typeTrigger
		of_additem(m,"Open Trigger","ue_trigger_open",true)
END CHOOSE

CHOOSE CASE ai_type
	CASE typeView
		of_additem(m,"Open View","ue_view_open",true)
END CHOOSE

CHOOSE CASE ai_type
	CASE typeSFunction
		of_additem(m,"Open Function","ue_open_sfunction",true)
END CHOOSE

CHOOSE CASE ai_type
	CASE typeProcedure
		of_additem(m,"Open Procedure","ue_procopen",true)
		of_additem(m,"Open Procedure (Copy)","ue_procreopen",true)
		of_additem(m,"Copy Proc Exec","ue_procexeccopy",true)
//		of_additem(m,"Proc Exec","ue_procexec",true)
//		of_additem(m,"-","",true)
//		of_additem(m,"sp_depends "+as_name,"ue_exectext",true)
END CHOOSE

of_addstubsmenu(m,ai_type)

CHOOSE CASE ai_type
	CASE typeSystemTable, typeUserTable
//		of_additem(m,"Table DDL","ue_tableddl",true)
//		of_additem(m,"Referenced By","ue_refby",true)
//		of_additem(m,"-","",true)
//		of_additem(m,"sp_depends "+as_name,"ue_exectext",true)
		ids_trig.setTransObject(sqlca)
		if ai_type=typeSystemTable then
			count=ids_trig.retrieve('S',is_name)
		else
			count=ids_trig.retrieve('U',is_name)
		end if
		if count>0 then
			if ids_trig.getitemnumber( 1, 'havetrig')=1 then
				of_additem(m,"-","",false)
				ls=ids_trig.getItemString(1,'instrig')
				if not isNull(ls) then of_additem(m,ls+'~tInsTrig',"ue_trigger",true)
				ls=ids_trig.getItemString(1,'deltrig')
				if not isNull(ls) then of_additem(m,ls+'~tDelTrig',"ue_trigger",true)
				ls=ids_trig.getItemString(1,'updtrig')
				if not isNull(ls) then of_additem(m,ls+'~tUpdTrig',"ue_trigger",true)
			end if
		end if
END CHOOSE


CHOOSE CASE ai_type
	CASE typeSystemTable, typeUserTable, typeProcedure, typeView
		ids_col.setTransObject(sqlca)
		count=ids_col.retrieve(as_name)
		if count>0 then
			menu mCol
			of_additem(m,"-","",false)
			mCol=of_additem(m,"Copy column","",true)
			of_additem(mCol,"All columns","ue_copycolumnall",true)
			of_additem(mCol,"-","",false)
			for i=1 to count
				of_additem(mCol,ids_col.GetItemString(i,1),"ue_copycolumn",true)
			next
			if ai_type=typeSystemTable or ai_type=typeUserTable or ai_type=typeView then
				mCol=of_additem(m,"Copy template","",true)
				of_additem(mCol,"Select","ue_copytemplate",true)
				of_additem(mCol,"Insert","ue_copytemplate",true)
				of_additem(mCol,"Update","ue_copytemplate",true)
				of_additem(mCol,"Delete","ue_copytemplate",true)
			end if
			
		end if
END CHOOSE



return true

end function

public function string of_macro (readonly string s, boolean ab_prompt);if ab_prompt then return of_macro(s,'prompt','')
return of_macro(s,'','')

end function

public function boolean of_addstubsmenu (readonly menu m, readonly integer ai_type);return of_addstubsmenu(m, ai_type, 'Object name',is_name)

end function

public function boolean of_stubfortype (readonly string s, integer ai_type);long pos0=6,pos,i
string c,stype
int itype
boolean ret=false

if not match(left(s,5),'^--E[XOC]:$') then return false

for i=6 to 1000
	c=mid(s,i,1)
	choose case c
		case '~r','~n',','
			stype=trim(mid(s,pos0,i - pos0 ))
			itype=of_stype2int(stype)
			if itype=this.typeunknown then return false
			if itype=ai_type then ret=true
			if c<>',' then return ret
			pos0=i+1
	end choose
next
return false

end function

public function string of_macro (readonly string s, boolean prompt, readonly string indent);string ls,parm
if prompt then parm='prompt'
return of_macro(s,parm,indent)

end function

public function string of_macro (readonly string s, string as_parms, readonly string as_indent);string res
string value
long pos0,pos,mlen
long vlen
datastore parm
long row//,count
boolean found
string ls_parms[]
long ll_parmcount
boolean lb_prompt

lb_prompt=(as_parms='prompt')

parm=create datastore
parm.dataobject='d_params'
pos0=1
pos=pos(s,'%')
do while pos>0
	CHOOSE CASE true
		CASE mid(s,pos, 8)='%SERVER%'
			mlen=8
			value=sqlca.servername
		CASE mid(s,pos,10)='%DATABASE%'
			mlen=10
			value=sqlca.database
		CASE mid(s,pos, 9)='%DATE006%'
			mlen=9
			value=string(today(),'dd mmm yy')
		CASE mid(s,pos,10)='%USERNAME%'
			mlen=10
			vlen=255
			value=space(vlen)
			GetUserName(value,vlen)
//		CASE mid(s,pos,12)='%SYSCOLUMNS:'
//			mlen=pos(s,'%',pos+12)-pos
//			value=mid(s, pos+12, mlen -12 -1)
//			if sqlca.of_columnexists( left(value, pos(value,'?')-1) ) then
		CASE ELSE
			if mid(s,pos,6)='%PARM:' then 
				vlen=pos(s,'%',pos+6)
				value=mid(s,pos+6,vlen - pos - 6 )
				found=false
				for row=1 to parm.rowcount()
					if parm.getItemString(row,'name')=value then 
						found=true
						exit
					end if
				next
				if not found then
					row=parm.insertRow(0)
					parm.setItem(row,'name',value)
					parm.setItem(row,'value','')
				end if
				pos=vlen
			end if
			pos=pos(s,'%',pos+1)
			continue
	END CHOOSE
	res+=mid(s,pos0,pos - pos0)
	res+=value
	pos0=pos+mlen
	pos=pos(s,'%',pos0)
loop

res+=mid(s,pos0)

if parm.rowcount()>0 then
	if lb_prompt then
		parm.sort()
		openWithParm(w_params,parm,w_main)
		if message.doubleparm=1 then
			for row=1 to parm.rowcount()
				value=parm.getItemString(row,'value')
				res=f_replaceall(res,'%PARM:'+parm.getItemString(row,'name')+'%',value)
			next
		else
			return ''
		end if
	elseif len(as_parms)>0 then
		//parse as_parms and substitute
		parm.importstring(as_parms)
		parm.sort()
		//delete duplicates
		for row=parm.rowcount() to 2 step -1 
			if parm.getItemString(row,'name')=parm.getItemString(row - 1,'name') then 
				parm.deleterow(row - 1 )
			end if
		next
		//replace
		for row=1 to parm.rowcount()
			value=parm.getItemString(row,'value')
			res=f_replaceall(res,'%PARM:'+parm.getItemString(row,'name')+'%',value)
		next
	end if
end if


destroy parm

if as_indent<>'' then res=f_replaceall(res,'~r~n','~r~n'+as_indent)

il_macro_selb=0
il_macro_sele=0

il_macro_selb=pos(res,'%SELB%')
if il_macro_selb>0 then res=f_replaceall(res,'%SELB%','')

il_macro_sele=pos(res,'%SELE%')
if il_macro_sele>0 then res=f_replaceall(res,'%SELE%','')

if il_macro_selb>0 and il_macro_sele=0 then il_macro_sele=il_macro_selb
if il_macro_sele>0 and il_macro_selb=0 then il_macro_selb=il_macro_sele

if il_macro_selb>0 then il_macro_selb --
if il_macro_sele>0 then il_macro_sele --

return res

end function

public function string of_getobjtype (readonly string as_name);string ls_type


ids_sch.settransobject( sqlca )

if ids_sch.retrieve(as_name)=1 then
	ls_type=ids_sch.getItemString(1,"type")
	//as_name=ids_sch.getItemString(1,"name")
end if
return ls_type




end function

public function int of_getobjtypei (readonly string as_name);return of_stype2int(of_getobjtype(as_name))
end function

public function boolean of_generatedbmenu (readonly menu m);string ls_name
m_dynamic lm


if sqlca.dbHandle()=0 then return false
if sqlca.ib_executing then return false

DECLARE ddlb_cursor DYNAMIC CURSOR FOR SQLSA;
PREPARE SQLSA FROM 'select name from master..sysdatabases';
OPEN DYNAMIC ddlb_cursor;
if sqlca.sqlcode=-1 then return false

FETCH ddlb_cursor INTO :ls_name;
do while sqlca.sqlcode=0
	lm=of_additem(m,ls_name,'ue_select_database',true)
	if ls_name=sqlca.database then lm.checked=true
	lm.of_init(w_main,'ue_select_database',0,ls_name) //reinit menu item to send a message to w_main
	FETCH ddlb_cursor INTO :ls_name;
loop
CLOSE ddlb_cursor;

return upperbound(m.item)>0

end function

private function m_dynamic of_additem (readonly menu m, readonly string as_text, readonly string as_event, boolean ab_enabled);m_dynamic mi
int count

count=upperbound(m.item)
if as_text='-' and count=0 then return mi
if as_text='-' and count>0 then
	if m.item[count].text='-' then return m.item[count]
end if

mi=create m_dynamic
mi.text=as_text
mi.enabled=ab_enabled
mi.of_init(this,as_event,0,as_text)
m.item[upperbound(m.item)+1]=mi
return mi

end function

public function string of_getobjectfooter (readonly string as_name);long h
treeviewitem tvi
uo_dynamic_tv tv
string s


//openWithParm(w_browser,'hide')
tv=w_browser.tab_1.page_st.tv_1
h=tv.of_findChildByName(tv.FindItem(rootTreeItem!,0),'Menu',tvi)
if h=-1 then return ''

h=tv.of_findChildByName(h,'Object rights',tvi)
if h=-1 then return ''

s=of_macro(tvi.data,'Object name~t'+as_name,'')
s=w_main.in_sqlexec_trig.of_exec2str(sqlca,s,'','')
s=s
return s

end function

public function string of_getmenustub (readonly string as_menuname, readonly string as_param, readonly string as_value);uo_dynamic_tv tv
treeviewitem tvi
uo_editpage e
string s
long h



tv=w_browser.tab_1.page_st.tv_1
h=tv.of_findChildByName(tv.FindItem(rootTreeItem!,0),'Menu',tvi)
if h=-1 then 
	f_error('"Menu" item not found in stubs!')
	return ''
end if

h=tv.of_findChildByName(h,as_menuname,tvi)
if h=-1 then 
	f_error('"Menu\'+as_menuname+'" item not found in stubs!')
	return ''
end if

s=of_macro(tvi.data,as_param+'~t'+as_value,'')

return s


end function

public function boolean of_addstubsmenu (readonly menu m, readonly integer ai_type, readonly string as_parm, readonly string as_value);long h
boolean lb_added=false
uo_dynamic_tv tv
treeviewitem tvi
m_dynamic mi
string ls_type


//openWithParm(w_browser,'hide')
tv=w_browser.tab_1.page_st.tv_1
h=tv.of_findChildByName(tv.FindItem(rootTreeItem!,0),'Menu',tvi)

if h<>-1 then
	h=tv.findItem(ChildTreeItem!,h)
	do while h<>-1
		tv.getItem(h,tvi)
		if tvi.pictureindex=typestubs and of_stubfortype(tvi.data,ai_type) then
			if not lb_added then of_additem(m,"-","",true)
			lb_added=true
			mi=of_additem(m,tvi.label,"ue_stubsmenu2",true)
			mi.of_init( this, "ue_stubsmenu2", h, as_parm+'~t'+as_value)
		end if
		h=tv.findItem(NextTreeItem!,h)
	loop
end if

return true

end function

public function string of_typename (integer al_type);string item

CHOOSE CASE al_type
	CASE typeUserTable,typeSystemTable
		item='Table'
	CASE typeProcedure
		item='Procedure'
	CASE typeTrigger
		item='Trigger'
	CASE typeView
		item='View'
	CASE typeSFunction
		item='Function'
END CHOOSE

return item

end function

public function string of_getobjectheader (readonly long al_type, readonly string as_database, readonly string as_owner, readonly string as_name);long h
treeviewitem tvi
uo_dynamic_tv tv
string s


//openWithParm(w_browser,'hide')
tv=w_browser.tab_1.page_st.tv_1
h=tv.of_findChildByName(tv.FindItem(rootTreeItem!,0),'Menu',tvi)
if h=-1 then return ''

h=tv.of_findChildByName(h,of_typename(al_type)+' header',tvi)
if h=-1 then return ''

s=of_macro(tvi.data,'Object name~t'+as_owner+'.'+as_name+'~r~nDatabase~t'+as_database,'')
return s

end function

on n_sqlmenu.create
call super::create
this.ids_col=create ids_col
this.ids_trig=create ids_trig
this.ids_sch=create ids_sch
TriggerEvent( this, "constructor" )
end on

on n_sqlmenu.destroy
TriggerEvent( this, "destructor" )
call super::destroy
destroy(this.ids_col)
destroy(this.ids_trig)
destroy(this.ids_sch)
end on

event constructor;/*
is_keywords ='SELECT FROM WHERE GROUP BY DEFAULT HAVING ORDER DELETE UPDATE SET NOT EXISTS AND OR IS NULL INSERT INTO VALUES UNION'
is_keywords+=' GO BEGIN END USE AS IF CASE WHEN ELSE THEN GOTO IN BETWEEN LIKE'
is_keywords+=' PRINT'
is_keywords+=' DECLARE INT INTEGER TINYINT UNICHAR UNIVARCHAR TO_UNICHAR CHAR VARCHAR DATETIME NUMERIC BINARY VARBINARY SMALLINT MONEY'
is_keywords+=' CREATE ALTER DROP DATABASE TABLE PROCEDURE PROC INDEX TRIGGER VIEW'
is_keywords+=' GRANT ON TO REVOKE FROM'
is_keywords+=' CONNECT DISCONNECT SHUTDOWN RECONFIGURE'
is_keywords+=' ROLLBACK COMMIT TRAN RETURN DUMP LOAD TRANSACTION WITH'
is_keywords+=' OUT OUTPUT WHILE CONTINUE EXEC EXECUTE CLOSE DEALLOCATE CURSOR FETCH FOR READ ONLY OPEN'
is_keywords+=' CONVERT SUM AVG MIN MAX COUNT DISTINCT STATISTICS'
is_keywords+=' DATEADD DATEDIFF DATENAME DATEPART GETDATE'
is_keywords+=' ABS ACOS ASIN ATAN ATN2 CEILING COS COT DEGREES EXP FLOOR LOG LOG10 PI POWER RADIANS RAND ROUND SIGN SIN SQRT TAN'
is_keywords+=' ASCII CHARINDEX CHAR_LENGTH DIFFERENCE LOWER LTRIM PATINDEX REPLICATE REVERSE RIGHT RTRIM SOUNDEX SPACE STR STUFF SUBSTRING UPPER'
is_keywords+=' COL_LENGTH COL_NAME CURUNRESERVEDPGS DATA_PGS DATALENGTH DB_ID DB_NAME HOST_ID HOST_NAME INDEX_COL ISNULL LCT_ADMIN MUT_EXCL_ROLES OBJECT_ID OBJECT_NAME PROC_ROLE PTN_DATA_PGS RESERVED_PGS ROLE_CONTAIN ROLE_ID ROLE_NAME ROWCNT SHOW_ROLE SUSER_ID SUSER_NAME TSEQUAL USED_PGS USER USER_ID USER_NAME VALID_NAME VALID_USER'
is_keywords+=' OFF ON CHECKPOINT NOCOUNT'
is_keywords+=' ADD CONSTRAINT PRIMARY FOREIGN KEY REFERENCES CLUSTERED'
is_keywords+=' TRUE FALSE BREAK INNER LEFT RIGHT JOIN'
is_keywords+=' HOLDLOCK RAISERROR CURRENT OF'
is_keywords+=' UNIQUE NONCLUSTERED LOCK DATAPAGES'
is_keywords+=' BROWSE ALL'
is_keywords+=' TRUNCATE IDENTITY'
is_keywords+=' INDEX_COLORDER ONLINE REORG REBUILD DBCC'
*/
int f
f=FileOpen(cfg.is_initpath+'keywords',TextMode!,Read!,LockReadWrite!)
FileReadEx ( f, is_keywords )
FileClose(f)

end event

type ids_col from datastore within n_sqlmenu descriptor "pb_nvo" = "true" 
string dataobject = "d_columns"
end type

on ids_col.create
call super::create
TriggerEvent( this, "constructor" )
end on

on ids_col.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

type ids_trig from datastore within n_sqlmenu descriptor "pb_nvo" = "true" 
string dataobject = "d_triggers"
end type

on ids_trig.create
call super::create
TriggerEvent( this, "constructor" )
end on

on ids_trig.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

type ids_sch from datastore within n_sqlmenu descriptor "pb_nvo" = "true" 
string dataobject = "d_search_exact"
end type

on ids_sch.create
call super::create
TriggerEvent( this, "constructor" )
end on

on ids_sch.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event dberror;f_error(sqlerrtext)

end event

