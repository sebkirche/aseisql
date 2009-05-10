HA$PBExportHeader$w_statusbar.srw
forward
global type w_statusbar from window
end type
type dw_status from datawindow within w_statusbar
end type
type str_rect from structure within w_statusbar
end type
end forward

type str_rect from structure
	integer		x
	integer		y
	integer		w
	integer		h
end type

global type w_statusbar from window
integer width = 1001
integer height = 188
boolean border = false
windowtype windowtype = child!
long backcolor = 67108864
boolean toolbarvisible = false
event ue_frame_resize ( )
dw_status dw_status
end type
global w_statusbar w_statusbar

type variables
private window frame
private mdiclient mdi
private int VScrollWidth
//private 
private string fontface='Microsoft Sans Serif'
private int fontheight=8

end variables

forward prototypes
public function boolean f_setimage (readonly string field_name, readonly string image)
private function boolean f_addfield (readonly string field_name, readonly string field_type, integer pbu_width, readonly string params, boolean font, boolean color, boolean default)
public function boolean f_settext (readonly string field_name, readonly string text)
public function boolean f_addimage (readonly string field_name, integer pbu_width, readonly string image)
public function string f_getimage (readonly string image)
public function string f_gettext (readonly string field_name)
public function boolean f_settimer (long millis)
public function long f_gettimer ()
public function string f_tostring (alignment align)
public function boolean f_addcompute (readonly string field_name, integer pbu_width, alignment field_align, readonly string expression)
public function boolean f_addcompute (readonly string field_name, integer pbu_width, alignment field_align, readonly string expression, readonly string format)
public function boolean f_clear ()
public subroutine bringtotop ()
public function boolean f_addtext (readonly string field_name, integer pbu_width, alignment field_align, readonly string text)
public function boolean f_addtext (readonly string field_name, integer pbu_width, alignment field_align)
public function boolean f_addtext_ex (readonly string field_name, integer pbu_width, alignment field_align, readonly string text)
public function boolean f_getrect (readonly string name, ref t_rect r)
end prototypes

event ue_frame_resize();//this event should be triggered by parent window
//to resize statusbar
WindowState state
str_rect r

state=frame.WindowState

r.x=frame.workspaceWidth()-dw_status.width
if state<>maximized! then r.x -= VScrollWidth
r.y=frame.WorkSpaceHeight()-this.height//+frame.WorkSpaceY()

if upperbound(frame.control)>1 then
	r.y+=frame.WorkSpaceY()
	r.x+=frame.workspaceX()
end if

r.w=dw_status.width
r.h=mdi.MicroHelpHeight

//r.x=frame.width - r.w
//r.y=frame.height - r.h

this.resize(r.w,r.h)
this.move(r.x,r.y)

this.post bringToTop()

end event

public function boolean f_setimage (readonly string field_name, readonly string image);return dw_status.modify(field_name+'.Filename="'+image+'"')=""

end function

private function boolean f_addfield (readonly string field_name, readonly string field_type, integer pbu_width, readonly string params, boolean font, boolean color, boolean default);if dw_status.describe(field_name+".x")<>'!' then return false

string s
int pix_width,sb_height
str_rect b,f
integer lastwidth

lastwidth=integer(dw_status.describe("lastwidth.text"))

pix_width=UnitsToPixels(pbu_width,XUnitsToPixels!)
if pix_width<=3 then pix_width=3
sb_height=UnitsToPixels(mdi.MicroHelpHeight,YUnitsToPixels!)

f.x=lastWidth
f.y=3
f.w=pix_width
f.h=sb_height -4

b.x=f.x+1
b.y=f.y+1
b.w=f.w -2
b.h=f.h -2
if default then
	b.x=f.x
	b.w=f.w -1
end if

s =' create text(band=header alignment="0" text="" border="5" color="33554432" x="'+string(b.x)+'" y="'+string(b.y)+'" height="'+string(b.h)+'" width="'+string(b.w)+'" name='+field_name+'_b font.face="'+fontface+'" font.height="-'+string(fontheight)+'" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="79741120" )'
s+=' create '+field_type+'(band=header '+params+' border="0" x="'+string(f.x)+'" y="'+string(f.y)+'" height="'+string(f.h)+'" width="'+string(f.w)+'" name='+field_name+''
if font then s+=' font.face="'+fontface+'" font.height="-'+string(fontheight)+'" font.weight="400"  font.family="2" font.pitch="2" font.charset="0"'
if color then s+=' color="33554432" background.mode="2" background.color="79741120"'
s+=')'

lastwidth+=f.w+4
s+=' lastwidth.text="'+string(lastwidth)+'"'
s=dw_status.Modify(s)
dw_status.width=PixelsToUnits(lastwidth,XPixelsToUnits!)
this.event ue_frame_resize()
return len(s)=0

end function

public function boolean f_settext (readonly string field_name, readonly string text);return dw_status.modify(field_name+'.text="'+text+'"')=""

end function

public function boolean f_addimage (readonly string field_name, integer pbu_width, readonly string image);return f_addfield ( field_name, "bitmap", pbu_width, 'filename="'+image+'"',false,false,false )

end function

public function string f_getimage (readonly string image);return dw_status.describe(image+".filename")

end function

public function string f_gettext (readonly string field_name);return dw_status.describe(field_name+".text")

end function

public function boolean f_settimer (long millis);return dw_status.modify('DataWindow.Timer_Interval="'+string(millis)+'"')=''

end function

public function long f_gettimer ();return long(dw_status.describe("datawindow.timer_interval"))

end function

public function string f_tostring (alignment align);CHOOSE CASE align
	CASE Right!
		return '1'
	CASE Center!
		return '2'
	CASE ELSE
		return '0'
END CHOOSE

end function

public function boolean f_addcompute (readonly string field_name, integer pbu_width, alignment field_align, readonly string expression);return f_addCompute( field_name, pbu_width, field_align, expression, '')

end function

public function boolean f_addcompute (readonly string field_name, integer pbu_width, alignment field_align, readonly string expression, readonly string format);string parm
parm='alignment="'+f_toString(field_align)+'" expression="'+expression+'"'
if format<>'' then parm+=' format="'+format+'"'
if f_addfield ( field_name, "compute", pbu_width, parm,true,true,false ) then
	if f_getTimer()=0 then f_setTimer(1000)
	return true
end if
return false

end function

public function boolean f_clear ();string dwsyntax='release 5; &
	datawindow(units=1 timer_interval=0 color=79741120 processing=0 print.documentname="" print.orientation = 0 print.margin.left = 24 print.margin.right = 24 print.margin.top = 24 print.margin.bottom = 24 print.paper.source = 0 print.paper.size = 0 print.prompt=no ) &
	header(height=22 color="536870912" ) &
	summary(height=0 color="536870912" ) &
	footer(height=0 color="536870912" ) &
	detail(height=0 color="553648127" ) &
	table(column=(type=char(1) updatewhereclause=yes name=dummy dbname="dummy" ) &
	) &
	text(band=header alignment="0" text="0"border="0" color="33554432" x="0" y="1" height="19" width="9"  name=lastwidth visible="0"  font.face="Arial" font.height="-12" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )'
//	compute(band=header alignment="0" expression="now()" border="0" x="0" y="0" height="10" width="0" font.face="Microsoft Sans Serif" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" color="33554432" background.mode="2" background.color="79741120" format="[time]")'

dw_status.create(dwSyntax)
dw_status.move(0,0)
dw_status.height=mdi.MicroHelpHeight
dw_status.Modify("DataWindow.Header.Height='"+string(mdi.MicroHelpHeight)+"'")

f_addfield ( "default_t", "text", 0, 'alignment="0" text=""',true,true,true )

this.event ue_frame_resize()
return false

end function

public subroutine bringtotop ();this.bringtotop=true

end subroutine

public function boolean f_addtext (readonly string field_name, integer pbu_width, alignment field_align, readonly string text);string parms
parms='alignment="'+f_toString(field_align)+'" text="'+text+'"'
return f_addfield ( field_name, "text", pbu_width, parms,true,true,false )

end function

public function boolean f_addtext (readonly string field_name, integer pbu_width, alignment field_align);return f_addtext( field_name, pbu_width, field_align,"" )

end function

public function boolean f_addtext_ex (readonly string field_name, integer pbu_width, alignment field_align, readonly string text);string parms
parms='alignment="'+f_toString(field_align)+'" text="'+text+'"'
parms+=' color="33554432" background.mode="2" background.color="1090519039"'
return f_addfield ( field_name, "text", pbu_width, parms,true,false,false )

end function

public function boolean f_getrect (readonly string name, ref t_rect r);r.left=long(dw_status.describe(name+'.x'))
r.top=long(dw_status.describe(name+'.y'))
r.right=long(dw_status.describe(name+'.width'))
r.bottom=long(dw_status.describe(name+'.height'))
r.right+=r.left
r.bottom+=r.top

r.left=PixelsToUnits(r.left,XPixelsToUnits!)
r.top=PixelsToUnits(r.top,YPixelsToUnits!)
r.right=PixelsToUnits(r.right,XPixelsToUnits!)
r.bottom=PixelsToUnits(r.bottom,YPixelsToUnits!)



return false

end function

on w_statusbar.create
this.dw_status=create dw_status
this.Control[]={this.dw_status}
end on

on w_statusbar.destroy
destroy(this.dw_status)
end on

event open;frame=this.ParentWindow()

this.VScrollBar=true
VScrollWidth=this.width - this.WorkSpaceWidth()
this.VScrollBar=false

if not isValid(frame) then goto error
if frame.WindowType<>MDIHelp! then goto error
if upperBound(frame.control)=0 then goto error
if frame.control[1].typeOf()<>mdiClient! then goto error
mdi=frame.control[1]

this.visible=true
f_clear()
return 0

error:
close(this)

end event

type dw_status from datawindow within w_statusbar
integer width = 946
integer height = 156
boolean border = false
borderstyle borderstyle = stylelowered!
end type

event clicked;if isValid(dwo) then
	Message.stringparm=dwo.name
	frame.setfocus()
	frame.triggerevent("ue_statusbar_clicked")
end if

end event

event doubleclicked;if isValid(dwo) then
	Message.stringparm=dwo.name
	frame.triggerevent("ue_statusbar_doubleclicked")
end if

end event

event rbuttondown;if isValid(dwo) then
	Message.stringparm=dwo.name
	frame.setfocus()
	frame.triggerevent("ue_statusbar_rbuttondown")
end if

end event

