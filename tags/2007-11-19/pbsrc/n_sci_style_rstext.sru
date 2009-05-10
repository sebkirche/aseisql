HA$PBExportHeader$n_sci_style_rstext.sru
forward
global type n_sci_style_rstext from n_sci_style
end type
end forward

global type n_sci_style_rstext from n_sci_style
end type

on n_sci_style_rstext.create
call super::create
end on

on n_sci_style_rstext.destroy
call super::destroy
end on

event ue_init;call super::ue_init;this.is_cfg_section='resultset.text'
this.ii_tabspace=1

this.of_define( 0,   "Data",       0,                false, false)
this.of_define( 1,   "Header",     0,                true,  false)
this.of_define( 2,   "Message",    rgb(0,128,0),     false, true )
this.of_define( 3,   "Error",      rgb(128,0,0),     false, true )
this.of_define(-1,   "Background", -1,               false, false)
this.of_define(-2,   "Select FG",  -1,               false, false)
this.of_define(-3,   "Select BG",  -1,               false, false)

end event

