HA$PBExportHeader$w_options.srw
forward
global type w_options from window
end type
type cb_cancel from commandbutton within w_options
end type
type cb_apply from commandbutton within w_options
end type
type cb_ok from commandbutton within w_options
end type
type plb_1 from picturelistbox within w_options
end type
end forward

global type w_options from window
integer width = 2290
integer height = 1576
boolean titlebar = true
string title = "Options"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_changed ( )
cb_cancel cb_cancel
cb_apply cb_apply
cb_ok cb_ok
plb_1 plb_1
end type
global w_options w_options

type variables
uo_option_master uo_opt[]

end variables

event ue_changed();cb_ok.enabled=true
cb_apply.enabled=true

end event

on w_options.create
this.cb_cancel=create cb_cancel
this.cb_apply=create cb_apply
this.cb_ok=create cb_ok
this.plb_1=create plb_1
this.Control[]={this.cb_cancel,&
this.cb_apply,&
this.cb_ok,&
this.plb_1}
end on

on w_options.destroy
destroy(this.cb_cancel)
destroy(this.cb_apply)
destroy(this.cb_ok)
destroy(this.plb_1)
end on

event open;int i

this.OpenUserObject ( uo_opt[upperbound(uo_opt)+1], 'uo_option_editor', 512, 16 )
this.OpenUserObject ( uo_opt[upperbound(uo_opt)+1], 'uo_option_resultset', 512, 16 )
this.OpenUserObject ( uo_opt[upperbound(uo_opt)+1], 'uo_option_tab', 512, 16 )
this.OpenUserObject ( uo_opt[upperbound(uo_opt)+1], 'uo_option_log', 512, 16 )
this.OpenUserObject ( uo_opt[upperbound(uo_opt)+1], 'uo_option_browse', 512, 16 )
this.OpenUserObject ( uo_opt[upperbound(uo_opt)+1], 'uo_option_file', 512, 16 )
this.OpenUserObject ( uo_opt[upperbound(uo_opt)+1], 'uo_option_debug', 512, 16 )

for i=1 to upperbound(uo_opt)
	uo_opt[i].event ue_init()
	plb_1.addpicture( uo_opt[i].Picturename )
	plb_1.additem( uo_opt[i].Text, i)
next

plb_1.selectItem(1)
plb_1.event selectionchanged(1)

cb_ok.enabled=false
cb_apply.enabled=false

end event

type cb_cancel from commandbutton within w_options
integer x = 1888
integer y = 1344
integer width = 343
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "cancel"
boolean cancel = true
end type

event clicked;close(parent)

end event

type cb_apply from commandbutton within w_options
integer x = 1499
integer y = 1344
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
string text = "apply"
end type

event clicked;int i
for i=1 to upperbound(uo_opt)
	uo_opt[i].of_apply()
next

this.enabled=false
cb_ok.enabled=false

end event

type cb_ok from commandbutton within w_options
integer x = 1111
integer y = 1344
integer width = 343
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
boolean enabled = false
string text = "ok"
boolean default = true
end type

event clicked;cb_apply.event clicked()
close(parent)

end event

type plb_1 from picturelistbox within w_options
integer x = 18
integer y = 16
integer width = 471
integer height = 1296
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
boolean sorted = false
borderstyle borderstyle = stylelowered!
long picturemaskcolor = 12632256
end type

event selectionchanged;int i
for i=1 to upperbound(uo_opt)
	uo_opt[i].visible=(index=i)
next

end event

