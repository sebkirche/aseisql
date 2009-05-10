HA$PBExportHeader$uo_resultset.sru
forward
global type uo_resultset from uo_tabpage
end type
type mle_1 from uo_mle within uo_resultset
end type
end forward

shared variables
boolean ib_rsnumberuse[]

end variables

global type uo_resultset from uo_tabpage
integer width = 1143
integer height = 952
event resize pbm_size
event ue_setfield ( long al_col,  readonly string as_value )
event ue_newrow ( )
event ue_message ( integer ai_level,  readonly string as_time,  readonly string as_number,  readonly string as_object,  readonly string as_message )
event ue_resultset_end ( )
event ue_resultset_begin ( )
event ue_row_end ( )
mle_1 mle_1
end type
global uo_resultset uo_resultset

type prototypes

end prototypes

type variables
privatewrite long number=0  //the resultset page number //used with ib_rsnumberuse[] to display title
long il_query_id //the id of the query

boolean ib_displayonly //disable any editing, menu, etc
protectedwrite boolean ib_multi_resultsets //true if this resultset page supports multiple resultsets
string is_nullvalue

//--------------------
//   new variables
//--------------------
protected DragObject iwo_result //object that represents the resultset/ must be initialized on constructor


//information used for data retrival
protectedwrite n_resultset_info in_rsinfo[] //the information about resultsets
protectedwrite long il_rscount

end variables

forward prototypes
public subroutine of_setsql (readonly string s)
public subroutine of_print ()
public subroutine of_setfocus ()
public subroutine of_showsql (boolean show)
public subroutine of_updateview ()
private subroutine of_generatenumber ()
public function boolean of_save (boolean ab_prompt)
public subroutine of_storecfg ()
public function boolean of_find (readonly string find_text, boolean find_case, boolean find_wword, boolean find_wstart, boolean find_back)
public subroutine of_sybexec_newrow (long al_row)
public subroutine of_sybexec_setfield (readonly long al_col, readonly string as_value)
public subroutine of_sybexec_resultset (readonly long al_rstype, readonly long al_colcount)
public subroutine of_sybexec_tabname (readonly string as_tablename)
public subroutine of_sybexec_setfieldinfo (readonly long al_col, readonly string as_value)
end prototypes

event resize;//
mle_1.width=newwidth
iwo_result.resize(newwidth,newheight - iwo_result.y)

end event

event ue_setfield(long al_col, readonly string as_value);//here the value must be displayed

end event

event ue_newrow();//newrow notification
end event

event ue_message(integer ai_level, readonly string as_time, readonly string as_number, readonly string as_object, readonly string as_message);//
//should be managed by the page with multi resultsets
//if ib_multi_resultsets=false the page will not receive this message

end event

event ue_resultset_end();//
//sent by w_main?

end event

event ue_resultset_begin();//sent locally

end event

event ue_row_end;//

end event

public subroutine of_setsql (readonly string s);mle_1.text=s

end subroutine

public subroutine of_print ();//print the result

end subroutine

public subroutine of_setfocus ();//grab the focus to the default object

end subroutine

public subroutine of_showsql (boolean show);
if show then
	if not mle_1.visible then
		mle_1.visible=true
		iwo_result.y=mle_1.height+pixelsToUnits(1,YPixelsToUnits!)
		iwo_result.height -= iwo_result.y
	end if
else
	if mle_1.visible then
		mle_1.visible=false
		iwo_result.y=0
		iwo_result.height = this.height
	end if
end if

end subroutine

public subroutine of_updateview ();of_showsql(cfg.of_getoption(cfg.is_showrssql))
is_nullvalue=cfg.of_getstring(cfg.is_options,cfg.is_nullstr)
if trim(is_nullvalue)='' then setNull(is_nullvalue)


end subroutine

private subroutine of_generatenumber ();long i,count

if this.number=0 then
	count=upperbound(ib_rsnumberuse[])
	for i=1 to count
		if ib_rsnumberuse[i] then number=i
	next
	number++
	ib_rsnumberuse[number]=true
end if

end subroutine

public function boolean of_save (boolean ab_prompt);//
return false

end function

public subroutine of_storecfg ();cfg.of_setstring(cfg.is_options,cfg.is_nullstr,is_nullvalue )
cfg.of_setoption( cfg.is_showrssql , mle_1.visible)

end subroutine

public function boolean of_find (readonly string find_text, boolean find_case, boolean find_wword, boolean find_wstart, boolean find_back);//should find text and return true if found, false if not
return false

end function

public subroutine of_sybexec_newrow (long al_row);//in_rsinfo[il_rscount].il_rowcount=al_row
in_rsinfo[il_rscount].il_rowcount++
this.event ue_newrow( )

end subroutine

public subroutine of_sybexec_setfield (readonly long al_col, readonly string as_value);if in_rsinfo[il_rscount].il_rowcount=0 then
	//moved to SetFieldInfo
else
	this.event ue_setfield(al_col,as_value)
	if al_col=in_rsinfo[il_rscount].il_colcount then this.event ue_row_end()
end if

return

end subroutine

public subroutine of_sybexec_resultset (readonly long al_rstype, readonly long al_colcount);//new resultset incoming...

il_rscount++
in_rsinfo[il_rscount]=create n_resultset_info
in_rsinfo[il_rscount].il_colcount=al_colcount
in_rsinfo[il_rscount].it_col[al_colcount].name=''
in_rsinfo[il_rscount].is_name=''
//this.event ue_resultset_begin()  //not needed here because it's called in of_sybexec_fieldset

end subroutine

public subroutine of_sybexec_tabname (readonly string as_tablename);in_rsinfo[il_rscount].is_name=as_tablename
return

end subroutine

public subroutine of_sybexec_setfieldinfo (readonly long al_col, readonly string as_value);long pos,pos2

//receive the column definition
pos=pos(as_value,'?')
pos2=pos(as_value,'?',pos+1)
in_rsinfo[il_rscount].it_col[al_col].sqltype=left(as_value,pos -1)
in_rsinfo[il_rscount].it_col[al_col].displaylen=long(mid(as_value,pos+1,pos2 - pos -1))
in_rsinfo[il_rscount].it_col[al_col].name=mid(as_value,pos2+1)
in_rsinfo[il_rscount].it_col[al_col].maxcharlen=max(len(in_rsinfo[il_rscount].it_col[al_col].name),len(in_rsinfo[il_rscount].it_col[al_col].sqltype))

if in_rsinfo[il_rscount].it_col[al_col].maxcharlen>in_rsinfo[il_rscount].it_col[al_col].displaylen then
	in_rsinfo[il_rscount].it_col[al_col].displaylen=in_rsinfo[il_rscount].it_col[al_col].maxcharlen
end if
//create the header if last column
if al_col=in_rsinfo[il_rscount].il_colcount then this.event ue_resultset_begin()

return

end subroutine

on uo_resultset.create
int iCurrent
call super::create
this.mle_1=create mle_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_1
end on

on uo_resultset.destroy
call super::destroy
destroy(this.mle_1)
end on

event destructor;call super::destructor;ib_rsnumberuse[number]=false

end event

event constructor;call super::constructor;of_generatenumber()

end event

event ue_selected;call super::ue_selected;//close(w_find)
close(w_replace)

end event

event ue_init;call super::ue_init;
CHOOSE CASE il_pagetype
	CASE typeRs,typeRsOutput
		this.text='Result '+string(number)
	CASE typeRsProcess
		this.text='Processes'
	CASE ELSE
		//???
END CHOOSE

end event

type mle_1 from uo_mle within uo_resultset
integer width = 498
integer height = 324
integer taborder = 30
long backcolor = 76585128
string text = ""
boolean vscrollbar = true
boolean displayonly = true
end type

