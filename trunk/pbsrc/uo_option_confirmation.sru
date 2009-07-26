HA$PBExportHeader$uo_option_confirmation.sru
forward
global type uo_option_confirmation from uo_option_master
end type
type cbx_disconnect from checkbox within uo_option_confirmation
end type
end forward

global type uo_option_confirmation from uo_option_master
string text = "Confirmations"
string picturename = "Question!"
long picturemaskcolor = 12632256
cbx_disconnect cbx_disconnect
end type
global uo_option_confirmation uo_option_confirmation

type variables
boolean ib_prompt_expert=true

end variables

on uo_option_confirmation.create
int iCurrent
call super::create
this.cbx_disconnect=create cbx_disconnect
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_disconnect
end on

on uo_option_confirmation.destroy
call super::destroy
destroy(this.cbx_disconnect)
end on

event ue_init;call super::ue_init;cbx_disconnect.checked=cfg.ib_confirm_disconnect

end event

event ue_apply;call super::ue_apply;cfg.ib_confirm_disconnect=cbx_disconnect.checked

end event

type cbx_disconnect from checkbox within uo_option_confirmation
integer x = 526
integer y = 392
integer width = 736
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
string text = "Confirm server disconnect"
end type

event clicked;of_change()

end event

