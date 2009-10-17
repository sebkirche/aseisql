HA$PBExportHeader$uo_tabpage.sru
forward
global type uo_tabpage from userobject
end type
end forward

shared variables
long sl_ResultsetCount=0

end variables

global type uo_tabpage from userobject
integer width = 411
integer height = 432
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
string picturename = "ViewPainter!"
long picturemaskcolor = 12632256
event ue_init ( )
event ue_selected ( )
event type boolean ue_closeprompt ( )
end type
global uo_tabpage uo_tabpage

type variables
public privatewrite long typeEdit      =1
public privatewrite long typeEditFile  =2
public privatewrite long typeEditObject=3


public privatewrite long typeRs        =100
public privatewrite long typeRsProcess =101
public privatewrite long typeRsOutput  =102


public privatewrite long il_pagetype
public privatewrite long il_objtype //from n_sqlmenu

//encoding used to display file encoding
public protectedwrite string is_encoding  =''

public privatewrite boolean ib_locked=false //if page is locked and could not be closed (normally only first page)

end variables

forward prototypes
public subroutine of_print ()
public subroutine of_setfocus ()
public subroutine of_updateview ()
public function long of_getresultsetcount ()
public function boolean of_save (boolean ab_prompt)
public function boolean of_iseditor ()
public function boolean of_init (readonly string as_name, long al_type, long al_objtype, readonly string as_tooltip)
public function boolean of_find (readonly string find_text, boolean find_case, boolean find_wword, boolean find_wstart, boolean find_back)
public function boolean of_canclose ()
public subroutine of_setlocked (boolean b)
end prototypes

event ue_init();//use this event to continue tab initialization

end event

event ue_selected();//occured when this tabpage was selected
w_statusbar.f_settext('change','')
w_statusbar.f_settext('filecp',this.is_encoding)

end event

event type boolean ue_closeprompt();//should return true if we can close the tab 
//otherwise should return false
return true

end event

public subroutine of_print ();f_error('Print not implemented')

end subroutine

public subroutine of_setfocus ();f_error(this.classname()+'.of_setfocus not implemented.')

end subroutine

public subroutine of_updateview ();return

end subroutine

public function long of_getresultsetcount ();return sl_resultsetcount

end function

public function boolean of_save (boolean ab_prompt);return false

end function

public function boolean of_iseditor ();if il_pagetype<1 then SignalError(0,this.classname()+" page was not initialized. Type="+string(il_pagetype)+'.')
if il_pagetype=typeEditObject and il_objtype<1 then SignalError(0,this.classname()+" object type is incorrect. Type="+string(il_objtype)+'.')
return il_pagetype<100

end function

public function boolean of_init (readonly string as_name, long al_type, long al_objtype, readonly string as_tooltip);il_pagetype=al_type
il_objtype =al_objtype
CHOOSE CASE il_pagetype
	CASE typeEdit
		picturename='Query5!'
	CASE typeEditObject
		CHOOSE CASE il_objtype
			CASE gn_sqlmenu.typeProcedure
				picturename='img\proc_g.bmp'
			CASE gn_sqlmenu.typeTrigger
				picturename='img\trigger.bmp'
			CASE gn_sqlmenu.typeView
				picturename='img\view.bmp'
			CASE gn_sqlmenu.typeSFunction
				picturename='img\func_g.bmp'
			CASE ELSE
				picturename='NotFound!'
		END CHOOSE
	CASE typeEditFile
		picturename='DosEdit!'
	CASE typeRs
		picturename='DataWindow!'
	CASE typeRsProcess
		picturename='ViewPainter!'
	CASE typeRsOutput
		picturename='DeclareVariable!'
	CASE ELSE
		picturename='NotFound!'
END CHOOSE

text=as_name
PowerTipText=as_tooltip

if not this.of_iseditor() then sl_resultsetcount++
this.event ue_init()

return true

end function

public function boolean of_find (readonly string find_text, boolean find_case, boolean find_wword, boolean find_wstart, boolean find_back);return false

end function

public function boolean of_canclose ();//returns true if it's possible to close this page in terms of application

if (not sqlca.ib_executing or this.of_iseditor()) and not this.ib_locked then
	return true
end if
return false

end function

public subroutine of_setlocked (boolean b);this.ib_locked=b

end subroutine

on uo_tabpage.create
end on

on uo_tabpage.destroy
end on

event destructor;if not this.of_iseditor() then sl_resultsetcount --

end event

