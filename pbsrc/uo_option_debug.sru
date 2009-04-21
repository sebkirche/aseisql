HA$PBExportHeader$uo_option_debug.sru
forward
global type uo_option_debug from uo_option_master
end type
type st_1 from statictext within uo_option_debug
end type
type cbx_expert from checkbox within uo_option_debug
end type
type cbx_row from checkbox within uo_option_debug
end type
type cbx_log from checkbox within uo_option_debug
end type
end forward

global type uo_option_debug from uo_option_master
string text = "Debug"
string picturename = "Debug!"
long picturemaskcolor = 12632256
st_1 st_1
cbx_expert cbx_expert
cbx_row cbx_row
cbx_log cbx_log
end type
global uo_option_debug uo_option_debug

type variables
boolean ib_prompt_expert=true

end variables

on uo_option_debug.create
int iCurrent
call super::create
this.st_1=create st_1
this.cbx_expert=create cbx_expert
this.cbx_row=create cbx_row
this.cbx_log=create cbx_log
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cbx_expert
this.Control[iCurrent+3]=this.cbx_row
this.Control[iCurrent+4]=this.cbx_log
end on

on uo_option_debug.destroy
call super::destroy
destroy(this.st_1)
destroy(this.cbx_expert)
destroy(this.cbx_row)
destroy(this.cbx_log)
end on

event ue_init;call super::ue_init;cbx_row.checked=cfg.ib_debug_correctrow
cbx_log.checked=cfg.ib_debug_log
cbx_expert.checked=cfg.ib_debug_expert

end event

event ue_apply;call super::ue_apply;cfg.ib_debug_correctrow=cbx_row.checked
cfg.ib_debug_log=cbx_log.checked
cfg.ib_debug_expert=cbx_expert.checked
cfg.of_options( true )

w_browser.tab_1.page_dbg.uo_menu.of_hide(4,not cfg.ib_debug_expert)

end event

type st_1 from statictext within uo_option_debug
integer x = 178
integer y = 128
integer width = 1303
integer height = 252
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 134217751
long backcolor = 134217752
boolean enabled = false
alignment alignment = center!
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

event constructor;string cr='~r~n'
this.text="If sybase debugger works without any problems,"+cr
this.text+="you don't need none of those settings."+cr
this.text+="BUT..."+cr
end event

type cbx_expert from checkbox within uo_option_debug
integer x = 105
integer y = 692
integer width = 1536
integer height = 64
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show ~"debug commands~" in browser (Expert mode)"
end type

event clicked;
if checked then
	if ib_prompt_expert then
		if MessageBox(app().displayname,'This option only for the case if you need to send debugger commands to the server manually.~r~nOnly for experts! No real documentation available.~r~n~r~nAre you sure you need it?',Exclamation!,YesNo!)=2 then
			checked=false
			return
		else
			ib_prompt_expert=false
		end if
	end if
end if
of_change()

end event

type cbx_row from checkbox within uo_option_debug
integer x = 105
integer y = 612
integer width = 1550
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
string text = "Auto correct row number (null ended lines not counted by sybase)"
end type

event clicked;of_change()

end event

type cbx_log from checkbox within uo_option_debug
integer x = 105
integer y = 768
integer width = 1253
integer height = 64
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Log debug commands sent to server"
end type

event clicked;of_change()

end event

