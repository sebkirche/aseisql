HA$PBExportHeader$w_toolbars.srw
forward
global type w_toolbars from window
end type
type dw_1 from datawindow within w_toolbars
end type
type cb_ok from commandbutton within w_toolbars
end type
type cb_cancel from commandbutton within w_toolbars
end type
type cbx_text from checkbox within w_toolbars
end type
type cbx_tips from checkbox within w_toolbars
end type
end forward

global type w_toolbars from window
integer width = 1262
integer height = 696
boolean titlebar = true
string title = "Toolbars"
long backcolor = 67108864
event ue_changes ( )
dw_1 dw_1
cb_ok cb_ok
cb_cancel cb_cancel
cbx_text cbx_text
cbx_tips cbx_tips
end type
global w_toolbars w_toolbars

forward prototypes
public function boolean  f_retrieve ()
public subroutine  f_add (readonly window w, integer tb_number)
public function boolean  f_isbase ()
end prototypes

public function boolean  f_retrieve ();long i,l
window w
int ai_toolbars[], empty[]

w=w_main
ai_toolbars=empty
l=cfg.of_gettoolbars(w.menuid,ai_toolbars)
for i=1 to l
	 f_add(w,ai_toolbars[i])
next
w=w.GetActiveSheet()
if not isValid(w) then return true

ai_toolbars=empty
l=cfg.of_gettoolbars(w.menuid,ai_toolbars)
for i=1 to l
	 f_add(w,ai_toolbars[i])
next
return(true)

end function

public subroutine  f_add (readonly window w, integer tb_number);long row
string w_name,tb_name,isvisible
toolbaralignment align
boolean b

w_name=w.ClassName()
w.GetToolBar(tb_number,b,align,tb_name)
isVisible='0'
if b then isVisible='1'

row=dw_1.insertRow(0)
if row>0 then
	dw_1.SetItem(row,"isvisible",isvisible)
	dw_1.SetItem(row,"tb_number",tb_number)
	dw_1.SetItem(row,"tb_name",tb_name)
	dw_1.SetItem(row,"w_name",w_name)
end if

end subroutine

public function boolean  f_isbase ();return true

end function

on w_toolbars.create
this.dw_1=create dw_1
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.cbx_text=create cbx_text
this.cbx_tips=create cbx_tips
this.Control[]={this.dw_1,&
this.cb_ok,&
this.cb_cancel,&
this.cbx_text,&
this.cbx_tips}
end on

on w_toolbars.destroy
destroy(this.dw_1)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.cbx_text)
destroy(this.cbx_tips)
end on

event open;cbx_text.checked=app().ToolbarText
cbx_tips.checked=app().ToolbarTips
f_retrieve()

f_autosize(this)
f_centerwindow(this)

end event

type dw_1 from datawindow within w_toolbars
integer x = 14
integer y = 12
integer width = 1207
integer height = 384
integer taborder = 10
string dataobject = "zz_d_toolbars"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event itemchanged;cb_ok.enabled=true

end event

event editchanged;cb_ok.enabled=true

end event

event constructor;// f_SetAutoScrollClick(true)
// f_SetAutoSelectRow(true)
//SetRowFocusIndicator()
end event

type cb_ok from commandbutton within w_toolbars
integer x = 837
integer y = 408
integer width = 384
integer height = 84
integer taborder = 40
integer textsize = -8
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
boolean enabled = false
string text = "Ok"
boolean default = true
end type

event clicked;window ws
window w
string w_name,tb_name, f_name,s
int tb_number
boolean isvisible
long i,l
ToolBarAlignment tb_align

ws=w_main.GetActiveSheet()
 f_name=w_main.ClassName()

app().ToolbarText=cbx_text.checked
app().ToolbarTips=cbx_tips.checked

l=dw_1.RowCount()
for i=1 to l
	w_name=dw_1.GetItemString(i,"w_name")
	tb_number=dw_1.GetItemNumber(i,"tb_number")
	if w_name= f_name then
		w=w_main
	else
		w=ws
	end if
	w.GetToolBar(tb_number,isvisible,tb_align)
	isvisible=long(dw_1.GetItemString(i,"isvisible"))=1
	tb_name=dw_1.GetItemString(i,"tb_name")
	w.SetToolBar(tb_number,isvisible,tb_align,tb_name)
next
close(parent)

end event

type cb_cancel from commandbutton within w_toolbars
integer x = 837
integer y = 504
integer width = 384
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "&Cancel"
boolean cancel = true
end type

event clicked;call super::clicked;close(parent)
end event

type cbx_text from checkbox within w_toolbars
integer x = 14
integer y = 420
integer width = 782
integer height = 72
integer taborder = 20
integer textsize = -8
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long backcolor = 67108864
string text = "Show text"
end type

event clicked;cb_ok.enabled=true

end event

type cbx_tips from checkbox within w_toolbars
integer x = 14
integer y = 504
integer width = 782
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long backcolor = 67108864
string text = "Show tool tips"
end type

event clicked;cb_ok.enabled=true

end event

