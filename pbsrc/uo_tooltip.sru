HA$PBExportHeader$uo_tooltip.sru
forward
global type uo_tooltip from statictext
end type
type rect from structure within uo_tooltip
end type
type ttoolinfo from structure within uo_tooltip
end type
type ttoolinfo_l from structure within uo_tooltip
end type
type ttooltiptext from structure within uo_tooltip
end type
type tnmhdr from structure within uo_tooltip
end type
type ttooltiptext_l from structure within uo_tooltip
end type
type point from structure within uo_tooltip
end type
type thwnd2obj from structure within uo_tooltip
end type
type timingobj from timing within uo_tooltip
end type
end forward

type rect from structure
	long		left
	long		top
	long		right
	long		bottom
end type

type ttoolinfo from structure
	long		cbsize
	long		uflags
	long		hwnd
	long		uid
	rect		rect
	long		hinst
	string		lpsztext
	long		lparam
end type

type ttoolinfo_l from structure
	long		cbsize
	long		uflags
	long		hwnd
	long		uid
	rect		rect
	long		hinst
	long		lpsztext
	long		lparam
end type

type ttooltiptext from structure
	tnmhdr		nmhdr
	string		lpsztext
	character		sztext[80]
	long		hinst
	unsignedlong		uflags
end type

type tnmhdr from structure
	unsignedlong		hwndfrom
	unsignedlong		idfrom
	long		code
end type

type ttooltiptext_l from structure
	tnmhdr		nmhdr
	long		lpsztext
	character		sztext[80]
	long		hinst
	unsignedlong		uflags
end type

type point from structure
	long		x
	long		y
end type

type thwnd2obj from structure
	long		hwnd
	dragobject		obj
end type

global type uo_tooltip from statictext
boolean visible = false
integer width = 334
integer height = 80
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 15793151
boolean enabled = false
string text = "Tooltip"
alignment alignment = center!
boolean border = true
event type string needtext ( long handle )
timingobj timingobj
end type
global uo_tooltip uo_tooltip

type prototypes
//Argument Description 
//dwExStyle The extended window style for the ToolTip control. 
//lpClassName The class name for the ToolTip control, which is TOOLTIPS_CLASSA. 
//lpWindowName The window to display the ToolTip on, such as Form1.hwnd. 
//dwStyle The style of the window (ToolTip). 
//X The horizontal position of the ToolTip window. 
//Y The vertical position of the ToolTip window. 
//nWidth The width of the window. 
//nHeight The height of the window. 
//hWndParent The handle of the parent window. 
//hMenu The child identifier or menu handle. 
//hInstance The handle to the instance of the application. 
//lpParam Window creation data. 
private function long CreateWindowEx(Long dwExStyle,string lpClassName,string lpWindowName,ulong dwStyle,int Xpos, int Ypos, int nWidthg, int nHeight, long hWndParent, long hMenu, long hInstance, long lpParam ) library "user32" Alias for "CreateWindowExW"
private function long SendMessage(long handle,long msg,long wParam,ref ttoolinfo lParam) library "user32.dll" alias for SendMessageW
private function long SendMessage(long handle,long msg,long wParam,ref ttoolinfo_l lParam) library "user32.dll" alias for SendMessageW

// Memory functions
private Function long RtlMoveMemory(REF ttooltiptext str, long Source, long Size) library "kernel32"
private Function long RtlMoveMemory(long Source, REF ttooltiptext str, long Size) library "kernel32"

private Function long RtlMoveMemory(REF ttooltiptext_l str, long Source, long Size) library "kernel32"
private Function long RtlMoveMemory(long Source, REF ttooltiptext_l str, long Size) library "kernel32"

private function boolean GetCursorPos(ref point p) library "user32.dll"
private function boolean DestroyWindow(long h)library "user32.dll"

private function long GetWindow(long h,long uCmd) library "user32.dll"
private function boolean IsWindow(long h) library "user32.dll"

end prototypes

type variables
private:
ulong hTooltipControl
int mousemovecount=0
long oldcapturehandle=0
point mousepos

//used by other event. don't use it for anything else.
ttooltiptext tooltiptext

thwnd2obj hwnd2obj[] 
long il_h2osize=0
long il_h2ocount=0

end variables

forward prototypes
public function long of_gettoolcount ()
public function integer of_settitle (icon as_icon, readonly string as_titletext)
public function long of_getmaxwidth ()
public function long of_setmaxwidth (long maxwidth)
private subroutine of_objdel (long h)
private function boolean of_objget (long h, ref dragobject obj)
private function long of_objindex (long h)
public subroutine of_deltooltip (readonly dragobject tool)
public function boolean of_settooltip (readonly dragobject tool)
public function boolean of_settooltip (readonly dragobject tool, string lpsztext)
private subroutine of_objadd (long h, readonly dragobject obj)
public subroutine of_checktools (boolean ab_force)
public subroutine of_setdelay (long al_mswait)
end prototypes

event type string needtext(long handle);//DMLU
//You can use this event to return dynamic tooltips
//defined with function of_setToolTip(powerobject)
//This event called every time when a tooltip is to be showed
//the example of the script for this event:
//CHOOSE CASE handle
//	CASE handle(dw_1)
//		return dw_1.getObjectAtPointer()
//	CASE ELSE
//		return "no data"
//END CHOOSE
//
//if empty string or null is returned then tool tip will not be desplayed


return ""

end event

public function long of_gettoolcount ();//DMLU
//function: returns object count registered for a tooltip displaying
return Send(htooltipcontrol,1024+13,0,0)
end function

public function integer of_settitle (icon as_icon, readonly string as_titletext);//DMLU
//function: sets the title and icon for a tooltip window
//works only under Windows XP

int li_icon

choose case as_icon
	case Information! 
		li_icon = 1
	case Exclamation! 
		li_icon = 2
	case StopSign! 
		li_icon = 3
	case else
		li_icon = 0
end choose

return Send(hTooltipControl, 1024+33/*TTM_SETTITLEW*/, li_icon, as_titletext)

end function

public function long of_getmaxwidth ();//DMLU
//RETURNS Last set maximum width of the tooltip window

return send(htooltipcontrol,/*TTM_GETMAXTIPWIDTH*/1024 + 25,0,0)

end function

public function long of_setmaxwidth (long maxwidth);//DMLU
//Sets the maximum width (in pixels) for a tooltip window
//Returns a value that represents the previous maximum ToolTip width.

//Text that exceeds this width will wrap to the next line rather 
//than widening the display region. 
//The rectangle height will be increased as needed to accommodate the additional lines. 
//The ToolTip control will wrap the lines automatically,
//or you can use a carriage return/line feed combination,
//~r~n, to force line breaks at particular locations.

return Send(htooltipcontrol,/*TTM_SETMAXTIPWIDTH*/1024+24,0,maxwidth)

end function

private subroutine of_objdel (long h);long i
dragobject o

i=of_objindex(h)
if i<>0 then
	hwnd2obj[i].hwnd=0
	hwnd2obj[i].obj=o
	il_h2ocount --
end if

end subroutine

private function boolean of_objget (long h, ref dragobject obj);long i

i=of_objindex(h)
if i=0 then return false
obj=hwnd2obj[i].obj
return true

end function

private function long of_objindex (long h);//simple hash support
long ll_index

ll_index=mod(h,il_h2osize)+1
do while hwnd2obj[ll_index].hwnd<>0 and hwnd2obj[ll_index].hwnd<>h
	ll_index++
	if ll_index>il_h2osize then ll_index=1
loop
if hwnd2obj[ll_index].hwnd=0 then return 0
return ll_index


end function

public subroutine of_deltooltip (readonly dragobject tool);//DMLU
//function: deletes a tooltip from an object
long h
long GW_CHILD=5
long GW_HWNDNEXT=2

TToolInfo ToolInfo

toolinfo.cbSize = 44
toolinfo.uFlags = 1 + 16//TTF_IDISHWND|TTF_SUBCLASS;
toolinfo.hwnd = handle(tool)
toolinfo.uId = handle(tool)
toolinfo.hinst = 0;

SendMessage( hTooltipControl,1024+51/*TTM_DELTOOLW*/,0,toolinfo )
of_objdel(handle(tool))

//now unregister all fields inside datawindow. 
//it will give tooltip ability to work over fields when they are active.
if tool.typeof()=DataWindow! then
	h=this.GetWindow(handle(tool),GW_CHILD)
	do while h<>0
		toolinfo.uId = h
		SendMessage( hTooltipControl,1024+51/*TTM_DELTOOL*/,0,toolinfo )
		of_objdel(h)
		h=this.GetWindow(h,GW_HWNDNEXT)
	loop
end if
of_checktools(false)

end subroutine

public function boolean of_settooltip (readonly dragobject tool);//DMLU
//function: Registers an object for the dynamic tooltip
//          After using this function developer should implement NeedText event
//          For more information see NeedText event comments
boolean b
long h
long GW_CHILD=5
long GW_HWNDNEXT=2

ttoolinfo_l toolinfo

toolinfo.cbSize = 44
toolinfo.uFlags = 1 + 16//TTF_IDISHWND|TTF_SUBCLASS;
toolinfo.hwnd = handle(this)
toolinfo.uId = handle(tool)
toolinfo.hinst = 0;
toolinfo.lpszText = -1
b=SendMessage( hTooltipControl,1024+50/*TTM_ADDTOOLW*/,0,toolinfo )<>0
of_objadd(handle(tool),tool)
//now register all fields inside datawindow. 
//it will give tooltip ability to work over fields when they are active.
if tool.typeof()=DataWindow! then
	h=this.GetWindow(handle(tool),GW_CHILD)
	do while h<>0
		toolinfo.uId = h
		b=b and SendMessage( hTooltipControl,1024+50/*TTM_ADDTOOLW*/,0,toolinfo )<>0
		of_objadd(h,tool)
		h=this.GetWindow(h,GW_HWNDNEXT)
	loop
end if

of_checktools(false)

return b

end function

public function boolean of_settooltip (readonly dragobject tool, string lpsztext);//DMLU
//function: sets static tooltip "lpsztext" for a control "tool"

TToolInfo ToolInfo
boolean b

toolinfo.cbSize = 44
toolinfo.uFlags = 1 + 16//TTF_IDISHWND|TTF_SUBCLASS;
toolinfo.hwnd = handle(tool)
toolinfo.uId = handle(tool)
toolinfo.hinst = 0;

if SendMessage( hTooltipControl,1024+53/*TTM_GETTOOLINFOW*/,0,toolinfo )=0 then
	//this tool is not registered so register it
	toolinfo.lpszText = lpszText
	return SendMessage( hTooltipControl,1024+50/*TTM_ADDTOOLW*/,0,toolinfo )<>0
end if
//this tool is registered so update the tooltip text if it's needed
if toolinfo.lpszText = lpszText then return false
toolinfo.lpszText = lpszText
b=SendMessage( hTooltipControl,1024+57/*TTM_UPDATETIPTEXTW*/,0,toolinfo )<>0
of_checktools(false)
return b

end function

private subroutine of_objadd (long h, readonly dragobject obj);//simple hash support
long ll_index,i,ll_newsize
thwnd2obj new[]

//resize 
if il_h2osize<(il_h2ocount+1)*1.3 then
	//resize hash
	if il_h2osize=0 then
		ll_newsize=87
	else
		ll_newsize=il_h2osize*1.77
	end if
	//init new array
	new[ll_newsize].hwnd=0
	for i=1 to il_h2osize
		if hwnd2obj[i].hwnd<>0 then
			ll_index=mod(hwnd2obj[i].hwnd,ll_newsize)+1
			do while new[ll_index].hwnd<>0 and new[ll_index].hwnd<>hwnd2obj[i].hwnd
				ll_index++
				if ll_index>ll_newsize then ll_index=1
			loop
			new[ll_index].hwnd=hwnd2obj[i].hwnd
			new[ll_index].obj=hwnd2obj[i].obj
		end if
	next
	hwnd2obj=new
	il_h2osize=ll_newsize
end if

ll_index=mod(h,il_h2osize)+1
do while hwnd2obj[ll_index].hwnd<>0 and hwnd2obj[ll_index].hwnd<>h
	ll_index++
	if ll_index>il_h2osize then ll_index=1
loop
hwnd2obj[ll_index].hwnd=h
hwnd2obj[ll_index].obj=obj
il_h2ocount ++
return

end subroutine

public subroutine of_checktools (boolean ab_force);//this function appears for BAD programmers
//in order to check nonexistent tools
long i,count
TToolInfo ToolInfo
dragobject none


if ab_force or mod(il_h2ocount,10)=0 then
	for i=1 to il_h2osize
		if hwnd2obj[i].hwnd=0 then continue
		if isValid(hwnd2obj[i].obj) and IsWindow(hwnd2obj[i].hwnd) then continue
		toolinfo.cbSize = 44
		toolinfo.uFlags = 1 + 16//TTF_IDISHWND|TTF_SUBCLASS;
		toolinfo.hwnd = handle(this)
		toolinfo.uId = hwnd2obj[i].hwnd
		toolinfo.hinst = 0
		
		SendMessage( hTooltipControl,1024+51/*TTM_DELTOOLW*/,0,toolinfo )
		
		of_objdel(hwnd2obj[i].hwnd)
		count++
	next
end if

end subroutine

public subroutine of_setdelay (long al_mswait);long TTDT_AUTOMATIC=0
long TTDT_AUTOPOP=2
long TTDT_INITIAL=3
long TTDT_RESHOW=1

long TTM_SETDELAYTIME=1024+3

send(htooltipcontrol,TTM_SETDELAYTIME,TTDT_AUTOPOP,al_msWait)

end subroutine

on uo_tooltip.create
this.timingobj=create timingobj
end on

on uo_tooltip.destroy
destroy(this.timingobj)
end on

event constructor;//DMLU
//function: initialize the control

//disable and hide this control.
//we need it only to catch WM_NOTIFY events from tooltip window 
this.visible=false
this.enabled=false

//Create a tooltip window
hTooltipControl = CreateWindowEx( 0,"tooltips_class32","XXX>=- pbtip -=<XXX",1 + 2,0,0,0,0,0/*Handle(this)*/,0,Handle(GetApplication()),0 )

of_setmaxwidth(600)
return 0

end event

event other;//DMLU
//function: used to catch WM_NOTIFY events for internal use.
ttooltiptext_l tooltiptext_l
//TToolInfo ToolInfo
rect r
dragobject obj

if message.number = 78 /* WM_NOTYFY */ then
	RtlMoveMemory(tooltiptext_l ,lParam,12)
	CHOOSE CASE tooltiptext_l.nmhdr.code
		CASE -521
			//this.event ttn_show()
		CASE -522
			//this.event ttn_pop()
			//deactivate/activate tooltip in order to prevent extra needtext event
			//that appears after TTN_POP
			//TTM_ACTIVATE,false
			post(htooltipcontrol,1024+1,0,0)
			//magic? but we don't have to activate it?
			//activation causes infinite loop
			tooltiptext.lpsztext=''
		CASE -530
			//need text triggered at least two times before tooltip show
			//and several times after.
			//to avoid this we will store tooltip until TTN_POP
			
			if tooltiptext.lpsztext='' then
				RtlMoveMemory(tooltiptext_l ,lParam,184)
				tooltiptext.nmhdr          = tooltiptext_l.nmhdr
		
				tooltiptext.sztext         = tooltiptext_l.sztext
				tooltiptext.hinst          = tooltiptext_l.hinst
				tooltiptext.uflags         = tooltiptext_l.uflags
				//request the tooltip from a control
				if of_objget(tooltiptext.nmhdr.idfrom,obj) then
					if isValid(obj) then
						obj.dynamic event ue_needtooltip(tooltiptext.lpsztext)
					end if
				end if
				//support old event type
				if tooltiptext.lpsztext='' then
					tooltiptext.lpsztext=this.event needtext(tooltiptext.nmhdr.idfrom)
				end if
			end if
			if isnull(tooltiptext.lpsztext) then tooltiptext.lpsztext=''
			if len(tooltiptext.lpsztext)>0 then
				RtlMoveMemory(lParam,tooltiptext,184)
				//remember cursor position for dynamic tooltip
				GetCursorPos(mousepos)
				//start timer to control mouse movement
				TimingObj.Start(0.3)
			else
				//reactivate a tool tip. 
				//because it becomes disabled on empty string receive.
				//TTM_ACTIVATE,false
				Send(htooltipcontrol,1024+1,0,0)
				//TTM_ACTIVATE,true
				post(htooltipcontrol,1024+1,1,0)
			end if
	END CHOOSE
end if

return 0

end event

event destructor;DestroyWindow(htooltipcontrol)
htooltipcontrol=0
return 0

end event

type timingobj from timing within uo_tooltip descriptor "pb_nvo" = "true" 
end type

event timer;//DMLU
//function: used to catch mousemove after dynamic tooltip was showed
//          to hide a tooltip if mouse was moved.
//
point mpos
long delta=5
GetCursorPos(mpos)

if mpos.x < mousepos.x - delta or mpos.x > mousepos.x + delta or &
	mpos.y < mousepos.y - delta or mpos.y > mousepos.y + delta then
	TimingObj.Stop()
	//make tooltip disappear
	//TTM_ACTIVATE,false
	Send(htooltipcontrol,1024+1,0,0)
	//TTM_ACTIVATE,true
	post(htooltipcontrol,1024+1,1,0)
end if

end event

on timingobj.create
call super::create
TriggerEvent( this, "constructor" )
end on

on timingobj.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

