HA$PBExportHeader$w_procexec.srw
forward
global type w_procexec from window
end type
type uo_1 from uo_editpage within w_procexec
end type
type cb_1 from commandbutton within w_procexec
end type
type cb_cancel from commandbutton within w_procexec
end type
end forward

global type w_procexec from window
integer width = 2459
integer height = 1512
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
uo_1 uo_1
cb_1 cb_1
cb_cancel cb_cancel
end type
global w_procexec w_procexec

type variables
n_hashtable in_parm

end variables

on w_procexec.create
this.uo_1=create uo_1
this.cb_1=create cb_1
this.cb_cancel=create cb_cancel
this.Control[]={this.uo_1,&
this.cb_1,&
this.cb_cancel}
end on

on w_procexec.destroy
destroy(this.uo_1)
destroy(this.cb_1)
destroy(this.cb_cancel)
end on

event open;
in_parm=message.powerobjectparm

title=app().displayname+in_parm.of_get( 'title', '' )

uo_1.of_init( "", uo_1.typeedit , 0, "")

//uo_1.uo_edit.of_send( uo_1.uo_edit.SCI_SETTEXT, 0, s)
uo_1.height+=5 //trigger resize

uo_1.of_settext( in_parm.of_get( 'text', '' ) )

f_autosize(this)
f_centerwindow(this)
uo_1.of_setfocus( )

end event

type uo_1 from uo_editpage within w_procexec
integer x = 18
integer y = 20
integer width = 2066
integer height = 1192
integer taborder = 10
end type

on uo_1.destroy
call uo_editpage::destroy
end on

type cb_1 from commandbutton within w_procexec
integer x = 1367
integer y = 1236
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "&Exec"
boolean default = true
end type

event clicked;in_parm.of_set( 'text', uo_1.of_gettext() )
in_parm.of_set( 'ok', true )
close(parent)
end event

type cb_cancel from commandbutton within w_procexec
integer x = 1742
integer y = 1236
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

event clicked;close(parent)

end event

