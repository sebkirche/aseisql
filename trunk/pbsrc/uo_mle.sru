HA$PBExportHeader$uo_mle.sru
forward
global type uo_mle from multilineedit
end type
end forward

global type uo_mle from multilineedit
integer width = 608
integer height = 360
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
event keydown pbm_keydown
end type
global uo_mle uo_mle

event keydown;if keyflags=2 and (key=KeyInsert! or key=KeyC!) then
	this.copy()
end if
return 0

end event

on uo_mle.create
end on

on uo_mle.destroy
end on

