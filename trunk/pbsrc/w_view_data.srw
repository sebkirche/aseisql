HA$PBExportHeader$w_view_data.srw
forward
global type w_view_data from window
end type
type st_1 from statictext within w_view_data
end type
type mle_data from uo_mle within w_view_data
end type
type cb_close from commandbutton within w_view_data
end type
end forward

global type w_view_data from window
integer width = 1550
integer height = 1056
boolean titlebar = true
string title = "View data"
boolean controlmenu = true
windowtype windowtype = popup!
long backcolor = 67108864
st_1 st_1
mle_data mle_data
cb_close cb_close
end type
global w_view_data w_view_data

forward prototypes
public subroutine of_set (readonly string s)
end prototypes

public subroutine of_set (readonly string s);mle_data.text=s
if isNull(s) then
	st_1.text='(null)'
else
	st_1.text=string(len(s))+' char(s)'
end if

end subroutine

on w_view_data.create
this.st_1=create st_1
this.mle_data=create mle_data
this.cb_close=create cb_close
this.Control[]={this.st_1,&
this.mle_data,&
this.cb_close}
end on

on w_view_data.destroy
destroy(this.st_1)
destroy(this.mle_data)
destroy(this.cb_close)
end on

event open;f_autosize(this)
f_centerwindow(this)

end event

type st_1 from statictext within w_view_data
integer x = 23
integer y = 760
integer width = 343
integer height = 60
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type mle_data from uo_mle within w_view_data
integer x = 23
integer y = 24
integer width = 1431
integer height = 728
integer taborder = 10
fontcharset fontcharset = defaultcharset!
string facename = "Microsoft Sans Serif"
string text = ""
boolean vscrollbar = true
boolean autovscroll = true
boolean displayonly = true
end type

type cb_close from commandbutton within w_view_data
integer x = 1216
integer y = 760
integer width = 238
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "Close"
boolean cancel = true
boolean default = true
end type

event clicked;close(parent)

end event

