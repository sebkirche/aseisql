HA$PBExportHeader$uo_fonts.sru
forward
global type uo_fonts from dropdownlistbox
end type
end forward

global type uo_fonts from dropdownlistbox
integer width = 713
integer height = 576
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type
global uo_fonts uo_fonts

type prototypes
function boolean EnumerateFonts(long h)library "sciprint.dll"

end prototypes

event constructor;EnumerateFonts(handle(this))

end event

on uo_fonts.create
end on

on uo_fonts.destroy
end on

