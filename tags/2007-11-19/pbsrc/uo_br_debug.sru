HA$PBExportHeader$uo_br_debug.sru
forward
global type uo_br_debug from userobject
end type
type mle_help from multilineedit within uo_br_debug
end type
type mle_sql from multilineedit within uo_br_debug
end type
type st_tip from uo_tooltip within uo_br_debug
end type
type lv_stop from uo_lv within uo_br_debug
end type
type lv_where from uo_lv within uo_br_debug
end type
type uo_menu from uo_menubar within uo_br_debug
end type
type mle_dbg from multilineedit within uo_br_debug
end type
type lv_var from uo_lv within uo_br_debug
end type
type cb_go from commandbutton within uo_br_debug
end type
type dw_dbg from datawindow within uo_br_debug
end type
type thwnd2obj from structure within uo_br_debug
end type
end forward

global type uo_br_debug from userobject
integer width = 914
integer height = 1344
long backcolor = 67108864
long tabtextcolor = 33554432
string picturename = "Debug!"
long picturemaskcolor = 12632256
string powertiptext = "Debugger"
event resize pbm_size
event syskeydown pbm_syskeydown
event ue_changestatus ( )
event ue_init ( )
event ue_sybexec_message pbm_custom04
event ue_sybexec_newrow pbm_custom02
event ue_sybexec_resinfo pbm_custom07
event ue_sybexec_resultset pbm_custom01
event ue_sybexec_setfield pbm_custom03
event ue_sybexec_sqlerror pbm_custom06
mle_help mle_help
mle_sql mle_sql
st_tip st_tip
lv_stop lv_stop
lv_where lv_where
uo_menu uo_menu
mle_dbg mle_dbg
lv_var lv_var
cb_go cb_go
dw_dbg dw_dbg
end type
global uo_br_debug uo_br_debug

type prototypes

end prototypes

type variables
int ii_view /*1:var, 2:break, 3:sql, 4:dbg*/
long il_currentrow
long il_rstype
long il_rscurrentrow
long il_returnvalue

long il_stopcount
string is_where_obj
string is_where_parm
string is_where_parms[]
long il_where_line

long il_adhoc=0
//an array to store null flags for the variables
// [i] = true if null
boolean ib_nullflag[]


n_text_metrics in_metrics

end variables

forward prototypes
public function boolean of_dbg_control (readonly string cmd)
public subroutine of_dbg_variables ()
public subroutine of_dbg_update ()
public function boolean of_dbg_stop (string as_name, long al_line)
public subroutine of_dbg_stops ()
public function boolean of_dbg_continue ()
public function boolean of_dbg_where ()
public function boolean of_dbg_step (string cmd)
public function boolean of_parm_add (readonly string as_parm)
public function boolean of_parm_parse ()
public function boolean of_dbg_deletestop (string obj, long line)
end prototypes

event resize;//
lv_where.move(0,newheight - lv_where.height)
lv_where.width=newwidth

mle_dbg.move(0,uo_menu.height)
mle_dbg.resize(newwidth,newheight - uo_menu.height - lv_where.height )

mle_sql.move(0,uo_menu.height)
mle_sql.resize(newwidth,newheight - uo_menu.height - lv_where.height )

mle_help.move(0,uo_menu.height)
mle_help.resize(newwidth,newheight - uo_menu.height - lv_where.height )

lv_var.move(0,uo_menu.height)
lv_var.resize(newwidth,newheight - uo_menu.height - lv_where.height )

lv_stop.move(0,uo_menu.height)
lv_stop.resize(newwidth,newheight - uo_menu.height - lv_where.height )


end event

event ue_changestatus();//
boolean con
boolean exec
boolean dbg
boolean lexec

exec=sqlca.ib_executing
con=sqlca.of_isconnected( )
dbg=sqlca.il_dbg_spid>0
lexec=ii_view=3 or ii_view=4

//uo_menu.of_enable( 1, con and not exec and dbg)
//uo_menu.of_enable( 2, con and not exec and dbg)

//uo_menu.of_enable( 3, con and not exec and dbg)
//uo_menu.of_enable( 4, con and not exec and dbg)

uo_menu.of_enable( 99, con and not exec and dbg and lexec)
uo_menu.of_enable( 100, con and not exec and dbg)

//cb_go.setposition( ToBottom! )
cb_go.enabled=con and not exec and dbg and lexec
cb_go.visible=lexec

lv_var.enabled=con and not exec and dbg
lv_var.visible=ii_view=1

lv_stop.enabled=con and not exec and dbg
lv_stop.visible=ii_view=2

//mle_sql.enabled=con and not exec and dbg
mle_sql.visible=ii_view=3

//mle_dbg.enabled=con and not exec and dbg
mle_dbg.visible=ii_view=4

mle_help.visible=ii_view=5


end event

event ue_init();//activate variables
uo_menu.event btn_clicked( 1 )
uo_menu.of_hide( 4, not cfg.ib_debug_expert )
//set tooltip for the variables
st_tip.of_settooltip(lv_var)
st_tip.of_settooltip(lv_where)

end event

event ue_sybexec_message;//this is only for debug messages from syb_exec.dll
//if lparam=0 then return

//string s
//gn_unicode.of_mblong2string( sqlca.of_utf8( ) , lparam, s)
//w_main.in_sqlexec_trig.dbgrpc_control(sqlca.dbHandle(),sqlca.il_dbg_spid,cmd,handle(this),loc)
//w_main.of_log(0,-1,'debugger:dbg',0,s)

end event

event ue_sybexec_newrow;//
il_rscurrentrow=wparam

CHOOSE CASE il_rstype
	CASE 0//,2	//RS, PROC OUT
		il_currentrow++
		dw_dbg.insertRow(il_currentrow)
	CASE 1	//PROC RET
END CHOOSE

end event

event ue_sybexec_resinfo;//
if lparam=0 then return

string s
if wparam=2 then
	gn_unicode.of_mblong2string( sqlca.of_utf8( ) , lparam, s)
	il_returnvalue=long(s)
end if

end event

event ue_sybexec_resultset;//
//nothing to do here?
//just remember result set type?

il_rscurrentrow=0
il_rstype=wparam


end event

event ue_sybexec_setfield;string s

if lparam=0 then
	setNull(s)
else
	gn_unicode.of_mblong2string(sqlca.of_utf8(), lparam,s)
	//w_main.in_sqlmsg.of_l2s(lparam,s)
end if

if this.il_rscurrentrow=0 then
	//it's a column info. doing nothing
else
	CHOOSE CASE il_rstype
		CASE 0//,2	//RS, PROC OUT
			dw_dbg.setItem(il_currentrow,wparam,s)
		CASE 1	//PROC RET
			//il_returnvalue=long(s)
			//moved to info
	END CHOOSE
end if

end event

event ue_sybexec_sqlerror;return w_main.event ue_sybexec_sqlerror(wparam,lparam)

end event

public function boolean of_dbg_control (readonly string cmd);
n_sqlexeclocator loc

dw_dbg.reset()
il_currentrow=0
il_returnvalue=-99
if cfg.ib_debug_log then w_main.of_log(0,-1,'debugger',0,cmd)
w_main.in_sqlexec_trig.dbgrpc_control(sqlca.dbHandle(),sqlca.il_dbg_spid,cmd,handle(this),loc)
if cfg.ib_debug_log then w_main.of_log(0,-1,'debugger',0,'return '+string(il_returnvalue))

//if sqlca.of_dbg_error(il_returnvalue) then return false

return true

end function

public subroutine of_dbg_variables ();long i,ll_count,ll_type,ii,ll_last
string ls_name,s
listviewitem lvi
of_dbg_control('show variables')

ll_count=dw_dbg.rowcount( )
lv_var.setredraw( false )
ll_last=lv_var.of_getlastvisible()
lv_var.deleteitems()
of_parm_parse()
for i=1 to ll_count
	ll_type=long(dw_dbg.getItemString(i,3))
	ls_name=trim(dw_dbg.getitemstring(i,1))
	choose case ll_type
		case 50 //bit
			ii=lv_var.AddItem ( ls_name, 9 )
			s='?'+dw_dbg.getitemstring(i,2) 
		case 48,52,56 //tinyint , smallint, int
			ii=lv_var.AddItem ( ls_name, 1 )
			if long(dw_dbg.getitemstring(i,2)) = 0 then 
				setnull(s)
			else
				s=dw_dbg.getitemstring(i,4)
			end if
		 case 58 // smalldatetime 
			ii=lv_var.AddItem ( ls_name, 4 )
			s=dw_dbg.getitemstring(i,5) 
		 case 61 // datetime 
			ii=lv_var.AddItem ( ls_name, 4 )
			s=dw_dbg.getitemstring(i,6) 
		 case 59 // real
			ii=lv_var.AddItem ( ls_name, 2 )
			s=dw_dbg.getitemstring(i,7)
		 case 62 // float 
			ii=lv_var.AddItem ( ls_name, 2 )
			s=dw_dbg.getitemstring(i,8)
		 case 60 // money 
			ii=lv_var.AddItem ( ls_name, 5 )
			s=dw_dbg.getitemstring(i,10)
		 case 122 // smallmoney 
			ii=lv_var.AddItem ( ls_name, 5 )
			s=dw_dbg.getitemstring(i,9)
		 case 63,55 // numeric 
			ii=lv_var.AddItem ( ls_name, 2 )
			s=dw_dbg.getitemstring(i,11)
		 case 39 // varchar 
			ii=lv_var.AddItem ( ls_name, 3 )
			s=dw_dbg.getitemstring(i,13)
		 case 47 // char 
			ii=lv_var.AddItem ( ls_name, 3 )
			s=dw_dbg.getitemstring(i,13)
		 case 45 // binary 
			ii=lv_var.AddItem ( ls_name, 6 )
			s=dw_dbg.getitemstring(i,13)
		 case 37 // varbinary 
			ii=lv_var.AddItem ( ls_name, 6 )
			s=dw_dbg.getitemstring(i,13)
		 case else // unknown
			ii=lv_var.AddItem ( ls_name, 7 )
			s='?'
	end choose
	ib_nullflag[ii]=isnull(s)
	lv_var.SetItem ( ii, 2 , s )
next
lv_var.of_autosize(1,lv_var.totalitems()=0)
lv_var.of_ensurevisible( ll_last )
lv_var.setredraw( true )

end subroutine

public subroutine of_dbg_update ();of_dbg_where()
of_dbg_stops()
of_dbg_variables()

uo_editpage e

if w_main.of_getcurrentedit(e) then
	e.of_dbg_updatestops( )
end if

end subroutine

public function boolean of_dbg_stop (string as_name, long al_line);string cmd

cmd='stop in '+as_name
if al_line>1 then cmd+=' at '+string(al_line)

of_dbg_control(cmd)

choose case true
	case il_returnvalue=0
		//is ok?
		of_dbg_stops()
	case il_returnvalue>0
		w_main.of_log(0,-1,'debugger',0,'Breakpoint moved to line '+string(il_returnvalue))
		of_dbg_stops()
	case else
		sqlca.of_dbg_error( il_returnvalue )
		return false
end choose

return true

end function

public subroutine of_dbg_stops ();long ii,i,ll_count,ll_line,ll_tok
string s,sa[]

of_dbg_control('show breakpoints')

lv_stop.deleteitems()
ll_count=dw_dbg.rowcount( )

//SHIT! we have to parse line number from string
il_stopcount=0
for i=1 to ll_count
	//example of string: stop in opale2000.dbo.msg at 15
	//example of string: stop in opale2000.dbo.msg    (no line specification)
	s=trim(dw_dbg.getitemstring(i,13))
	ll_tok=f_gettokens(s,' ',sa)
	
	if ll_tok=3 then
		if lower(sa[1])='stop' and lower(sa[2])='in' then
			ii=lv_stop.AddItem ( sa[3], 1 )
			lv_stop.SetItem ( ii, 2 , '1' )
			il_stopcount++
			continue
		end if
	end if
	
	if ll_tok=5 then
		if lower(sa[1])='stop' and lower(sa[2])='in' and lower(sa[4])='at' then
			ii=lv_stop.AddItem ( sa[3], 1 )
			lv_stop.SetItem ( ii, 2 , string(long(sa[5])) )
			il_stopcount++
			continue
		end if
	end if
	lv_stop.AddItem ( s, 2 )
next

end subroutine

public function boolean of_dbg_continue ();of_dbg_control('continue')

choose case true
	case il_returnvalue>=0
		//is ok?
		w_main.of_log(0,-1,'debugger',0,'continue status '+string(il_returnvalue))
	case else
		sqlca.of_dbg_error( il_returnvalue )
		return false
end choose

return true

end function

public function boolean of_dbg_where ();long i,ll_count,ll_type,ii
string s

of_dbg_control('show where')

lv_where.deleteitems()
is_where_obj=''
il_where_line=0

if il_returnvalue<0 then
	sqlca.of_dbg_error( il_returnvalue )
	return false
end if

ll_count=dw_dbg.rowcount( )
for i=1 to ll_count
	s=trim(dw_dbg.getitemstring(i,1))
	if upper(s)='ADHOC' then
		//ii=lv_where.AddItem ( s, 2 )
		s=dw_dbg.getitemstring(i,2)
		il_adhoc=long(s)
		//lv_where.SetItem ( ii, 2 , s )
	else
		if is_where_obj='' then
			is_where_obj=s
			ii=lv_where.AddItem ( is_where_obj, 1 )
			il_where_line=long(dw_dbg.getitemstring(i,2))
			lv_where.SetItem ( ii, 2 , string(il_where_line) )
			//remember parameters here, to show them later
			is_where_parm=dw_dbg.getitemstring(i,13)
		else
			ii=lv_where.AddItem ( s, 2 )
			lv_where.SetItem ( ii, 2 , dw_dbg.getitemstring(i,2) )
		end if
		//remember parameters here, to show them later
		is_where_parms[ii]=dw_dbg.getitemstring(i,13)
	end if
next
return true

end function

public function boolean of_dbg_step (string cmd);if trim(cmd)>'' then cmd=' '+trim(cmd)
of_dbg_control('step'+cmd)

if il_returnvalue>=0 and dw_dbg.rowcount( )=1 then
	if trim(dw_dbg.getItemString(1,1))='ADHOC' and dw_dbg.getItemString(1,2)='1' then
		//to remove hanging when go out of last line that could be debugged 
		of_dbg_control('continue')
	elseif dw_dbg.getItemString(1,2)='0' then
		//to remove strange behavior when we press step and go to firts line on IF statement
		of_dbg_control('step')
	end if
end if

choose case true
	case il_returnvalue>=0
		//is ok?
	case else
		sqlca.of_dbg_error( il_returnvalue )
		return false
end choose

return true

end function

public function boolean of_parm_add (readonly string as_parm);string parm,value
long pos,ii

pos=pos(as_parm,' = ')
value=mid(as_parm,pos+3)
parm=left(as_parm,pos - 1)
//unquote strings
ii=len(value)
if left(value,1)='"' and mid(value,ii )='"' then value=mid(value,2,ii -2)
ii=lv_var.AddItem ( parm, 8 )
lv_var.SetItem ( ii, 2 , value )

return true

end function

public function boolean of_parm_parse ();//
string parm,val,ls
long pos0=0

//is_where_parm

do while len(is_where_parm)>0
	pos0=pos(is_where_parm,',',pos0+1)
	if pos0>0 then
		//found next parm?
		ls=trim(mid(is_where_parm,pos0+1))
		if match( ls,'^@[a-zA-Z_]+ = ' ) then
			//cut left param
			of_parm_add( left(is_where_parm,pos0 - 1) )
			is_where_parm=ls
			pos0=0
		end if
	else
		//last loop
		of_parm_add( is_where_parm )
		is_where_parm=''
	end if
loop

return true

end function

public function boolean of_dbg_deletestop (string obj, long line);long i
string s1,s2
uo_editpage e

if obj='' then
	//delete all stops
	of_dbg_control('delete -1')
	if il_returnvalue<0 then 
		sqlca.of_dbg_error(il_returnvalue)
		return false
	end if
	of_dbg_stops()
	return true
else
	for i=1 to lv_stop.totalitems()
		lv_stop.getItem(i,1,s1)
		lv_stop.getItem(i,2,s2)
		if obj=s1 and line=long(s2) then
			of_dbg_control('delete '+string(i))
			if il_returnvalue<0 then 
				sqlca.of_dbg_error(il_returnvalue)
				return false
			end if
			of_dbg_stops()
			return true
		end if
	next
end if
of_dbg_stops()
return false

end function

on uo_br_debug.create
this.mle_help=create mle_help
this.mle_sql=create mle_sql
this.st_tip=create st_tip
this.lv_stop=create lv_stop
this.lv_where=create lv_where
this.uo_menu=create uo_menu
this.mle_dbg=create mle_dbg
this.lv_var=create lv_var
this.cb_go=create cb_go
this.dw_dbg=create dw_dbg
this.Control[]={this.mle_help,&
this.mle_sql,&
this.st_tip,&
this.lv_stop,&
this.lv_where,&
this.uo_menu,&
this.mle_dbg,&
this.lv_var,&
this.cb_go,&
this.dw_dbg}
end on

on uo_br_debug.destroy
destroy(this.mle_help)
destroy(this.mle_sql)
destroy(this.st_tip)
destroy(this.lv_stop)
destroy(this.lv_where)
destroy(this.uo_menu)
destroy(this.mle_dbg)
destroy(this.lv_var)
destroy(this.cb_go)
destroy(this.dw_dbg)
end on

event constructor;in_metrics=create n_text_metrics
in_metrics.of_setfont( 'Microsoft Sans Serif', 8, false, false)

end event

event destructor;destroy in_metrics

end event

type mle_help from multilineedit within uo_br_debug
integer x = 91
integer y = 812
integer width = 215
integer height = 108
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 134217751
long backcolor = 134217752
string text = "help"
boolean vscrollbar = true
boolean autovscroll = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
boolean hideselection = false
end type

event constructor;string cr='~r~n'
this.text='Sybase SQL internal debugger.'+cr+cr
this.text+='Use only in high priority case.'+cr
this.text+='Don~'t use on production! (that~'s sybase said)'+cr+cr
this.text+='Sybase (12.5.0) internal debugger is not perfect.'
this.text+=' But it allows to set breakpoint in a stored procedure or trigger for the remote process,'
this.text+=' to see the stacktrace, and successfully execute commands "step", "show where", "show variables" .'+cr

this.text+=cr+'Known bugs in sybase debugger 12.5.0:'+cr
this.text+='- breakpoint "at line#" is not working.'+cr
this.text+="- sybase don't count lines ended with ~"null~" keyword."+cr
this.text+='- delete breakpoint not working after second call. but you can still delete all breakpoints.'+cr
this.text+='- set @variable not working correctly. it seems, that it always sets value for the first variable in the list.'+cr
this.text+='- procedure parameters are coming through one coma-separated string (I have to parse it and it could raise some problems)'+cr
this.text+='- values for the bit variables are not displayed.'+cr
this.text+='- sometimes debugger can get disconnected by server but breakpoints still exists on the remote process and you can~'t kill it while breakpoints are active. in this case just reconnect, select a remote process and click Debug - Detach.'+cr

this.text+=cr+'If you are calling the stored procedure using remote server alias, then debugger will never stop in this stored procedure because sybase creating a new connection for the remote procedure call, even it~'s a local server.'+cr

this.text+=cr+'How to use:'+cr
this.text+='1. go into "Command - View Processes"'+cr
this.text+='2. click on process you want to debug'+cr
this.text+='3. select menu "Debug - Attach"'+cr
this.text+='4. open procedure/trigger you want to debug'+cr
this.text+='5. select menu "Debug - Set Breakpoint"'+cr
this.text+='6. select menu "Debug - Continue" to activate debugger waiting cycle.'+cr
this.text+='7. as soon as breakpoint is reached by the remote process, you can use "Debug - Step" commands.'+cr
this.text+='8. note: better to reach breakpoint by the remote process, and only then click "Debug - Continue" (to avoid disconnection from server).'+cr

this.text+=cr+'How waiting cycle is working:'+cr
this.text+=+'Sybase debugger is passive. To know if remote process reached the breakpoint, I~'m sending "show where" command to server once a second. As soon as I receive good responce, I stop the timer. Everything seems to be ok, but sometimes server disconnects the debugger just after this command.'+cr

end event

type mle_sql from multilineedit within uo_br_debug
integer x = 32
integer y = 936
integer width = 663
integer height = 144
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
boolean vscrollbar = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
boolean hideselection = false
end type

type st_tip from uo_tooltip within uo_br_debug
integer x = 379
integer y = 820
end type

event needtext;call super::needtext;string ls_tip,ls
long item

if Handle(lv_var)=handle then
	item=lv_var.of_getitematpointer()
	if item>0 then
		lv_var.getItem(item,2,ls_tip)
		if upperbound(ib_nullflag[])>=item then
			if ib_nullflag[item] then ls_tip='<NULL>'
		end if
	end if
elseif Handle(lv_where)=handle then
	item=lv_where.of_getitematpointer()
	if item>0 then
		if upperbound(is_where_parms[])>=item then
			ls_tip=is_where_parms[item]
		end if
	end if
end if

return ls_tip

end event

type lv_stop from uo_lv within uo_br_debug
integer x = 5
integer y = 676
integer width = 667
integer height = 132
integer taborder = 60
long largepicturemaskcolor = 12632256
string smallpicturename[] = {"img\break.bmp","Help!"}
long smallpicturemaskcolor = 12632256
end type

event constructor;//

AddColumn ( 'object', Left!, 550 )
AddColumn ( 'line', Right!, 150 )

end event

event key;if (key=KeyC! or key=KeyInsert!) and KeyDown(KeyControl!) then
	//copy item name
	long h
	string s1,s2
	h=this.SelectedIndex()
	if h>0 then
		this.getItem(h,1,s1)
		this.getItem(h,2,s2)
		clipboard(s1+' ('+s2+')')
	end if
end if

end event

event ue_resize;call super::ue_resize;int ww=4

if TotalColumns()<>2 then return

ww+=of_getcolwidth(2)

post of_SetColWidth( 1, max(10,newwidth - ww) )

end event

type lv_where from uo_lv within uo_br_debug
integer y = 424
integer width = 677
integer height = 256
integer taborder = 50
string smallpicturename[] = {"img\cbreak.bmp","img\cbreakup.bmp","help!"}
long smallpicturemaskcolor = 12632256
end type

event constructor;//

AddColumn ( 'where', Left!, 550 )
AddColumn ( 'line', Right!, 150 )

end event

event key;if (key=KeyC! or key=KeyInsert!) and KeyDown(KeyControl!) then
	//copy item name
	long h
	string s,s1,s2,s3
	
	for h=1 to totalitems()
		this.getItem(h,1,s1)
		this.getItem(h,2,s2)
		s3=''
		if upperbound(is_where_parms)>=h then
			s3=is_where_parms[h]
			if isnull(s3) then s3=''
		end if
		s+=s1+'~t'+s2+'~t'+s3+'~r~n'
	next
	clipboard(s)
end if

end event

event ue_resize;call super::ue_resize;int ww=4

if TotalColumns()<>2 then return

ww+=of_getcolwidth(2)

post of_SetColWidth( 1, max(10,newwidth - ww) )

end event

type uo_menu from uo_menubar within uo_br_debug
integer width = 891
integer height = 104
integer taborder = 20
end type

event constructor;call super::constructor;long ww, hh 
this.of_setvertical( false )
this.of_setobscure( true )
//this.of_setstaticedge( true )

this.of_init( )

this.of_addbutton( 100, 'Continue!', '', 'Update Views')
this.of_addbutton( 0, '', '', '')
this.of_addbutton( 1, 'ShowVariables!', '', 'Variables')
this.of_addbutton( 2, 'OutputStop!', '', 'Breakpoints')
this.of_addbutton( 3, 'SQL!', '', 'Remote SQL')
this.of_addbutton( 4, 'Custom076!', '', 'Debug command')
this.of_addbutton( 0, '', '', '')
this.of_addbutton( 99, 'ExecuteSQL!', '', 'Execute (Alt+G)')
this.of_addbutton( 0, '', '', '')
this.of_addbutton( 5, 'Help!', '', 'Debugger Help')

this.of_apply( )

this.of_getsize( ww, hh )
this.height=hh+12

end event

on uo_menu.destroy
call uo_menubar::destroy
end on

event btn_clicked;call super::btn_clicked;if id<99 and id>0 then
	if ii_view=id then return
	if ii_view>0 then uo_menu.of_check( ii_view, false)
	ii_view=id
	uo_menu.of_check( ii_view, true)
	parent.event ue_changestatus( )
	//set focus if
	choose case ii_view
		case 1
			lv_var.setfocus()
		case 2
			lv_stop.setfocus()
		case 3
			mle_sql.setfocus()
		case 4
			mle_dbg.setfocus()
		case 5
			mle_help.setfocus()
	end choose
end if
if id=99 then cb_go.event clicked()
if id=100 then of_dbg_update()


end event

type mle_dbg from multilineedit within uo_br_debug
integer x = 5
integer y = 140
integer width = 663
integer height = 144
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
boolean vscrollbar = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
boolean hideselection = false
end type

event constructor;string cr='~r~n'
this.text+='!!! FOR ADVANCED USERS ONLY !!!'+cr+cr
this.text+='debug commands that I found through sybase sqldbgr tool. you can select a command to and press Alt+G to execute it.'+cr+cr

this.text+='stop in <procname>'+cr+'Stop in beginning of a procedure'+cr+cr
this.text+='stop in <procname> at <line#>'+cr+'Stop at a valid line number in the procedure. Automatically moves the breakpoint to the next valid line.'+cr+cr
this.text+='step'+cr+'Step to the next statement.'+cr+cr
this.text+='step into'+cr+'Step into the procedure or trigger if it is an update/delete/insert statement and if there is a trigger.'+cr+cr
this.text+='step out'+cr+'Step out of the procedure or trigger.'+cr+cr
this.text+='show variables'+cr+'Show all the variables declared in the current nesting level of the procedure.'+cr+cr
this.text+='show variables at <nesting level #>'+cr+'Show all the variables declared in the given nesting level. Level # starts from 0.'+cr+cr
this.text+='show @varname'+cr+'Show variable @varname in the current nesting level of the procedure.'+cr+cr
this.text+='show @varname at <nesting level #>'+cr+'Show the variable @varname in the given nesting level.'+cr+cr
this.text+='show breakpoints'+cr+'Show the breakpoints.'+cr+cr
this.text+='show where'+cr+'Show the procedure calling sequence (parameters included).'+cr+cr
this.text+='sql <sql stmt>'+cr+'Run the sql statement inside the debugger. Useful for getting temp table info of the debugged task. Can~'t access local variables.'+cr+cr
this.text+='continue'+cr+'Continue the execution of procedure.'+cr+cr
this.text+='set @varname = <value>'+cr+'Set a value of a variable.'+cr+cr
this.text+='enable <breakpoint #> or enable -1'+cr+'Enable a breakpoint or enable all breakpoints by passing -1.'+cr+cr
this.text+='disable <breakpoint #> or disable -1'+cr+'Disable a breakpoint or disable all breakpoints by passing -1.'+cr+cr
this.text+='delete <breakpoint #> or delete -1'+cr+'Delete a breakpoint or delete all breakpoints by passing -1.'+cr+cr
this.text+='break'+cr+'just found in code but no description.'+cr+cr

end event

type lv_var from uo_lv within uo_br_debug
integer y = 292
integer width = 677
integer height = 136
integer taborder = 30
boolean bringtotop = true
boolean gridlines = true
string smallpicturename[] = {"PasteInstance!","img\varN.bmp","img\varS.bmp","img\varD.bmp","FormatDollar!","img\binary.bmp","UserObject!","PasteArgument!","img\varBit.bmp"}
long smallpicturemaskcolor = 12632256
end type

event constructor;AddColumn ( 'name', Left!, 400 )
AddColumn ( 'value', Left!, 400 )

end event

event key;if (key=KeyC! or key=KeyInsert!) and KeyDown(KeyControl!) then
	//copy item name
	long h
	string s1,s2
	h=this.SelectedIndex()
	if h>0 then
		this.getItem(h,1,s1)
		this.getItem(h,2,s2)
		clipboard(s1+' = '+s2)
	end if
end if

end event

event doubleclicked;call super::doubleclicked;string s,var
n_hashtable h
h=create n_hashtable

if index<1 or sqlca.ib_executing then return

getItem(index,1,var)
h.of_set('title',' - edit variable '+var)

if ib_nullflag[index] then
	setnull(s)
else
	getItem(index,2,s)
end if
h.of_set('value',s)

openWithParm(w_data_edit,h)
if h.of_get('ok',false) then
	s=h.of_get('value','null')
	if isNull(s) then s='null'
	if of_dbg_control('set '+var+' = '+s) then
		if il_returnvalue<0 then 
			sqlca.of_dbg_error( il_returnvalue )
		else
			if of_dbg_where() then of_dbg_variables()
		end if
	end if
end if

destroy h

end event

event ue_resize;call super::ue_resize;int ww=4
long i,count

if TotalColumns()<>2 then return

count=totalitems()
this.of_autosize(1,count=0)

ww+=of_getcolwidth(1)

post of_SetColWidth( 2, max(10,newwidth - ww) )

end event

type cb_go from commandbutton within uo_br_debug
integer x = 667
integer y = 164
integer width = 105
integer height = 92
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "&go"
end type

event clicked;string s

if ii_view=3 then
	s='sql '
	if mle_sql.SelectedLength ( )>0 then
		s+=mle_sql.SelectedText ( )
	else
		s+=mle_sql.text
	end if
else
	if mle_dbg.SelectedLength ( )>0 then
		s=mle_dbg.SelectedText ( )
	else
		s=mle_dbg.text
	end if
end if

w_main.of_dbg_control(s)

end event

type dw_dbg from datawindow within uo_br_debug
boolean visible = false
integer x = 23
integer y = 1132
integer width = 686
integer height = 192
boolean bringtotop = true
string title = "none"
string dataobject = "d_debug"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event buttonclicked;clipboard(describe('datawindow.data'))

end event

