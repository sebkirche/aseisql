HA$PBExportHeader$w_find.srw
forward
global type w_find from window
end type
type cbx_back from checkbox within w_find
end type
type cb_cancel from commandbutton within w_find
end type
type cbx_wstart from checkbox within w_find
end type
type cbx_wword from checkbox within w_find
end type
type cbx_case from checkbox within w_find
end type
type cb_find from commandbutton within w_find
end type
type ddlb_1 from dropdownlistbox within w_find
end type
type st_2 from statictext within w_find
end type
end forward

global type w_find from window
integer width = 1678
integer height = 436
boolean titlebar = true
string title = "Find"
boolean controlmenu = true
windowtype windowtype = popup!
long backcolor = 67108864
event ue_notfound ( )
event ue_found ( )
event ue_change ( )
cbx_back cbx_back
cb_cancel cb_cancel
cbx_wstart cbx_wstart
cbx_wword cbx_wword
cbx_case cbx_case
cb_find cb_find
ddlb_1 ddlb_1
st_2 st_2
end type
global w_find w_find

type variables

end variables

forward prototypes
public function boolean of_find ()
public subroutine of_settext (readonly string s)
end prototypes

event ue_notfound();close(this)
w_main.SetMicrohelp('Not found')

end event

event ue_found();//

end event

event ue_change();cb_find.enabled=len(ddlb_1.text)>0

end event

public function boolean of_find ();long i,count
count=ddlb_1.TotalItems()
for i=1 to count
	if ddlb_1.text(i)=ddlb_1.text then
		ddlb_1.deleteItem(i)
	end if
next
ddlb_1.InsertItem ( ddlb_1.text,  1)
ddlb_1.selectItem(1)

w_main.find_text   = ddlb_1.text
w_main.find_case   = cbx_case.checked
w_main.find_wword  = cbx_wword.checked
w_main.find_wstart = cbx_wstart.checked
w_main.find_back   = cbx_back.checked

if w_main.Event ue_find_next() then 
	this.event ue_found()
	return true
end if
return false

end function

public subroutine of_settext (readonly string s);ddlb_1.text=left(s,250)

end subroutine

on w_find.create
this.cbx_back=create cbx_back
this.cb_cancel=create cb_cancel
this.cbx_wstart=create cbx_wstart
this.cbx_wword=create cbx_wword
this.cbx_case=create cbx_case
this.cb_find=create cb_find
this.ddlb_1=create ddlb_1
this.st_2=create st_2
this.Control[]={this.cbx_back,&
this.cb_cancel,&
this.cbx_wstart,&
this.cbx_wword,&
this.cbx_case,&
this.cb_find,&
this.ddlb_1,&
this.st_2}
end on

on w_find.destroy
destroy(this.cbx_back)
destroy(this.cb_cancel)
destroy(this.cbx_wstart)
destroy(this.cbx_wword)
destroy(this.cbx_case)
destroy(this.cb_find)
destroy(this.ddlb_1)
destroy(this.st_2)
end on

event open;ddlb_1.visible=false
f_autosize(this)
f_centerwindow(this)
ddlb_1.visible=true
ddlb_1.setFocus()

long count=0
string s

do while true
	count++
	s=cfg.of_getString('find',string(count,'00'),'')
	if s='' or count>11 then exit
	ddlb_1.AddItem(s)
loop
ddlb_1.selectItem(1)
this.event ue_change()

//w_main.find_text   = ddlb_1.text
cbx_case.checked   = w_main.find_case
cbx_wword.checked  = w_main.find_wword
cbx_wstart.checked = w_main.find_wstart
cbx_back.checked   = w_main.find_back

//do not keep together find and replace dialogs
if this.classname()='w_replace' then
	close(w_find)
else
	close(w_replace)
end if

end event

event close;long i,count
count=min(ddlb_1.TotalItems(),11)
for i=1 to count
	cfg.of_setString('find',string(i,'00'),ddlb_1.text(i))
next

end event

type cbx_back from checkbox within w_find
integer x = 55
integer y = 228
integer width = 594
integer height = 64
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Search &Backwards"
end type

type cb_cancel from commandbutton within w_find
integer x = 1280
integer y = 148
integer width = 343
integer height = 92
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "Cancel"
boolean cancel = true
end type

event clicked;close(parent)

end event

type cbx_wstart from checkbox within w_find
integer x = 677
integer y = 228
integer width = 498
integer height = 64
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Word &Start"
end type

type cbx_wword from checkbox within w_find
integer x = 677
integer y = 152
integer width = 498
integer height = 64
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Whole &Word"
end type

type cbx_case from checkbox within w_find
integer x = 55
integer y = 152
integer width = 498
integer height = 64
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Match &Case"
end type

type cb_find from commandbutton within w_find
integer x = 1280
integer y = 40
integer width = 343
integer height = 92
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
boolean enabled = false
string text = "&Find Next"
boolean default = true
end type

event clicked;if not of_find() then
	close(parent)
end if

end event

type ddlb_1 from dropdownlistbox within w_find
event editchange pbm_cbneditchange
event selendok pbm_cbnselendok
event closeup pbm_cbncloseup
integer x = 302
integer y = 44
integer width = 955
integer height = 668
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
boolean allowedit = true
boolean autohscroll = true
boolean sorted = false
boolean vscrollbar = true
integer limit = 250
integer accelerator = 110
borderstyle borderstyle = stylelowered!
end type

event editchange;parent.event ue_change()

end event

event closeup;parent.event ue_change()

end event

type st_2 from statictext within w_find
integer x = 55
integer y = 56
integer width = 261
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fi&nd what:"
boolean focusrectangle = false
end type

