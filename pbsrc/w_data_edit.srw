HA$PBExportHeader$w_data_edit.srw
forward
global type w_data_edit from window
end type
type cbx_null from checkbox within w_data_edit
end type
type cb_2 from commandbutton within w_data_edit
end type
type cb_1 from commandbutton within w_data_edit
end type
type mle_1 from multilineedit within w_data_edit
end type
end forward

global type w_data_edit from window
integer x = 0
integer y = 0
integer width = 1600
integer height = 1120
boolean enabled = true
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = false
boolean maxbox = false
boolean hscrollbar = false
boolean vscrollbar = false
boolean resizable = false
boolean border = true
windowtype windowtype = response!
windowstate windowstate = normal!
long backcolor = 67108864
string icon = "AppIcon!"
integer unitsperline = 0
integer linesperpage = 0
integer unitspercolumn = 0
integer columnsperpage = 0
boolean bringtotop = false
boolean toolbarvisible = true
toolbaralignment toolbaralignment = alignattop!
integer toolbarx = 0
integer toolbary = 0
integer toolbarwidth = 0
integer toolbarheight = 0
boolean righttoleft = false
boolean keyboardicon = true
boolean clientedge = false
boolean palettewindow = false
boolean contexthelp = false
boolean center = true
cbx_null cbx_null
cb_2 cb_2
cb_1 cb_1
mle_1 mle_1
end type
global w_data_edit w_data_edit

type variables
n_hashtable h

end variables

on w_data_edit.create
this.cbx_null=create cbx_null
this.cb_2=create cb_2
this.cb_1=create cb_1
this.mle_1=create mle_1
this.Control[]={this.cbx_null,&
this.cb_2,&
this.cb_1,&
this.mle_1}
end on

on w_data_edit.destroy
destroy(this.cbx_null)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.mle_1)
end on

event open;string s

h=message.powerobjectparm
this.title=app().displayname+' '+h.of_get('title','')
s=h.of_get('value','')
cbx_null.checked=isNull(s)
mle_1.text=s
mle_1.enabled=not cbx_null.checked

f_autosize(this)
f_centerwindow(this)

end event

type cbx_null from checkbox within w_data_edit
integer x = 27
integer y = 732
integer width = 343
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
string text = "&Null"
end type

event clicked;mle_1.enabled=not checked

end event

type cb_2 from commandbutton within w_data_edit
integer x = 1184
integer y = 728
integer width = 343
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "Cancel"
boolean cancel = true
end type

event clicked;close(parent)

end event

type cb_1 from commandbutton within w_data_edit
integer x = 818
integer y = 728
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "Set"
boolean default = true
end type

event clicked;//
string s

if cbx_null.checked then
	setnull(s)
else
	s=mle_1.text
end if

h.of_set('value',s)
h.of_set('ok',true)
close(parent)

end event

type mle_1 from multilineedit within w_data_edit
integer x = 27
integer y = 24
integer width = 1499
integer height = 684
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
boolean vscrollbar = true
boolean autovscroll = true
borderstyle borderstyle = stylelowered!
boolean ignoredefaultbutton = true
end type

