HA$PBExportHeader$w_params.srw
forward
global type w_params from window
end type
type cb_cancel from commandbutton within w_params
end type
type cb_ok from commandbutton within w_params
end type
type dw_1 from datawindow within w_params
end type
end forward

global type w_params from window
integer width = 2423
integer height = 1200
boolean titlebar = true
string title = "Specify parameters"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
cb_cancel cb_cancel
cb_ok cb_ok
dw_1 dw_1
end type
global w_params w_params

on w_params.create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.dw_1=create dw_1
this.Control[]={this.cb_cancel,&
this.cb_ok,&
this.dw_1}
end on

on w_params.destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.dw_1)
end on

event open;datastore ds
ds=message.powerobjectparm
ds.sharedata(dw_1)
f_autosize(this)
f_centerwindow(this)

end event

type cb_cancel from commandbutton within w_params
integer x = 933
integer y = 440
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

type cb_ok from commandbutton within w_params
integer x = 571
integer y = 440
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

event clicked;if dw_1.acceptText()=1 then closeWithReturn(parent,1)

end event

type dw_1 from datawindow within w_params
integer x = 27
integer y = 24
integer width = 1815
integer height = 384
integer taborder = 10
string title = "none"
string dataobject = "d_params"
boolean border = false
boolean livescroll = true
end type

