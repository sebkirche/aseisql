HA$PBExportHeader$uo_option_log.sru
forward
global type uo_option_log from uo_option_master
end type
type rb_err from radiobutton within uo_option_log
end type
type rb_any from radiobutton within uo_option_log
end type
type cbx_hide from checkbox within uo_option_log
end type
type gb_1 from groupbox within uo_option_log
end type
end forward

global type uo_option_log from uo_option_master
string text = "Log"
string picturename = "Output!"
rb_err rb_err
rb_any rb_any
cbx_hide cbx_hide
gb_1 gb_1
end type
global uo_option_log uo_option_log

on uo_option_log.create
int iCurrent
call super::create
this.rb_err=create rb_err
this.rb_any=create rb_any
this.cbx_hide=create cbx_hide
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_err
this.Control[iCurrent+2]=this.rb_any
this.Control[iCurrent+3]=this.cbx_hide
this.Control[iCurrent+4]=this.gb_1
end on

on uo_option_log.destroy
call super::destroy
destroy(this.rb_err)
destroy(this.rb_any)
destroy(this.cbx_hide)
destroy(this.gb_1)
end on

event ue_init;call super::ue_init;cbx_hide.checked=cfg.of_getoption( 'log.hide' )
rb_err.checked=cfg.of_getlong( cfg.is_options,'log.show.level',2 )=2
rb_any.checked=not rb_err.checked

end event

event ue_apply;call super::ue_apply;cfg.of_setoption( 'log.hide', cbx_hide.checked )
if rb_any.checked then cfg.of_setlong( cfg.is_options,'log.show.level',0 )
if rb_err.checked then cfg.of_setlong( cfg.is_options,'log.show.level',2 )
w_main.il_logshowlevel=cfg.of_getlong( cfg.is_options,'log.show.level',2 )

end event

type rb_err from radiobutton within uo_option_log
integer x = 617
integer y = 580
integer width = 343
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "On error"
boolean checked = true
end type

event clicked;of_change()

end event

type rb_any from radiobutton within uo_option_log
integer x = 617
integer y = 496
integer width = 567
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "On any message"
end type

event clicked;of_change()

end event

type cbx_hide from checkbox within uo_option_log
integer x = 626
integer y = 256
integer width = 759
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Hide log on start"
end type

event clicked;of_change()

end event

type gb_1 from groupbox within uo_option_log
integer x = 498
integer y = 416
integer width = 718
integer height = 288
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Automatically show log"
end type

