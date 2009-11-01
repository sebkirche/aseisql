HA$PBExportHeader$w_export.srw
forward
global type w_export from window
end type
type st_4 from statictext within w_export
end type
type ddlb_group from dropdownlistbox within w_export
end type
type cb_sel_none from commandbutton within w_export
end type
type cb_sel_all from commandbutton within w_export
end type
type cb_3 from commandbutton within w_export
end type
type cb_2 from commandbutton within w_export
end type
type ddlb_enc from dropdownlistbox within w_export
end type
type st_3 from statictext within w_export
end type
type st_2 from statictext within w_export
end type
type st_1 from statictext within w_export
end type
type dw_1 from datawindow within w_export
end type
type cb_1 from commandbutton within w_export
end type
type sle_dir from singlelineedit within w_export
end type
end forward

global type w_export from window
integer width = 2043
integer height = 1392
boolean titlebar = true
string title = "Export Table Data"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_4 st_4
ddlb_group ddlb_group
cb_sel_none cb_sel_none
cb_sel_all cb_sel_all
cb_3 cb_3
cb_2 cb_2
ddlb_enc ddlb_enc
st_3 st_3
st_2 st_2
st_1 st_1
dw_1 dw_1
cb_1 cb_1
sle_dir sle_dir
end type
global w_export w_export

type variables
string is_mode

end variables

on w_export.create
this.st_4=create st_4
this.ddlb_group=create ddlb_group
this.cb_sel_none=create cb_sel_none
this.cb_sel_all=create cb_sel_all
this.cb_3=create cb_3
this.cb_2=create cb_2
this.ddlb_enc=create ddlb_enc
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.dw_1=create dw_1
this.cb_1=create cb_1
this.sle_dir=create sle_dir
this.Control[]={this.st_4,&
this.ddlb_group,&
this.cb_sel_none,&
this.cb_sel_all,&
this.cb_3,&
this.cb_2,&
this.ddlb_enc,&
this.st_3,&
this.st_2,&
this.st_1,&
this.dw_1,&
this.cb_1,&
this.sle_dir}
end on

on w_export.destroy
destroy(this.st_4)
destroy(this.ddlb_group)
destroy(this.cb_sel_none)
destroy(this.cb_sel_all)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.ddlb_enc)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.sle_dir)
end on

event open;this.is_mode=message.stringparm

f_autosize(this)
f_centerwindow(this)
if is_mode='sql' then
	dw_1.enabled=false
	cb_sel_all.enabled=false
	cb_sel_none.enabled=false
	dw_1.importstring( '1~tsql' )
	dw_1.modify("datawindow.color='67108864'")
else
	dw_1.setTransobject( sqlca )
	dw_1.retrieve( )
end if

sle_dir.text =cfg.of_getstring('options','export.directory','c:\')

ddlb_enc.text=cfg.of_getstring('options','export.encoding','UTF8')
ddlb_group.text=cfg.of_getstring('options','export.group.rows','100')
if ddlb_enc.finditem( ddlb_enc.text, 0)<1 then ddlb_enc.text='UTF8'

end event

type st_4 from statictext within w_export
integer x = 987
integer y = 1016
integer width = 457
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rows group by :"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_group from dropdownlistbox within w_export
integer x = 1449
integer y = 1004
integer width = 411
integer height = 324
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean sorted = false
string item[] = {"1","100","500","1000"}
borderstyle borderstyle = stylelowered!
end type

type cb_sel_none from commandbutton within w_export
integer x = 288
integer y = 288
integer width = 183
integer height = 68
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&none"
end type

event clicked;long i,count
count=dw_1.rowCount()
for i=1 to count
	dw_1.setItem(i,'checked',0)
next

end event

type cb_sel_all from commandbutton within w_export
integer x = 288
integer y = 212
integer width = 183
integer height = 68
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&all"
end type

event clicked;long i,count
count=dw_1.rowCount()
for i=1 to count
	dw_1.setItem(i,'checked',1)
next

end event

type cb_3 from commandbutton within w_export
integer x = 1527
integer y = 1124
integer width = 343
integer height = 92
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cancel"
boolean cancel = true
end type

event clicked;close(parent)

end event

type cb_2 from commandbutton within w_export
integer x = 1125
integer y = 1124
integer width = 343
integer height = 92
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Start"
boolean default = true
end type

event clicked;long i
string ls_tables

i=dw_1.RowCount()
if i>0 then i=dw_1.getitemNumber(i,'c_count')
if i<1 then 
	MessageBox(app().displayname, 'No tables selected to export data.',Exclamation!)
	return 0
end if

if pos('/\',right(sle_dir.text,1))<1 then sle_dir.text+='\'


if not DirectoryExists(sle_dir.text) then 
	if MessageBox(app().displayname, 'The specified directory does not exist.~r~nDo you want to create it ?',Exclamation!,YesNo!)=2 then return 0
	CreateDirectory(sle_dir.text)
	if not DirectoryExists(sle_dir.text) then 
		MessageBox(app().displayname, 'Error creating directory.',StopSign!)
		return 0
	end if
end if

cfg.of_options( true, 'export.encoding', ddlb_enc.text)
cfg.of_options( true, 'export.directory', sle_dir.text)
cfg.of_options( true, 'export.group.rows', ddlb_group.text)

for i=1 to dw_1.rowcount()
	if dw_1.getItemNumber(i,'checked')=1 then
		ls_tables+=dw_1.getItemString(i,'name')+'~t'
	end if
next

closeWithReturn(parent,ls_tables)

end event

type ddlb_enc from dropdownlistbox within w_export
boolean visible = false
integer x = 489
integer y = 1004
integer width = 462
integer height = 324
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean sorted = false
string item[] = {"ANSI","UTF8","UTF16"}
borderstyle borderstyle = stylelowered!
end type

event constructor;this.post show()

end event

type st_3 from statictext within w_export
integer x = 50
integer y = 1012
integer width = 421
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Output Encoding:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_export
integer x = 50
integer y = 144
integer width = 421
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Table List :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_export
integer x = 50
integer y = 44
integer width = 421
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Output Directory :"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_export
integer x = 489
integer y = 148
integer width = 1371
integer height = 836
integer taborder = 30
string title = "none"
string dataobject = "d_export_tables"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;this.setRowfocusindicator( FocusRect! )

end event

type cb_1 from commandbutton within w_export
integer x = 1737
integer y = 44
integer width = 123
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "..."
end type

event clicked;string s

s=sle_dir.text
if GetFolder ( 'Select Directory to store files', s )=1 then
	sle_dir.text=s
end if

end event

type sle_dir from singlelineedit within w_export
integer x = 489
integer y = 44
integer width = 1248
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

