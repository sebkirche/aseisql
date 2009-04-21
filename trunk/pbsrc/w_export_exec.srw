HA$PBExportHeader$w_export_exec.srw
forward
global type w_export_exec from window
end type
type st_info from statictext within w_export_exec
end type
type st_4 from statictext within w_export_exec
end type
type ddlb_group from dropdownlistbox within w_export_exec
end type
type cb_3 from commandbutton within w_export_exec
end type
type cb_2 from commandbutton within w_export_exec
end type
type ddlb_enc from dropdownlistbox within w_export_exec
end type
type st_3 from statictext within w_export_exec
end type
type st_1 from statictext within w_export_exec
end type
type cb_1 from commandbutton within w_export_exec
end type
type sle_dir from singlelineedit within w_export_exec
end type
end forward

global type w_export_exec from window
integer width = 2053
integer height = 1472
boolean titlebar = true
string title = "Export Table Data"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_info st_info
st_4 st_4
ddlb_group ddlb_group
cb_3 cb_3
cb_2 cb_2
ddlb_enc ddlb_enc
st_3 st_3
st_1 st_1
cb_1 cb_1
sle_dir sle_dir
end type
global w_export_exec w_export_exec

on w_export_exec.create
this.st_info=create st_info
this.st_4=create st_4
this.ddlb_group=create ddlb_group
this.cb_3=create cb_3
this.cb_2=create cb_2
this.ddlb_enc=create ddlb_enc
this.st_3=create st_3
this.st_1=create st_1
this.cb_1=create cb_1
this.sle_dir=create sle_dir
this.Control[]={this.st_info,&
this.st_4,&
this.ddlb_group,&
this.cb_3,&
this.cb_2,&
this.ddlb_enc,&
this.st_3,&
this.st_1,&
this.cb_1,&
this.sle_dir}
end on

on w_export_exec.destroy
destroy(this.st_info)
destroy(this.st_4)
destroy(this.ddlb_group)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.ddlb_enc)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.sle_dir)
end on

event open;f_autosize(this)
f_centerwindow(this)

sle_dir.text =cfg.of_getstring('options','export.directory','c:\')

ddlb_enc.text=cfg.of_getstring('options','export.encoding','UTF8')
ddlb_group.text=cfg.of_getstring('options','export.group.rows','100')
if ddlb_enc.finditem( ddlb_enc.text, 0)<1 then ddlb_enc.text='UTF8'

end event

type st_info from statictext within w_export_exec
integer x = 489
integer y = 208
integer width = 1358
integer height = 692
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

event constructor;this.text=" &
You have to use for browse clause to have valid table name.&
Column aliaces will be column names.&
"

end event

type st_4 from statictext within w_export_exec
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

type ddlb_group from dropdownlistbox within w_export_exec
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

type cb_3 from commandbutton within w_export_exec
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

type cb_2 from commandbutton within w_export_exec
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



closeWithReturn(parent,ls_tables)

end event

type ddlb_enc from dropdownlistbox within w_export_exec
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

type st_3 from statictext within w_export_exec
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

type st_1 from statictext within w_export_exec
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

type cb_1 from commandbutton within w_export_exec
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

type sle_dir from singlelineedit within w_export_exec
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

