HA$PBExportHeader$w_progress.srw
forward
global type w_progress from window
end type
type hpb_1 from hprogressbar within w_progress
end type
end forward

global type w_progress from window
integer width = 1371
integer height = 140
boolean titlebar = true
string title = "Progress"
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 67108864
boolean palettewindow = true
hpb_1 hpb_1
end type
global w_progress w_progress

on w_progress.create
this.hpb_1=create hpb_1
this.Control[]={this.hpb_1}
end on

on w_progress.destroy
destroy(this.hpb_1)
end on

event resize;hpb_1.resize(newwidth,newheight)

end event

event open;f_centerwindow(this)

end event

type hpb_1 from hprogressbar within w_progress
integer width = 475
integer height = 52
unsignedinteger maxposition = 1000
integer setstep = 1
boolean smoothscroll = true
end type

