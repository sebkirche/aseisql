HA$PBExportHeader$w_replace.srw
forward
global type w_replace from w_find
end type
type sle_replace from singlelineedit within w_replace
end type
type st_1 from statictext within w_replace
end type
type cb_replace_all from commandbutton within w_replace
end type
type cb_replace from commandbutton within w_replace
end type
end forward

global type w_replace from w_find
integer height = 576
string title = "Replace"
sle_replace sle_replace
st_1 st_1
cb_replace_all cb_replace_all
cb_replace cb_replace
end type
global w_replace w_replace

forward prototypes
public function boolean of_replace ()
end prototypes

public function boolean of_replace ();uo_editpage e
string s
boolean b

if w_main.of_getcurrentedit(e) then
	if e.of_getselectedtext(s)>0 then
		if cbx_case.checked then b=(s=ddlb_1.text)
		if not cbx_case.checked then b=(lower(s)=lower(ddlb_1.text))

		if b then
			e.uo_edit.of_send( e.uo_edit.SCI_REPLACESEL, 0, sle_replace.text)
			return true
		end if
	end if
end if
return false

end function

on w_replace.create
int iCurrent
call super::create
this.sle_replace=create sle_replace
this.st_1=create st_1
this.cb_replace_all=create cb_replace_all
this.cb_replace=create cb_replace
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_replace
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_replace_all
this.Control[iCurrent+4]=this.cb_replace
end on

on w_replace.destroy
call super::destroy
destroy(this.sle_replace)
destroy(this.st_1)
destroy(this.cb_replace_all)
destroy(this.cb_replace)
end on

event ue_change;call super::ue_change;cb_replace.enabled=len(ddlb_1.text)>0
cb_replace_all.enabled=len(ddlb_1.text)>0

end event

type cbx_back from w_find`cbx_back within w_replace
integer y = 348
integer taborder = 50
end type

type cb_cancel from w_find`cb_cancel within w_replace
integer y = 364
integer taborder = 100
end type

type cbx_wstart from w_find`cbx_wstart within w_replace
integer y = 348
integer taborder = 60
end type

type cbx_wword from w_find`cbx_wword within w_replace
integer y = 272
integer taborder = 40
end type

type cbx_case from w_find`cbx_case within w_replace
integer y = 272
integer taborder = 30
end type

type cb_find from w_find`cb_find within w_replace
integer taborder = 70
end type

type ddlb_1 from w_find`ddlb_1 within w_replace
integer x = 398
integer width = 859
end type

type st_2 from w_find`st_2 within w_replace
end type

type sle_replace from singlelineedit within w_replace
integer x = 398
integer y = 152
integer width = 855
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
integer accelerator = 112
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_replace
integer x = 55
integer y = 168
integer width = 343
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Re&place with:"
boolean focusrectangle = false
end type

type cb_replace_all from commandbutton within w_replace
integer x = 1280
integer y = 256
integer width = 343
integer height = 92
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
boolean enabled = false
string text = "Replace &All"
end type

event clicked;long i
do 
	//try to replace current selection
	if of_replace() then i++
loop while of_find()

w_main.SetMicrohelp(string(i)+' matches were replaced.')
close(parent)

end event

type cb_replace from commandbutton within w_replace
integer x = 1280
integer y = 148
integer width = 343
integer height = 92
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
boolean enabled = false
string text = "&Replace"
end type

event clicked;//try to replace current selection
of_replace()
//find next
if not of_find() then
	w_main.SetMicrohelp('Not found')
	close(parent)
end if

end event

