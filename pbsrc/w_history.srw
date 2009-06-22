HA$PBExportHeader$w_history.srw
forward
global type w_history from window
end type
type cb_cancel from commandbutton within w_history
end type
type cb_ok from commandbutton within w_history
end type
type plb_1 from picturelistbox within w_history
end type
type mle_1 from uo_mle within w_history
end type
end forward

global type w_history from window
integer width = 2729
integer height = 1304
boolean titlebar = true
string title = "History"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
event ue_init ( )
cb_cancel cb_cancel
cb_ok cb_ok
plb_1 plb_1
mle_1 mle_1
end type
global w_history w_history

type variables
string is_histo[]

end variables

event ue_init();//
long i,count
char mru[]

mru=history.of_getmru()

count=upperbound(mru)
plb_1.reset()

for i=1 to count
	is_histo[i]=cfg.of_getText('history.'+mru[i],'')
	plb_1.addItem(f_remove_space(left(is_histo[i],70)),1)
next

if count>0 then
	plb_1.selectItem(1)
	mle_1.text=is_histo[1]
	cb_ok.enabled=true
end if

end event

on w_history.create
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.plb_1=create plb_1
this.mle_1=create mle_1
this.Control[]={this.cb_cancel,&
this.cb_ok,&
this.plb_1,&
this.mle_1}
end on

on w_history.destroy
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.plb_1)
destroy(this.mle_1)
end on

event open;f_autosize(this)
f_centerwindow(this)


this.event ue_init()
end event

type cb_cancel from commandbutton within w_history
integer x = 2331
integer y = 1080
integer width = 347
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "close"
boolean cancel = true
end type

event clicked;close(parent)

end event

type cb_ok from commandbutton within w_history
integer x = 1952
integer y = 1080
integer width = 347
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
boolean enabled = false
string text = "paste"
boolean default = true
end type

event clicked;long i,count
String s=""

count=plb_1.TotalItems()
for i=1 to count
	if plb_1.State(i)=1 then
		//remove selected item from the history
		if len(s)>0 then s+="~n"
		s+=is_histo[i]
	end if
next



closeWithReturn(parent,s)

end event

type plb_1 from picturelistbox within w_history
event keydown pbm_keydown
integer x = 14
integer y = 12
integer width = 1221
integer height = 1056
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
boolean vscrollbar = true
boolean sorted = false
borderstyle borderstyle = stylelowered!
boolean extendedselect = true
string picturename[] = {"Query!"}
long picturemaskcolor = 12632256
end type

event keydown;//
long i,count
if key=KeyDelete! and this.TotalSelected()>0 then
	if f_confirm("Are you sure you want to delete selected history items ?") then
		count=this.TotalItems()
		for i=1 to count
			if this.State(i)=1 then
				//remove selected item from the history
				history.of_delete(is_histo[i])
			end if
		next
		//no need to clear is_histo. cause upperbound not used anywhere
		//reinitialize
		parent.event ue_init()
	end if
end if


end event

event selectionchanged;mle_1.text=is_histo[index]

end event

event doubleclicked;if index>0 then cb_ok.post event clicked()

end event

type mle_1 from uo_mle within w_history
integer x = 1243
integer y = 12
integer width = 1435
integer height = 1056
integer taborder = 50
long backcolor = 76585128
string text = ""
boolean vscrollbar = true
boolean autovscroll = true
boolean displayonly = true
end type

