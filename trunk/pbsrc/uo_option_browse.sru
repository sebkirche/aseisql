HA$PBExportHeader$uo_option_browse.sru
forward
global type uo_option_browse from uo_option_master
end type
type st_1 from statictext within uo_option_browse
end type
type em_1 from editmask within uo_option_browse
end type
end forward

global type uo_option_browse from uo_option_master
string text = "Browser"
string picturename = "BrowseObject!"
st_1 st_1
em_1 em_1
end type
global uo_option_browse uo_option_browse

on uo_option_browse.create
int iCurrent
call super::create
this.st_1=create st_1
this.em_1=create em_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.em_1
end on

on uo_option_browse.destroy
call super::destroy
destroy(this.st_1)
destroy(this.em_1)
end on

event ue_init;call super::ue_init;em_1.text=string(cfg.of_getlong(cfg.is_options,'search.limit',15))

end event

event ue_apply;call super::ue_apply;long i
i=long(em_1.text)
if i<2 then i=2
cfg.of_setlong(cfg.is_options,'search.limit',i)
if isValid(w_browser) then
	w_browser.tab_1.page_db.il_maxsearch=i
end if

end event

type st_1 from statictext within uo_option_browse
integer x = 379
integer y = 396
integer width = 512
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Object search limit:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_1 from editmask within uo_option_browse
event change pbm_enchange
integer x = 919
integer y = 388
integer width = 169
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
string text = "0"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "##0"
end type

event change;of_change()

end event

