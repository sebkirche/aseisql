HA$PBExportHeader$uo_option_resultset.sru
forward
global type uo_option_resultset from uo_option_master
end type
type ddlb_format_dt from dropdownlistbox within uo_option_resultset
end type
type st_4 from statictext within uo_option_resultset
end type
type st_3 from statictext within uo_option_resultset
end type
type ddlb_size from uo_ddlb_fontsize within uo_option_resultset
end type
type ddlb_font from uo_fonts within uo_option_resultset
end type
type st_2 from statictext within uo_option_resultset
end type
type sle_null from singlelineedit within uo_option_resultset
end type
type st_1 from statictext within uo_option_resultset
end type
type cbx_sql from checkbox within uo_option_resultset
end type
type uo_rs from uo_resultset_grid within uo_option_resultset
end type
end forward

global type uo_option_resultset from uo_option_master
string text = "ResultSet"
string picturename = "DataWindow!"
ddlb_format_dt ddlb_format_dt
st_4 st_4
st_3 st_3
ddlb_size ddlb_size
ddlb_font ddlb_font
st_2 st_2
sle_null sle_null
st_1 st_1
cbx_sql cbx_sql
uo_rs uo_rs
end type
global uo_option_resultset uo_option_resultset

on uo_option_resultset.create
int iCurrent
call super::create
this.ddlb_format_dt=create ddlb_format_dt
this.st_4=create st_4
this.st_3=create st_3
this.ddlb_size=create ddlb_size
this.ddlb_font=create ddlb_font
this.st_2=create st_2
this.sle_null=create sle_null
this.st_1=create st_1
this.cbx_sql=create cbx_sql
this.uo_rs=create uo_rs
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_format_dt
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.ddlb_size
this.Control[iCurrent+5]=this.ddlb_font
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.sle_null
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.cbx_sql
this.Control[iCurrent+10]=this.uo_rs
end on

on uo_option_resultset.destroy
call super::destroy
destroy(this.ddlb_format_dt)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.ddlb_size)
destroy(this.ddlb_font)
destroy(this.st_2)
destroy(this.sle_null)
destroy(this.st_1)
destroy(this.cbx_sql)
destroy(this.uo_rs)
end on

event ue_init;call super::ue_init;//uo_rs.of_init( /*readonly string as_name*/, /*long al_type*/, /*long al_objtype*/, /*readonly string as_tooltip */)
uo_rs.of_init( "", uo_rs.typers , 0, "")
uo_rs.of_sybexec_resultset(0,3)
uo_rs.of_setsql( 'select * from dummy~r~n' )
uo_rs.of_sybexec_setfield(1,'Column 1')
uo_rs.of_sybexec_setfield(2,'Column 2')
uo_rs.of_sybexec_setfield(3,'Column 3')

uo_rs.resize(uo_rs.width+5,uo_rs.height) //to be sure of resize
uo_rs.ib_displayonly=true
uo_rs.of_sybexec_newrow(1)
uo_rs.of_sybexec_setfield(1,'1')
uo_rs.of_sybexec_setfield(2,'$$HEX4$$3004310432043304$$ENDHEX$$')
uo_rs.of_sybexec_setfield(3,'$$HEX4$$e800e900ea00eb00$$ENDHEX$$')
uo_rs.of_sybexec_newrow(2)
uo_rs.of_sybexec_setfield(1,'2')
uo_rs.of_sybexec_setfield(2,'xxx')
uo_rs.of_sybexec_setfield(3,'www')
uo_rs.of_sybexec_newrow(3)
uo_rs.of_sybexec_setfield(1,'3')
uo_rs.of_sybexec_setfield(2,'fff')
uo_rs.of_sybexec_setfield(3,'')

cbx_sql.checked=cfg.of_getoption(cfg.is_showrssql)
sle_null.text=cfg.of_getstring(cfg.is_options, cfg.is_nullstr )
//uo_rs.of_updateview()

ddlb_font.text=cfg.is_resultset_font_name
ddlb_size.text=string(cfg.il_resultset_font_size)

ddlb_format_dt.selectItem(cfg.il_format_datetime)


end event

event ue_apply;call super::ue_apply;uo_rs.of_storecfg( )
w_main.of_updateview()

cfg.is_resultset_font_name=ddlb_font.text
cfg.il_resultset_font_size=long(ddlb_size.text)
cfg.il_format_datetime=ddlb_format_dt.findItem(ddlb_format_dt.text,0)
cfg.of_options( true )

end event

type ddlb_format_dt from dropdownlistbox within uo_option_resultset
integer x = 471
integer y = 1128
integer width = 622
integer height = 324
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean sorted = false
string item[] = {"[native]","yyyy-mm-dd hh:mm:ss","yyyy-mm-dd hh:mm:ss.fff"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;of_change()

end event

type st_4 from statictext within uo_option_resultset
integer x = 50
integer y = 1132
integer width = 379
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "DateTime format:"
boolean focusrectangle = false
end type

type st_3 from statictext within uo_option_resultset
integer x = 1102
integer y = 1008
integer width = 608
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "( applied on new resultset) "
boolean focusrectangle = false
end type

type ddlb_size from uo_ddlb_fontsize within uo_option_resultset
integer x = 937
integer y = 996
integer taborder = 30
end type

event selectionchanged;call super::selectionchanged;of_change()

end event

type ddlb_font from uo_fonts within uo_option_resultset
integer x = 206
integer y = 996
integer taborder = 20
end type

event selectionchanged;call super::selectionchanged;of_change()
st_3.facename =this.text

end event

type st_2 from statictext within uo_option_resultset
integer x = 50
integer y = 1008
integer width = 151
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Font:"
boolean focusrectangle = false
end type

type sle_null from singlelineedit within uo_option_resultset
event change pbm_enchange
integer x = 1298
integer y = 896
integer width = 343
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event change;long i

uo_rs.of_sybexec_setfield(3,this.text)
uo_rs.is_nullvalue=this.text

of_change()

end event

type st_1 from statictext within uo_option_resultset
integer x = 827
integer y = 908
integer width = 466
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Substitute Null with: "
boolean focusrectangle = false
end type

type cbx_sql from checkbox within uo_option_resultset
integer x = 55
integer y = 904
integer width = 750
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
string text = "Show SQL in resultset"
end type

event clicked;uo_rs.of_showsql( this.checked )
of_change()

end event

type uo_rs from uo_resultset_grid within uo_option_resultset
integer x = 165
integer y = 52
integer width = 1353
integer height = 808
integer taborder = 30
boolean border = true
borderstyle borderstyle = styleraised!
end type

on uo_rs.destroy
call uo_resultset_grid::destroy
end on

