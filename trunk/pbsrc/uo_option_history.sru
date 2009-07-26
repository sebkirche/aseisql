HA$PBExportHeader$uo_option_history.sru
forward
global type uo_option_history from uo_option_master
end type
type st_1 from statictext within uo_option_history
end type
type cb_log from commandbutton within uo_option_history
end type
type sle_log from singlelineedit within uo_option_history
end type
type cbx_log from checkbox within uo_option_history
end type
end forward

global type uo_option_history from uo_option_master
string text = "History"
string picturename = "ToDoList!"
long picturemaskcolor = 12632256
st_1 st_1
cb_log cb_log
sle_log sle_log
cbx_log cbx_log
end type
global uo_option_history uo_option_history

type variables
boolean ib_prompt_expert=true

end variables

on uo_option_history.create
int iCurrent
call super::create
this.st_1=create st_1
this.cb_log=create cb_log
this.sle_log=create sle_log
this.cbx_log=create cbx_log
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_log
this.Control[iCurrent+3]=this.sle_log
this.Control[iCurrent+4]=this.cbx_log
end on

on uo_option_history.destroy
call super::destroy
destroy(this.st_1)
destroy(this.cb_log)
destroy(this.sle_log)
destroy(this.cbx_log)
end on

event ue_init;call super::ue_init;cbx_log.checked=cfg.ib_history_log
sle_log.text=cfg.is_history_log_file

sle_log.enabled=cbx_log.checked
cb_log.enabled=cbx_log.checked

end event

event ue_apply;call super::ue_apply;cfg.ib_history_log=cbx_log.checked
cfg.is_history_log_file=sle_log.text

end event

type st_1 from statictext within uo_option_history
integer x = 155
integer y = 80
integer width = 1371
integer height = 148
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 134217751
long backcolor = 134217752
string text = "none"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

event constructor;this.text ="Warning!~r~n"
this.text+="The size of the log file not controlled by ASEISQL.~r~n"

end event

type cb_log from commandbutton within uo_option_history
integer x = 1408
integer y = 408
integer width = 123
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
boolean enabled = false
string text = "..."
end type

event clicked;string filename
if GetFileSaveName ( app().displayname+' - Select SQL History file', sle_log.text, filename, 'sql')=1 then
	of_change()
end if


end event

type sle_log from singlelineedit within uo_option_history
event uo_change pbm_enchange
integer x = 151
integer y = 408
integer width = 1248
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event uo_change;of_change()

end event

type cbx_log from checkbox within uo_option_history
integer x = 151
integer y = 320
integer width = 887
integer height = 64
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Log sql commands into the file :"
end type

event clicked;of_change()
sle_log.enabled=cbx_log.checked
cb_log.enabled=cbx_log.checked

end event

