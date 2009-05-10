HA$PBExportHeader$uo_option_editor.sru
forward
global type uo_option_editor from uo_option_master
end type
type ddlb_tabspace from dropdownlistbox within uo_option_editor
end type
type st_4 from statictext within uo_option_editor
end type
type cb_def from commandbutton within uo_option_editor
end type
type cbx_fold from checkbox within uo_option_editor
end type
type cbx_linenum from checkbox within uo_option_editor
end type
type cbx_indent from checkbox within uo_option_editor
end type
type cbx_sys from checkbox within uo_option_editor
end type
type st_5 from statictext within uo_option_editor
end type
type st_color from statictext within uo_option_editor
end type
type st_3 from statictext within uo_option_editor
end type
type cbx_italic from checkbox within uo_option_editor
end type
type cbx_bold from checkbox within uo_option_editor
end type
type st_2 from statictext within uo_option_editor
end type
type st_1 from statictext within uo_option_editor
end type
type lb_style from listbox within uo_option_editor
end type
type ddlb_size from dropdownlistbox within uo_option_editor
end type
type ddlb_font from uo_fonts within uo_option_editor
end type
type uo_e from uo_editpage within uo_option_editor
end type
type t_choosecolor from structure within uo_option_editor
end type
end forward

type t_choosecolor from structure
	unsignedlong		lstructsize
	unsignedlong		hwndOwner
	unsignedlong		hInstance
	unsignedlong		rgbResult
	blob		lpCustColors
	unsignedlong		Flags
	unsignedlong		lCustData
	unsignedlong		lpfnHook
	unsignedlong		lpTemplateName
end type

global type uo_option_editor from uo_option_master
string text = "Editor"
string picturename = "EditObject!"
ddlb_tabspace ddlb_tabspace
st_4 st_4
cb_def cb_def
cbx_fold cbx_fold
cbx_linenum cbx_linenum
cbx_indent cbx_indent
cbx_sys cbx_sys
st_5 st_5
st_color st_color
st_3 st_3
cbx_italic cbx_italic
cbx_bold cbx_bold
st_2 st_2
st_1 st_1
lb_style lb_style
ddlb_size ddlb_size
ddlb_font ddlb_font
uo_e uo_e
end type
global uo_option_editor uo_option_editor

type prototypes
function boolean EnumerateFonts(long h) library "sciprint.dll"
function boolean ChooseColor(ref t_choosecolor c) library "comdlg32.dll" alias for "ChooseColorW"

end prototypes

type variables
private t_choosecolor it_color

end variables

forward prototypes
public subroutine of_setstyle ()
public subroutine of_showstyle ()
end prototypes

public subroutine of_setstyle ();long i
i=lb_style.selectedindex( )

uo_e.styledef[i] = st_color.BackColor
if cbx_italic.checked then uo_e.styledef[i] += uo_e.il_italic
if cbx_bold.checked then uo_e.styledef[i] += uo_e.il_bold

if cbx_sys.checked then 
	uo_e.styledef[i] = -1
	st_color.backcolor =uo_e.of_getcolor( i )
end if

uo_e.is_fontface=ddlb_font.text
uo_e.ii_fontsize=long(ddlb_size.text)


uo_e.ib_show_fold=cbx_fold.checked
uo_e.ib_show_indent=cbx_indent.checked
uo_e.ib_show_linenum=cbx_linenum.checked

uo_e.ii_tabspace=long(ddlb_tabspace.text)

uo_e.of_colorize( )

of_change()

end subroutine

public subroutine of_showstyle ();ddlb_font.text=uo_e.is_fontface
ddlb_size.text=string(uo_e.ii_fontsize)

cbx_fold.checked=uo_e.ib_show_fold
cbx_indent.checked=uo_e.ib_show_indent
cbx_linenum.checked=uo_e.ib_show_linenum

ddlb_tabspace.text=string(uo_e.ii_tabspace)

end subroutine

on uo_option_editor.create
int iCurrent
call super::create
this.ddlb_tabspace=create ddlb_tabspace
this.st_4=create st_4
this.cb_def=create cb_def
this.cbx_fold=create cbx_fold
this.cbx_linenum=create cbx_linenum
this.cbx_indent=create cbx_indent
this.cbx_sys=create cbx_sys
this.st_5=create st_5
this.st_color=create st_color
this.st_3=create st_3
this.cbx_italic=create cbx_italic
this.cbx_bold=create cbx_bold
this.st_2=create st_2
this.st_1=create st_1
this.lb_style=create lb_style
this.ddlb_size=create ddlb_size
this.ddlb_font=create ddlb_font
this.uo_e=create uo_e
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_tabspace
this.Control[iCurrent+2]=this.st_4
this.Control[iCurrent+3]=this.cb_def
this.Control[iCurrent+4]=this.cbx_fold
this.Control[iCurrent+5]=this.cbx_linenum
this.Control[iCurrent+6]=this.cbx_indent
this.Control[iCurrent+7]=this.cbx_sys
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.st_color
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.cbx_italic
this.Control[iCurrent+12]=this.cbx_bold
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.st_1
this.Control[iCurrent+15]=this.lb_style
this.Control[iCurrent+16]=this.ddlb_size
this.Control[iCurrent+17]=this.ddlb_font
this.Control[iCurrent+18]=this.uo_e
end on

on uo_option_editor.destroy
call super::destroy
destroy(this.ddlb_tabspace)
destroy(this.st_4)
destroy(this.cb_def)
destroy(this.cbx_fold)
destroy(this.cbx_linenum)
destroy(this.cbx_indent)
destroy(this.cbx_sys)
destroy(this.st_5)
destroy(this.st_color)
destroy(this.st_3)
destroy(this.cbx_italic)
destroy(this.cbx_bold)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.lb_style)
destroy(this.ddlb_size)
destroy(this.ddlb_font)
destroy(this.uo_e)
end on

event ue_init;call super::ue_init;string s
long i

s+='/*the comments*/~r~n'
s+='--line comments~r~n'
s+='	if @row=0 begin~r~n'
s+='		select 125 from dummy~r~n'
s+='		select "string #1"~r~n'
s+='		select ~'string #2~'~r~n'
s+='	end~r~n'
s+='if (@i=0~r~n'

uo_e.of_init( "", uo_e.typeedit , 0, "")

uo_e.uo_edit.of_send( uo_e.uo_edit.SCI_SETTEXT, 0, s)
uo_e.uo_edit.of_send( uo_e.uo_edit.SCI_SETREADONLY, 1, 0)
uo_e.resize(uo_e.width+5,uo_e.height+5)


for i=1 to uo_e.il_stylecount
	lb_style.addItem(uo_e.stylename[i])
next

it_color.lstructsize=36
it_color.Flags=3
it_color.hwndOwner=handle(this)
it_color.lpCustColors=blob( space(64) )

for i=1 to 16
	BlobEdit ( it_color.lpCustColors, (i - 1)*4 +1, rgb(255,255,255) )
next

of_showstyle()

end event

event ue_apply;call super::ue_apply;uo_e.of_stylestore( )
w_main.of_updateview()

end event

type ddlb_tabspace from dropdownlistbox within uo_option_editor
integer x = 1211
integer y = 968
integer width = 146
integer height = 324
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
string item[] = {"3","4","5","6","7","8","9","10","11","12"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;of_setStyle()

end event

type st_4 from statictext within uo_option_editor
integer x = 864
integer y = 976
integer width = 325
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tab Space:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_def from commandbutton within uo_option_editor
integer x = 1312
integer y = 1152
integer width = 343
integer height = 92
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "defaults"
end type

event clicked;uo_e.of_styleload(true)
of_showstyle()
lb_style.selectitem(1)
lb_style.event selectionchanged(1)
of_change()

end event

type cbx_fold from checkbox within uo_option_editor
integer x = 105
integer y = 1136
integer width = 613
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show fold margin"
end type

event clicked;of_setStyle()

end event

type cbx_linenum from checkbox within uo_option_editor
integer x = 105
integer y = 1056
integer width = 626
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show line numbers"
end type

event clicked;of_setStyle()

end event

type cbx_indent from checkbox within uo_option_editor
integer x = 105
integer y = 976
integer width = 453
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show Indent"
end type

event clicked;of_setStyle()

end event

type cbx_sys from checkbox within uo_option_editor
integer x = 1266
integer y = 744
integer width = 366
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Use system"
end type

event clicked;of_setStyle()

end event

type st_5 from statictext within uo_option_editor
integer x = 119
integer y = 840
integer width = 293
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Font:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_color from statictext within uo_option_editor
integer x = 457
integer y = 744
integer width = 174
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
boolean enabled = false
alignment alignment = right!
boolean border = true
borderstyle borderstyle = styleraised!
end type

event clicked;it_color.rgbresult=this.BackColor
BlobEdit ( it_color.lpCustColors, (16 - 1)*4 +1, this.BackColor )

if ChooseColor(it_color) then
	cbx_sys.checked=(this.BackColor=it_color.rgbresult)and cbx_sys.checked
	this.BackColor=it_color.rgbresult
	of_setstyle()
end if

end event

type st_3 from statictext within uo_option_editor
integer x = 206
integer y = 748
integer width = 215
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Color:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_italic from checkbox within uo_option_editor
integer x = 704
integer y = 744
integer width = 261
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
boolean enabled = false
string text = "Italic"
end type

event clicked;of_setstyle()

end event

type cbx_bold from checkbox within uo_option_editor
integer x = 969
integer y = 744
integer width = 261
integer height = 64
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Bold"
end type

event clicked;of_setstyle()

end event

type st_2 from statictext within uo_option_editor
integer x = 1330
integer y = 12
integer width = 343
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Style:"
boolean focusrectangle = false
end type

type st_1 from statictext within uo_option_editor
integer x = 27
integer y = 12
integer width = 498
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Preview:"
boolean focusrectangle = false
end type

type lb_style from listbox within uo_option_editor
integer x = 1326
integer y = 68
integer width = 352
integer height = 652
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
boolean vscrollbar = true
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;long il_syscolor
st_color.enabled=true
if uo_e.stylemap[index]<0 then
	cbx_italic.enabled=false
	cbx_bold.enabled=false
	cbx_sys.enabled=true
	
	cbx_italic.checked=false
	cbx_bold.checked=  false
	
	cbx_sys.checked=uo_e.styledef[index]=-1
	st_color.BackColor=uo_e.of_getcolor( index )
else
	cbx_italic.enabled=true
	cbx_bold.enabled=true
	cbx_sys.enabled=false
	
	cbx_italic.checked= f_and(uo_e.styledef[index], uo_e.il_italic  )<>0
	cbx_bold.checked  = f_and(uo_e.styledef[index], uo_e.il_bold    )<>0
	cbx_sys.checked   = false
	st_color.BackColor= f_and(uo_e.styledef[index], uo_e.il_bold - 1)
end if

end event

type ddlb_size from dropdownlistbox within uo_option_editor
event selendok pbm_cbnselendok
integer x = 1211
integer y = 832
integer width = 146
integer height = 544
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
string item[] = {"8","9","10","11","12","13","14"}
borderstyle borderstyle = stylelowered!
end type

event selendok;post of_setStyle()

end event

type ddlb_font from uo_fonts within uo_option_editor
event selendok pbm_cbnselendok
integer x = 434
integer y = 832
integer height = 544
integer taborder = 50
end type

event selendok;post of_setStyle()

end event

type uo_e from uo_editpage within uo_option_editor
integer x = 23
integer y = 68
integer height = 652
integer taborder = 70
boolean ib_enable_context_menu = false
end type

on uo_e.destroy
call uo_editpage::destroy
end on

event scn_updateui;call super::scn_updateui;//
long i

i=uo_e.uo_edit.of_send( uo_e.uo_edit.SCI_GETCURRENTPOS  ,0 , 0)
i=uo_e.uo_edit.of_send( uo_e.uo_edit.SCI_GETSTYLEAT     ,i , 0)

lb_style.selectitem(i+1)
lb_style.event selectionchanged(i+1)
end event

