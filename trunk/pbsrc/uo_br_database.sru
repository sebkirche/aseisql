HA$PBExportHeader$uo_br_database.sru
forward
global type uo_br_database from userobject
end type
type dw_search from datawindow within uo_br_database
end type
type sle_search from singlelineedit within uo_br_database
end type
type st_search from statictext within uo_br_database
end type
type tv_1 from uo_dynamic_tv within uo_br_database
end type
end forward

global type uo_br_database from userobject
integer width = 878
integer height = 1156
long backcolor = 67108864
long tabtextcolor = 33554432
string picturename = "Database!"
long picturemaskcolor = 12632256
string powertiptext = "Database"
event ue_init ( )
event resize pbm_size
event ue_changestatus ( )
dw_search dw_search
sle_search sle_search
st_search st_search
tv_1 tv_1
end type
global uo_br_database uo_br_database

type variables
long hUserTables
long hSystemTables
long hProcedures
long hViews
long hTypes

long hSearch
long hRoot
long il_maxsearch=15
boolean ib_filter=false

end variables

forward prototypes
public subroutine of_search ()
public subroutine of_search (readonly string s)
public subroutine of_popup ()
public function boolean of_retrieve ()
public function string of_getlike ()
public subroutine of_setfilter (boolean b)
public function string of_hide_dbo (readonly string s)
end prototypes

event ue_init();this.event ue_changestatus()
il_maxsearch=cfg.of_getlong(cfg.is_options,'search.limit',15)
of_setfilter(cfg.of_getoption('search.filter'))

end event

event resize;tv_1.move(0,0)

tv_1.resize(newwidth, newheight - sle_search.height)

sle_search.move(st_search.width,newheight - sle_search.height)
sle_search.width=newwidth - st_search.width

st_search.y=sle_search.y+(sle_search.height - st_search.height)/2

end event

event ue_changestatus();boolean con
boolean exec

exec=sqlca.ib_executing
con=sqlca.of_isconnected( )

treeviewItem tvi
tv_1.getItem(hroot,tvi)
if lower(sqlca.servername+'.'+sqlca.database)=lower(tvi.label) then
else
	this.of_retrieve()
end if

tv_1.enabled=con and not exec
sle_search.enabled=con and not exec
st_search.disabledlook=not con or exec


end event

public subroutine of_search ();long h,row,count
treeViewItem tvi
//string s

if len(trim(sle_search.text))>0 then
	if ib_filter then
		of_retrieve()
	else
		dw_search.settransobject(sqlca)
		dw_search.retrieve(of_getlike())
		count=dw_search.rowCount()
		//delete old search result root
		if hSearch<>0 then tv_1.deleteItem(hSearch)
		//create new one
		tvi.pictureIndex=10
		tvi.SelectedPictureIndex=10
		tvi.children=true
		tvi.expandedonce=true
		tvi.expanded=true
		tvi.data=''
		tvi.label='Search ('+string(min(count,il_maxsearch))
		if count>il_maxsearch then tvi.label+='+'
		tvi.label+=')'
		hSearch=tv_1.insertitemlast( 0, tvi)
		tvi.children=false
		//add result
		count=min(count,il_maxsearch)
		for row=1 to count
			tvi.data=dw_search.GetItemString(row,"type")
			tvi.label=of_hide_dbo( dw_search.GetItemString(row,"name") )
			tvi.pictureIndex=gn_sqlmenu.of_stype2int(tvi.data)
			tvi.SelectedPictureIndex=tvi.pictureIndex
			tv_1.insertitemlast( hSearch, tvi)
		next
		tv_1.selectItem(hSearch)
	end if
	tv_1.setFocus()
end if

end subroutine

public subroutine of_search (readonly string s);sle_search.text=s
of_search()

end subroutine

public subroutine of_popup ();long h
menu m
treeViewItem tvi

tv_1.setFocus()

h=tv_1.FindItem(CurrentTreeItem!,0)

if h>0 then
	tv_1.getItem(h,tvi)
	m=create menu
	if gn_sqlmenu.of_generatemenu(m,tvi.label,tvi.pictureindex,tvi.data,true) then
		tv_1.f_popmenu(m)
	end if
	gn_sqlmenu.of_freemenu(m)
	destroy m
end if

end subroutine

public function boolean of_retrieve ();long handle
treeviewItem tvi

//root=tv_1.FindItem(RootTreeItem!,0)
tv_1.getItem(hroot,tvi)
if not sqlca.of_isconnected() then
	tv_1.deleteItem(hroot)
	hRoot=tv_1.insertItemFirst( 0, 'not connected.', 1)
	return true
end if
if sqlca.ib_executing then
	if hroot<>-1 and hroot<>0 then return true
	hRoot=tv_1.insertItemFirst( 0, 'executing...', 1)
	return true
end if
tv_1.deleteItem(hroot)

tv_1.f_cleartreeviewitem( tvi )

tvi.pictureIndex=1
tvi.SelectedPictureIndex=1
tvi.children=true
tvi.data=''
tvi.label=sqlca.servername+'.'+sqlca.database

hroot=tv_1.insertitemfirst( 0, tvi)

tvi.pictureIndex=2
tvi.SelectedPictureIndex=3
tvi.children=true
tvi.data='U'
tvi.label='User Tables'
hUserTables=tv_1.insertitemlast( hroot, tvi)
tvi.data='S'
tvi.label='System Tables'
hSystemTables=tv_1.insertitemlast( hroot, tvi)
tvi.data='P'
tvi.label='Procedures'
hProcedures=tv_1.insertitemlast( hroot, tvi)
tvi.data='SF'
tvi.label=gn_sqlmenu.of_typename( gn_sqlmenu.of_stype2int(tvi.data) )
hProcedures=tv_1.insertitemlast( hroot, tvi)
tvi.data='TR'
tvi.label='Triggers'
hProcedures=tv_1.insertitemlast( hroot, tvi)
tvi.data='V'
tvi.label='Views'
hViews=tv_1.insertitemlast( hroot, tvi)
tvi.data='TYPE'
tvi.label='User Types'
hTypes=tv_1.insertitemlast( hroot, tvi)

tv_1.ExpandItem(hroot)
tv_1.SelectItem(hroot)

return true

end function

public function string of_getlike ();string s

if pos(sle_search.text,"'")>0 then sle_search.text=f_replaceall(sle_search.text,"'",'')

if match(sle_search.text,'[%\[\]]') then
	s=sle_search.text
else
	s='%'+f_replaceall(sle_search.text,'_','[_]')+'%'
end if

return s

end function

public subroutine of_setfilter (boolean b);ib_filter=b

if ib_filter then
	st_search.text='Filter :'
else
	st_search.text='Search :'
end if

end subroutine

public function string of_hide_dbo (readonly string s);if cfg.ib_hide_dbo then
	if left(s,4)='dbo.' then
		return mid(s,5)
	end if
end if
return s
end function

on uo_br_database.create
this.dw_search=create dw_search
this.sle_search=create sle_search
this.st_search=create st_search
this.tv_1=create tv_1
this.Control[]={this.dw_search,&
this.sle_search,&
this.st_search,&
this.tv_1}
end on

on uo_br_database.destroy
destroy(this.dw_search)
destroy(this.sle_search)
destroy(this.st_search)
destroy(this.tv_1)
end on

event destructor;cfg.of_setoption('search.filter',ib_filter)

end event

type dw_search from datawindow within uo_br_database
integer x = 91
integer y = 876
integer width = 686
integer height = 204
integer taborder = 30
string title = "none"
string dataobject = "d_search"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event retrieverow;
//retrieve only xx first rows
if row>il_maxsearch then return 1
return 0

end event

event constructor;this.visible=false

end event

type sle_search from singlelineedit within uo_br_database
event key pbm_keydown
integer x = 219
integer y = 692
integer width = 343
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
integer accelerator = 115
borderstyle borderstyle = stylelowered!
end type

event key;if key=KeyEnter! then
	of_search()
end if

end event

type st_search from statictext within uo_br_database
integer y = 704
integer width = 206
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 67108864
string text = "Search :"
boolean focusrectangle = false
end type

event clicked;of_setfilter(not ib_filter)
parent.of_retrieve()

end event

type tv_1 from uo_dynamic_tv within uo_br_database
integer x = 69
integer y = 52
integer width = 658
integer height = 604
integer taborder = 10
fontcharset fontcharset = ansi!
string facename = "Microsoft Sans Serif"
boolean hideselection = false
string picturename[] = {"DBConnect!","Custom039!","Custom050!","img\table.bmp","img\proc_g.bmp","img\view.bmp","Structure5!","PasteStatement!","Custom092!","img\search.gif","img\tablesys.bmp","UserObject!","img\trigger.bmp","img\func_g.bmp"}
long picturemaskcolor = 12632256
end type

event doubleclicked;call super::doubleclicked;parent.post of_popup()

end event

event key;call super::key;treeViewItem tvi
long h

if key=KeyF5! then
	parent.of_retrieve()
elseif key=KeyEnter! then
	parent.post of_popup()
elseif (key=KeyC! or key=KeyInsert!) and KeyDown(KeyControl!) then
	//copy item name
	h=this.FindItem(CurrentTreeItem!,0)
	if h>0 then
		tv_1.getItem(h,tvi)
		clipboard(tvi.label)
	end if
end if

end event

event rightclicked;call super::rightclicked;this.selectItem(handle)
parent.post of_popup()

end event

event db_prepare;call super::db_prepare;treeViewItem tvi
string ls_filter

if ib_filter then
	ls_filter=" and name like '"+of_getlike()+"' "
end if

CHOOSE CASE newlevel
	CASE 3
		getItem(parentHandle,tvi)
		CHOOSE CASE string(tvi.data)
			CASE 'U' /*User Tables*/
				query="select type,user_name(uid)+'.'+name from sysobjects where type='U' "+ls_filter+"order by 2"
			CASE 'S' /*System Tables*/
				query="select type,user_name(uid)+'.'+name from sysobjects where type='S' "+ls_filter+"order by 2"
			CASE 'P' /*Procedures*/
				query="select type,user_name(uid)+'.'+name from sysobjects where type='P' "+ls_filter+"order by 2"
			CASE 'SF' /*SQL Function*/
				query="select type,user_name(uid)+'.'+name from sysobjects where type='SF' "+ls_filter+"order by 2"
			CASE 'TR' /*Triggers*/
				query="select type,user_name(uid)+'.'+name from sysobjects where type='TR' "+ls_filter+"order by 2"
			CASE 'V' /*Views*/
				query="select type,user_name(uid)+'.'+name from sysobjects where type='V' "+ls_filter+"order by 2"
			CASE 'TYPE'
				query="select 'TYPE',name from systypes where usertype>100 "+ls_filter+"order by 2"
		END CHOOSE
END CHOOSE

end event

event db_retrieve_row;call super::db_retrieve_row;//

newitem.pictureindex=gn_sqlmenu.of_stype2int(string(outparm[1]))
newitem.selectedpictureindex=newitem.pictureindex
newitem.data=''
newitem.label=of_hide_dbo( outparm[2] )
newitem.children=false

end event

