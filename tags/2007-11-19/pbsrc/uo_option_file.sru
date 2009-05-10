HA$PBExportHeader$uo_option_file.sru
forward
global type uo_option_file from uo_option_master
end type
type rb_utf8 from radiobutton within uo_option_file
end type
type rb_ansi from radiobutton within uo_option_file
end type
type cbx_1 from checkbox within uo_option_file
end type
type gb_1 from groupbox within uo_option_file
end type
end forward

global type uo_option_file from uo_option_master
string text = "File"
string picturename = "DosEdit!"
long picturemaskcolor = 12632256
rb_utf8 rb_utf8
rb_ansi rb_ansi
cbx_1 cbx_1
gb_1 gb_1
end type
global uo_option_file uo_option_file

on uo_option_file.create
int iCurrent
call super::create
this.rb_utf8=create rb_utf8
this.rb_ansi=create rb_ansi
this.cbx_1=create cbx_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_utf8
this.Control[iCurrent+2]=this.rb_ansi
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.gb_1
end on

on uo_option_file.destroy
call super::destroy
destroy(this.rb_utf8)
destroy(this.rb_ansi)
destroy(this.cbx_1)
destroy(this.gb_1)
end on

event ue_apply;call super::ue_apply;cfg.of_setoption('save.on.exec',cbx_1.checked)
w_main.ib_saveonexec=cbx_1.checked

cfg.ib_encoding_default_uft8=rb_utf8.checked
cfg.of_options( true )

end event

event ue_init;call super::ue_init;cbx_1.checked=cfg.of_getoption('save.on.exec')

rb_ansi.checked=not cfg.ib_encoding_default_uft8
rb_utf8.checked=cfg.ib_encoding_default_uft8

end event

type rb_utf8 from radiobutton within uo_option_file
integer x = 585
integer y = 920
integer width = 343
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "UTF8"
end type

event clicked;of_change()

end event

type rb_ansi from radiobutton within uo_option_file
integer x = 585
integer y = 840
integer width = 343
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "ANSI"
end type

event clicked;of_change()

end event

type cbx_1 from checkbox within uo_option_file
integer x = 453
integer y = 532
integer width = 869
integer height = 64
integer taborder = 1
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Save file on execute (if changed)"
end type

event clicked;of_change()

end event

type gb_1 from groupbox within uo_option_file
integer x = 443
integer y = 732
integer width = 837
integer height = 324
integer taborder = 11
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "File autodetect encoding priority"
end type

