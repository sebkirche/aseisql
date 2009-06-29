HA$PBExportHeader$w_prompt.srw
forward
global type w_prompt from window
end type
type sle_1 from singlelineedit within w_prompt
end type
type cb_cancel from commandbutton within w_prompt
end type
type cb_ok from commandbutton within w_prompt
end type
type st_1 from statictext within w_prompt
end type
type plb_1 from picturelistbox within w_prompt
end type
end forward

global type w_prompt from window
integer width = 1509
integer height = 684
boolean titlebar = true
string title = "prompt"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
sle_1 sle_1
cb_cancel cb_cancel
cb_ok cb_ok
st_1 st_1
plb_1 plb_1
end type
global w_prompt w_prompt

on w_prompt.create
this.sle_1=create sle_1
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_1=create st_1
this.plb_1=create plb_1
this.Control[]={this.sle_1,&
this.cb_cancel,&
this.cb_ok,&
this.st_1,&
this.plb_1}
end on

on w_prompt.destroy
destroy(this.sle_1)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_1)
destroy(this.plb_1)
end on

event open;n_hashtable hash
hash=message.powerobjectparm


this.st_1.text=hash.of_get( 'text', '')
this.sle_1.text=hash.of_get( 'value', '')

f_autosize(this)
this.title=app().displayname+" - prompt"

end event

type sle_1 from singlelineedit within w_prompt
integer x = 114
integer y = 220
integer width = 1262
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_cancel from commandbutton within w_prompt
integer x = 768
integer y = 344
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "Cancel"
boolean cancel = true
end type

event clicked;closeWithReturn(parent,'')

end event

type cb_ok from commandbutton within w_prompt
integer x = 352
integer y = 344
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "O&k"
boolean default = true
end type

event clicked;closeWithReturn(parent,sle_1.text)

end event

type st_1 from statictext within w_prompt
integer x = 297
integer y = 52
integer width = 1152
integer height = 128
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type plb_1 from picturelistbox within w_prompt
integer x = 37
integer y = 32
integer width = 169
integer height = 140
integer textsize = -10
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean border = false
string item[] = {" "}
integer itempictureindex[] = {1}
string picturename[] = {"Information!"}
integer picturewidth = 32
integer pictureheight = 32
long picturemaskcolor = 536870912
end type

