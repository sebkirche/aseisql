HA$PBExportHeader$w_browser.srw
forward
global type w_browser from window
end type
type tab_1 from tab within w_browser
end type
type page_db from uo_br_database within tab_1
end type
type page_db from uo_br_database within tab_1
end type
type page_st from uo_br_stubs within tab_1
end type
type page_st from uo_br_stubs within tab_1
end type
type page_fi from uo_br_file within tab_1
end type
type page_fi from uo_br_file within tab_1
end type
type page_dbg from uo_br_debug within tab_1
end type
type page_dbg from uo_br_debug within tab_1
end type
type tab_1 from tab within w_browser
page_db page_db
page_st page_st
page_fi page_fi
page_dbg page_dbg
end type
type cb_close from commandbutton within w_browser
end type
type rect from structure within w_browser
end type
end forward

type rect from structure
	long		left
	long		top
	long		right
	long		bottom
end type

global type w_browser from window
boolean visible = false
integer width = 1061
integer height = 1828
boolean titlebar = true
string title = "Object Browser"
boolean controlmenu = true
boolean resizable = true
windowtype windowtype = popup!
long backcolor = 67108864
boolean palettewindow = true
event syscommand pbm_syscommand
event ue_changestatus ( )
tab_1 tab_1
cb_close cb_close
end type
global w_browser w_browser

type prototypes
function boolean SetWindowPos(long hWnd,long hWndInsertAfter,long _X,long _Y,long cx,long cy,ulong uFlags) library "user32.dll"
function long SendMessage(long _hWnd, long Msg,long wParam,ref rect lParam) library "user32.dll" alias for "SendMessageW"
function long SetFocus(long _hWnd) library "user32.dll"

end prototypes

type variables
long hUserTables
long hSystemTables
long hProcedures
long hViews
long hTypes

long hSearch
long hStubs

//long il_maxsearch=15

end variables

forward prototypes
public subroutine of_search (readonly string s)
end prototypes

event syscommand;if commandtype=61536 /*SC_CLOSE*/ then 
	this.hide()
	message.processed=true
	return 1
end if

return 0

end event

event ue_changestatus();tab_1.page_db.event ue_changestatus()
tab_1.page_dbg.triggerevent('ue_changestatus')

end event

public subroutine of_search (readonly string s);tab_1.selecttab( 1 )
tab_1.page_db.of_search(s)

end subroutine

on w_browser.create
this.tab_1=create tab_1
this.cb_close=create cb_close
this.Control[]={this.tab_1,&
this.cb_close}
end on

on w_browser.destroy
destroy(this.tab_1)
destroy(this.cb_close)
end on

event open;boolean lb_show
lb_show=message.stringparm<>'hide'

cfg.of_restorepos ( this )
SetWindowPos(handle(this),/*HWND_NOTOPMOST*/-2,0,0,0,0,1+2)

long tcm_first=4864
//set tabpages smaller
Send(handle(tab_1),tcm_first+43,0,196612)

//tab_1.selectTab(1)

int i
for i=1 to upperbound(tab_1.control)
	tab_1.control[i].triggerevent('ue_init')
next

if lb_show then this.show()


if lb_show and tab_1.page_db.tv_1.enabled then
	tab_1.page_db.tv_1.post setFocus()
end if

end event

event close;cfg.of_savepos ( this )

end event

event resize;tab_1.move(0,0)
tab_1.resize(newwidth, newheight)

end event

event systemkey;if key=Key3! then cb_close.event clicked()

end event

event show;if tab_1.selectedtab=1 then
	tab_1.page_db.tv_1.setFocus()
end if

end event

type tab_1 from tab within w_browser
integer x = 64
integer y = 80
integer width = 823
integer height = 1252
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long backcolor = 67108864
boolean raggedright = true
boolean powertips = true
tabposition tabposition = tabsonbottom!
integer selectedtab = 1
page_db page_db
page_st page_st
page_fi page_fi
page_dbg page_dbg
end type

on tab_1.create
this.page_db=create page_db
this.page_st=create page_st
this.page_fi=create page_fi
this.page_dbg=create page_dbg
this.Control[]={this.page_db,&
this.page_st,&
this.page_fi,&
this.page_dbg}
end on

on tab_1.destroy
destroy(this.page_db)
destroy(this.page_st)
destroy(this.page_fi)
destroy(this.page_dbg)
end on

type page_db from uo_br_database within tab_1
integer x = 18
integer y = 16
integer width = 786
integer height = 1124
end type

type page_st from uo_br_stubs within tab_1
integer x = 18
integer y = 16
integer width = 786
integer height = 1124
end type

type page_fi from uo_br_file within tab_1
integer x = 18
integer y = 16
integer width = 786
integer height = 1124
end type

type page_dbg from uo_br_debug within tab_1
integer x = 18
integer y = 16
integer width = 786
integer height = 1124
end type

type cb_close from commandbutton within w_browser
event ue_focus pbm_setfocus
integer x = 219
integer width = 169
integer height = 108
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "&Close"
boolean cancel = true
end type

event ue_focus;parent.post SetFocus(message.WordParm)

end event

event clicked;parent.hide()

end event

