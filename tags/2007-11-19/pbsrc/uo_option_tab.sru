HA$PBExportHeader$uo_option_tab.sru
forward
global type uo_option_tab from uo_option_master
end type
type cbx_wrap from checkbox within uo_option_tab
end type
type tab_1 from tab within uo_option_tab
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_1 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_2 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tabpage_4 from userobject within tab_1
end type
type tabpage_4 from userobject within tab_1
end type
type tabpage_5 from userobject within tab_1
end type
type tabpage_5 from userobject within tab_1
end type
type tab_1 from tab within uo_option_tab
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type
end forward

global type uo_option_tab from uo_option_master
string text = "Tab"
string picturename = "Tab!"
cbx_wrap cbx_wrap
tab_1 tab_1
end type
global uo_option_tab uo_option_tab

on uo_option_tab.create
int iCurrent
call super::create
this.cbx_wrap=create cbx_wrap
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_wrap
this.Control[iCurrent+2]=this.tab_1
end on

on uo_option_tab.destroy
call super::destroy
destroy(this.cbx_wrap)
destroy(this.tab_1)
end on

event ue_init;call super::ue_init;cbx_wrap.checked=cfg.of_getoption(cfg.is_WrapPages)

tab_1.multiline=cbx_wrap.checked

end event

event ue_apply;call super::ue_apply;cfg.of_setoption(cfg.is_WrapPages,cbx_wrap.checked)
w_main.of_updateview()

end event

type cbx_wrap from checkbox within uo_option_tab
integer x = 571
integer y = 892
integer width = 599
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
string text = "Wrap pages"
end type

event clicked;tab_1.multiline=cbx_wrap.checked
of_change()

end event

type tab_1 from tab within uo_option_tab
integer x = 389
integer y = 152
integer width = 896
integer height = 568
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long backcolor = 67108864
boolean multiline = true
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 208
integer width = 859
integer height = 344
long backcolor = 67108864
string text = "page 1"
long tabtextcolor = 33554432
string picturename = "Query5!"
long picturemaskcolor = 536870912
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 208
integer width = 859
integer height = 344
long backcolor = 67108864
string text = "page 2"
long tabtextcolor = 33554432
string picturename = "Cursor!"
long picturemaskcolor = 12632256
end type

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 208
integer width = 859
integer height = 344
long backcolor = 67108864
string text = "page 3"
long tabtextcolor = 33554432
string picturename = "SelectReturn!"
long picturemaskcolor = 12632256
end type

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 208
integer width = 859
integer height = 344
long backcolor = 67108864
string text = "page 4"
long tabtextcolor = 33554432
string picturename = "SelectReturn!"
long picturemaskcolor = 12632256
end type

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 208
integer width = 859
integer height = 344
long backcolor = 67108864
string text = "page 5"
long tabtextcolor = 33554432
string picturename = "SelectReturn!"
long picturemaskcolor = 12632256
end type

