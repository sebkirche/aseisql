HA$PBExportHeader$w_save.srw
forward
global type w_save from window
end type
type st_drop from statictext within w_save
end type
type tv_2 from uo_tablist within w_save
end type
type st_1 from statictext within w_save
end type
type cb_2 from commandbutton within w_save
end type
type cb_cancel from commandbutton within w_save
end type
type cb_ok from commandbutton within w_save
end type
end forward

global type w_save from window
integer width = 1659
integer height = 1476
boolean titlebar = true
string title = "Save ressources"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_drop st_drop
tv_2 tv_2
st_1 st_1
cb_2 cb_2
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_save w_save

on w_save.create
this.st_drop=create st_drop
this.tv_2=create tv_2
this.st_1=create st_1
this.cb_2=create cb_2
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.Control[]={this.st_drop,&
this.tv_2,&
this.st_1,&
this.cb_2,&
this.cb_cancel,&
this.cb_ok}
end on

on w_save.destroy
destroy(this.st_drop)
destroy(this.tv_2)
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

event open;f_autosize(this)

tv_2.of_init(true)

end event

type st_drop from statictext within w_save
boolean visible = false
integer x = 626
integer y = 1224
integer width = 535
integer height = 12
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 33554432
boolean focusrectangle = false
end type

type tv_2 from uo_tablist within w_save
event lbuttondown pbm_lbuttondown
event lbuttonup pbm_lbuttonup
integer x = 37
integer y = 108
integer width = 1573
integer height = 1096
integer taborder = 30
boolean disabledragdrop = true
boolean checkboxes = true
end type

event ue_newitem;call super::ue_newitem;uo_editpage e

if t.il_pagetype=t.typeEditObject or t.il_pagetype=t.typeEditFile then
	e=t
	if e.uo_edit.of_send( e.uo_edit.SCI_GETMODIFY , 0, 0)<>0 then
		return true
	end if
end if
return false
	
end event

type st_1 from statictext within w_save
integer x = 46
integer y = 40
integer width = 686
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Select the resources to save :"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_save
string tag = "2"
integer x = 37
integer y = 1256
integer width = 530
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "Select/Deselect All"
end type

event clicked;treeviewitem tvi
long h

this.tag = string ( mod( long(this.tag), 2)+1 )

h=tv_2.finditem(RootTreeItem!,0)
do while h<>-1
	tv_2.getItem(h,tvi)
	tvi.statepictureindex=long(this.tag)
	tv_2.setItem(h,tvi)
	h=tv_2.finditem(NextTreeItem!,h)
loop

end event

type cb_cancel from commandbutton within w_save
integer x = 1266
integer y = 1256
integer width = 343
integer height = 92
integer taborder = 40
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

type cb_ok from commandbutton within w_save
integer x = 887
integer y = 1256
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "Ok"
boolean default = true
end type

event clicked;long i,h
uo_editpage e
string s
treeviewitem tvi

h=tv_2.finditem(RootTreeItem!,0)
do while h<>-1
	tv_2.getItem(h,tvi)
	i=tvi.data
	e=w_main.tab_1.control[i]
	if tvi.statepictureindex=2 then
		if not e.of_store() then 
			close(parent)
			return 
		end if
	end if
	e.uo_edit.of_send(e.uo_edit.SCI_SETSAVEPOINT,0,0)
	h=tv_2.finditem(NextTreeItem!,h)
loop

closewithreturn(parent,1)

end event

