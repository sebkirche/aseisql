HA$PBExportHeader$w_connect.srw
forward
global type w_connect from window
end type
type tab_1 from tab within w_connect
end type
type page_connect from userobject within tab_1
end type
type cbx_datenc from checkbox within page_connect
end type
type cbx_pwenc from checkbox within page_connect
end type
type ddlb_hostname from dropdownlistbox within page_connect
end type
type st_1 from statictext within page_connect
end type
type cb_1 from commandbutton within page_connect
end type
type cb_3 from commandbutton within page_connect
end type
type cb_ok from commandbutton within page_connect
end type
type ddplb_srv from dropdownpicturelistbox within page_connect
end type
type sle_login from singlelineedit within page_connect
end type
type sle_pass from singlelineedit within page_connect
end type
type st_10 from statictext within page_connect
end type
type st_9 from statictext within page_connect
end type
type st_8 from statictext within page_connect
end type
type st_7 from statictext within page_connect
end type
type sle_database from singlelineedit within page_connect
end type
type st_6 from statictext within page_connect
end type
type ddlb_charset from dropdownlistbox within page_connect
end type
type page_connect from userobject within tab_1
cbx_datenc cbx_datenc
cbx_pwenc cbx_pwenc
ddlb_hostname ddlb_hostname
st_1 st_1
cb_1 cb_1
cb_3 cb_3
cb_ok cb_ok
ddplb_srv ddplb_srv
sle_login sle_login
sle_pass sle_pass
st_10 st_10
st_9 st_9
st_8 st_8
st_7 st_7
sle_database sle_database
st_6 st_6
ddlb_charset ddlb_charset
end type
type page_profiles from userobject within tab_1
end type
type cb_6 from commandbutton within page_profiles
end type
type cb_5 from commandbutton within page_profiles
end type
type cb_4 from commandbutton within page_profiles
end type
type cb_2 from commandbutton within page_profiles
end type
type lv_1 from listview within page_profiles
end type
type page_profiles from userobject within tab_1
cb_6 cb_6
cb_5 cb_5
cb_4 cb_4
cb_2 cb_2
lv_1 lv_1
end type
type page_info from userobject within tab_1
end type
type mle_info from multilineedit within page_info
end type
type page_info from userobject within tab_1
mle_info mle_info
end type
type tab_1 from tab within w_connect
page_connect page_connect
page_profiles page_profiles
page_info page_info
end type
end forward

global type w_connect from window
integer width = 1993
integer height = 1592
boolean titlebar = true
string title = "Sybase ASE Logon"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
event ue_syb_dir pbm_custom05
event ue_syb_dir_info pbm_custom08
tab_1 tab_1
end type
global w_connect w_connect

type prototypes
function long sql_directory(long hwnd) LIBRARY "syb_exec.dll"

end prototypes

type variables

end variables

forward prototypes
public function string of_profilekey (readonly string uid, readonly string srv, readonly string db, readonly string cs)
public function boolean of_profiles (readonly string key2select)
public function boolean of_parse (string key, ref string uid, ref string srv, ref string db, ref string cs)
public subroutine of_info (string key, string value)
end prototypes

event ue_syb_dir;//
if lparam<>0 then 
	tab_1.page_connect.ddplb_srv.addItem(String(lparam,"address"),1)
end if

end event

event ue_syb_dir_info;//
if lparam<>0 and wparam<>0 then 
	of_info(String(wparam,"address"),String(lparam,"address"))
end if

end event

public function string of_profilekey (readonly string uid, readonly string srv, readonly string db, readonly string cs);string s

s=srv
if db>'' then s+='.'+db
if cs>'' then s+='/'+cs

if uid>'' then s=uid+'@'+s

return s

end function

public function boolean of_profiles (readonly string key2select);listview lv
string keys[]
string ls_pass,ls_uid,ls_srv,ls_db, ls_cs,s
listviewitem lvi

long i,count,pos,row


lv=tab_1.page_profiles.lv_1

lv.deleteitems( )

cfg.of_getkeys( 'profiles', keys)

count=upperbound(keys)
for i=1 to count
	ls_pass=f_crypt(cfg.of_getstring('profiles',keys[i]),false)
	
	of_parse(keys[i],ls_uid,ls_srv,ls_db,ls_cs)
	
	lvi.pictureindex=1
	lvi.label=of_profilekey('',ls_srv,ls_db,ls_cs)
	lvi.data=ls_pass
	
	row=lv.additem( lvi )
	lv.setitem( row, 2, ls_uid)
next

//sort list
lv.Sort ( Ascending! )


if key2select>'' then
	//find and select the item
	of_parse(key2select,ls_uid,ls_srv,ls_db,ls_cs)
	ls_srv=of_profilekey('',ls_srv,ls_db,ls_cs)
	row=0
	repeat:
	row=lv.FindItem ( row, ls_srv, false, false)
	if row>0 then
		lv.getItem(row,lvi)
		lvi.hasfocus=true
		lvi.selected=true
		lv.setItem(row,lvi)
		
		lv.getitem( row, 2, s)
		if s=ls_uid then return true
		goto repeat
	end if


end if

return true

end function

public function boolean of_parse (string key, ref string uid, ref string srv, ref string db, ref string cs);long pos

//get uid
pos=pos(key,'@')
if pos>0 then 
	uid=left(key, pos -1)
	key= mid(key, pos +1)
else
	uid=''
end if

//get cs
pos=pos(key,'/')
if pos>0 then 
	cs= mid(key, pos +1)
	key=left(key, pos -1)
else
	cs=''
end if

//get db
pos=pos(key,'.')
if pos>0 then 
	db= mid(key, pos +1)
	key=left(key, pos -1)
else
	db=''
end if

srv=key

return true

end function

public subroutine of_info (string key, string value);//
tab_1.page_info.mle_info.text+=key+':~t'+value+'~r~n'

end subroutine

on w_connect.create
this.tab_1=create tab_1
this.Control[]={this.tab_1}
end on

on w_connect.destroy
destroy(this.tab_1)
end on

event open;string srv,db,uid,pwd,host

sql_directory(Handle(this))

srv=sqlca.ServerName
pwd=sqlca.LogPass
db=sqlca.Database
uid=sqlca.LogId

if srv>'' and uid>'' and db>'' then
else
	srv=cfg.of_getString('connect','server',tab_1.page_connect.ddplb_srv.text(1))
	uid=cfg.of_getString('connect','login','')
	db=cfg.of_getString('connect','database','')
end if



tab_1.page_connect.ddplb_srv.selectItem(srv,0)
if tab_1.page_connect.ddplb_srv.text='' then tab_1.page_connect.ddplb_srv.selectItem(1)

tab_1.page_connect.sle_pass.text=pwd
tab_1.page_connect.sle_login.text=uid
tab_1.page_connect.ddlb_charset.text=sqlca.is_charset
tab_1.page_connect.cbx_pwenc.checked = ( sqlca.dbparm<>'' and pos(sqlca.dbparm,",PWEncrypt='No'")<1 )
if tab_1.page_connect.sle_login.text<>'' then tab_1.page_connect.sle_pass.post setFocus()

tab_1.page_connect.ddlb_hostname.text=cfg.of_gethostname()
host=cfg.of_getDefaultHostName()
tab_1.page_connect.ddlb_hostname.additem(host)
RegistryGet ( 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\lanmanserver\parameters', 'srvcomment', host )
tab_1.page_connect.ddlb_hostname.additem(host)

tab_1.page_connect.sle_database.text=db

tab_1.page_profiles.lv_1.post resize(tab_1.page_profiles.lv_1.width,tab_1.page_profiles.lv_1.height+5)

of_profiles('')

f_autosize(this)
f_centerWindow(this)
//-------------------

end event

type tab_1 from tab within w_connect
integer x = 9
integer y = 8
integer width = 1769
integer height = 928
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long backcolor = 67108864
boolean raggedright = true
integer selectedtab = 1
page_connect page_connect
page_profiles page_profiles
page_info page_info
end type

on tab_1.create
this.page_connect=create page_connect
this.page_profiles=create page_profiles
this.page_info=create page_info
this.Control[]={this.page_connect,&
this.page_profiles,&
this.page_info}
end on

on tab_1.destroy
destroy(this.page_connect)
destroy(this.page_profiles)
destroy(this.page_info)
end on

event selectionchanged;if newindex=1 then
	tab_1.page_connect.cb_ok.default=true
	tab_1.page_connect.cb_3.cancel=true
else
	tab_1.page_profiles.cb_2.default=true
	tab_1.page_profiles.cb_4.cancel=true
end if

end event

type page_connect from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 1733
integer height = 800
long backcolor = 67108864
string text = "Connection"
long tabtextcolor = 33554432
string picturename = "img\connect.ico"
long picturemaskcolor = 536870912
cbx_datenc cbx_datenc
cbx_pwenc cbx_pwenc
ddlb_hostname ddlb_hostname
st_1 st_1
cb_1 cb_1
cb_3 cb_3
cb_ok cb_ok
ddplb_srv ddplb_srv
sle_login sle_login
sle_pass sle_pass
st_10 st_10
st_9 st_9
st_8 st_8
st_7 st_7
sle_database sle_database
st_6 st_6
ddlb_charset ddlb_charset
end type

on page_connect.create
this.cbx_datenc=create cbx_datenc
this.cbx_pwenc=create cbx_pwenc
this.ddlb_hostname=create ddlb_hostname
this.st_1=create st_1
this.cb_1=create cb_1
this.cb_3=create cb_3
this.cb_ok=create cb_ok
this.ddplb_srv=create ddplb_srv
this.sle_login=create sle_login
this.sle_pass=create sle_pass
this.st_10=create st_10
this.st_9=create st_9
this.st_8=create st_8
this.st_7=create st_7
this.sle_database=create sle_database
this.st_6=create st_6
this.ddlb_charset=create ddlb_charset
this.Control[]={this.cbx_datenc,&
this.cbx_pwenc,&
this.ddlb_hostname,&
this.st_1,&
this.cb_1,&
this.cb_3,&
this.cb_ok,&
this.ddplb_srv,&
this.sle_login,&
this.sle_pass,&
this.st_10,&
this.st_9,&
this.st_8,&
this.st_7,&
this.sle_database,&
this.st_6,&
this.ddlb_charset}
end on

on page_connect.destroy
destroy(this.cbx_datenc)
destroy(this.cbx_pwenc)
destroy(this.ddlb_hostname)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.cb_3)
destroy(this.cb_ok)
destroy(this.ddplb_srv)
destroy(this.sle_login)
destroy(this.sle_pass)
destroy(this.st_10)
destroy(this.st_9)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.sle_database)
destroy(this.st_6)
destroy(this.ddlb_charset)
end on

type cbx_datenc from checkbox within page_connect
boolean visible = false
integer x = 905
integer y = 720
integer width = 411
integer height = 64
integer taborder = 92
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Encrypt &data"
end type

type cbx_pwenc from checkbox within page_connect
integer x = 347
integer y = 720
integer width = 553
integer height = 64
integer taborder = 91
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Encrypt &password"
end type

type ddlb_hostname from dropdownlistbox within page_connect
integer x = 347
integer y = 612
integer width = 965
integer height = 692
integer taborder = 90
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
boolean allowedit = true
boolean sorted = false
integer limit = 20
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within page_connect
integer x = 32
integer y = 620
integer width = 293
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Hostname :"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within page_connect
integer x = 1358
integer y = 488
integer width = 343
integer height = 92
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "Save Profile"
end type

event clicked;string key
string value

key=of_profilekey(tab_1.page_connect.sle_login.text, &
	tab_1.page_connect.ddplb_srv.text, &
	tab_1.page_connect.sle_database.text, &
	tab_1.page_connect.ddlb_charset.text )

value=''+char(1)
if tab_1.page_connect.cbx_pwenc.checked then 
	value+='1'
else
	value+='0'
end if
if tab_1.page_connect.cbx_datenc.checked then 
	value+='1'
else
	value+='0'
end if

value+=tab_1.page_connect.sle_pass.text

value=f_crypt(value,true)

cfg.of_setstring( 'profiles', key, value)

of_profiles(key)

tab_1.selecttab(2)

end event

type cb_3 from commandbutton within page_connect
integer x = 1358
integer y = 148
integer width = 343
integer height = 92
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "Cancel"
boolean cancel = true
end type

event clicked;close(w_connect)

end event

type cb_ok from commandbutton within page_connect
integer x = 1358
integer y = 36
integer width = 343
integer height = 92
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "&Connect"
boolean default = true
end type

event clicked;string host

cfg.of_setHostName(tab_1.page_connect.ddlb_hostname.text)

if not sqlca.of_connect(tab_1.page_connect.ddplb_srv.text, tab_1.page_connect.sle_database.text,&
		tab_1.page_connect.sle_login.text, tab_1.page_connect.sle_pass.text, tab_1.page_connect.ddlb_charset.text,&
		cfg.of_getHostName(), &
		tab_1.page_connect.cbx_pwenc.checked,tab_1.page_connect.cbx_datenc.checked) then return 0

cfg.of_setString('connect','server',tab_1.page_connect.ddplb_srv.text)
cfg.of_setString('connect','login',tab_1.page_connect.sle_login.text)
cfg.of_setString('connect','database',tab_1.page_connect.sle_database.text)

closeWithReturn(w_connect,1)

end event

type ddplb_srv from dropdownpicturelistbox within page_connect
integer x = 347
integer y = 372
integer width = 965
integer height = 692
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
string text = "none"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
string picturename[] = {"img\server.bmp"}
long picturemaskcolor = 16711935
end type

type sle_login from singlelineedit within page_connect
integer x = 347
integer y = 36
integer width = 965
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event getfocus;this.post selectText(1,1000)

end event

type sle_pass from singlelineedit within page_connect
integer x = 347
integer y = 148
integer width = 965
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
boolean password = true
borderstyle borderstyle = stylelowered!
end type

event getfocus;this.post selectText(1,1000)

end event

type st_10 from statictext within page_connect
integer x = 37
integer y = 48
integer width = 293
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Login :"
boolean focusrectangle = false
end type

type st_9 from statictext within page_connect
integer x = 37
integer y = 160
integer width = 293
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Password :"
boolean focusrectangle = false
end type

type st_8 from statictext within page_connect
integer x = 37
integer y = 384
integer width = 293
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Server :"
boolean focusrectangle = false
end type

type st_7 from statictext within page_connect
integer x = 37
integer y = 272
integer width = 293
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Database :"
boolean focusrectangle = false
end type

type sle_database from singlelineedit within page_connect
integer x = 347
integer y = 260
integer width = 965
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_6 from statictext within page_connect
integer x = 32
integer y = 504
integer width = 293
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Charset :"
boolean focusrectangle = false
end type

type ddlb_charset from dropdownlistbox within page_connect
integer x = 347
integer y = 496
integer width = 965
integer height = 332
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
boolean allowedit = true
integer limit = 30
string item[] = {"iso_1","cp1251","utf8","roman8"}
borderstyle borderstyle = stylelowered!
end type

type page_profiles from userobject within tab_1
integer x = 18
integer y = 112
integer width = 1733
integer height = 800
long backcolor = 67108864
string text = "Profiles"
long tabtextcolor = 33554432
string picturename = "img\profile.bmp"
long picturemaskcolor = 12632256
string powertiptext = "Connection Profiles"
cb_6 cb_6
cb_5 cb_5
cb_4 cb_4
cb_2 cb_2
lv_1 lv_1
end type

on page_profiles.create
this.cb_6=create cb_6
this.cb_5=create cb_5
this.cb_4=create cb_4
this.cb_2=create cb_2
this.lv_1=create lv_1
this.Control[]={this.cb_6,&
this.cb_5,&
this.cb_4,&
this.cb_2,&
this.lv_1}
end on

on page_profiles.destroy
destroy(this.cb_6)
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.cb_2)
destroy(this.lv_1)
end on

type cb_6 from commandbutton within page_profiles
integer x = 1358
integer y = 644
integer width = 343
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "&Delete"
end type

event clicked;long i
string s,uid,srv,db,cs
i=parent.lv_1.selectedIndex()

if i>0 then
	parent.lv_1.getItem(i,1,s)
	of_parse(s,uid,srv,db,cs)
	parent.lv_1.getItem(i,2,uid)
	
	s=of_profilekey(uid,srv,db,cs)
	cfg.of_deletekey('profiles',s)
	parent.lv_1.deleteitem(i)
end if

end event

type cb_5 from commandbutton within page_profiles
integer x = 1358
integer y = 532
integer width = 343
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "&Edit"
end type

event clicked;long i
listviewitem lvi
string s,uid,srv,db,cs
i=parent.lv_1.selectedIndex()

if i>0 then
	parent.lv_1.getItem(i,lvi)
	of_parse(lvi.label,uid,srv,db,cs)
	parent.lv_1.getItem(i,2,uid)
	
	tab_1.page_connect.sle_login.text=uid
	
	if mid(lvi.data,1,1)=char(1) then
		tab_1.page_connect.sle_pass.text=mid(lvi.data,4)
		tab_1.page_connect.cbx_pwenc.checked=mid(lvi.data,2,1)='1'
		tab_1.page_connect.cbx_datenc.checked=mid(lvi.data,3,1)='1'
	else
		tab_1.page_connect.sle_pass.text=lvi.data
		tab_1.page_connect.cbx_pwenc.checked=false
		tab_1.page_connect.cbx_datenc.checked=false
	end if
	
	tab_1.page_connect.sle_database.text=db
	tab_1.page_connect.ddplb_srv.selectitem( srv, 0)
	tab_1.page_connect.ddlb_charset.text=cs
	tab_1.selecttab(1)
end if

end event

type cb_4 from commandbutton within page_profiles
integer x = 1358
integer y = 148
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "Cancel"
boolean cancel = true
end type

event clicked;close(w_connect)

end event

type cb_2 from commandbutton within page_profiles
integer x = 1358
integer y = 36
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
string text = "&Connect"
boolean default = true
end type

event clicked;if parent.lv_1.selectedIndex()>0 then
	parent.cb_5.event clicked()
	tab_1.page_connect.cb_ok.post postevent(clicked!)
end if

end event

type lv_1 from listview within page_profiles
event ue_resize pbm_size
integer x = 18
integer y = 36
integer width = 1294
integer height = 700
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
boolean hideselection = false
boolean fullrowselect = true
listviewview view = listviewreport!
long largepicturemaskcolor = 536870912
long smallpicturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
end type

event ue_resize;int ww=4
int i,count

count=TotalColumns()

for i=1 to count -1
	ww+=PixelsToUnits(send(handle(this),4096+29/*LVM_GETCOLUMNWIDTH*/,i - 1,0),XPixelsToUnits!)
next

send(handle(this),4096+30/*LVM_SETCOLUMNWIDTH*/,count - 1,UnitsToPixels(max(10,newwidth - ww),XUnitsToPixels!))

end event

event constructor;this.addcolumn( 'Server', Left!, 850)
this.addcolumn( 'Login', Left!, 400)

end event

event key;if key=KeyDelete! then
	parent.cb_6.post event clicked()
end if

end event

event doubleclicked;parent.cb_5.post event clicked()

end event

type page_info from userobject within tab_1
integer x = 18
integer y = 112
integer width = 1733
integer height = 800
long backcolor = 67108864
string text = "Information"
long tabtextcolor = 33554432
string picturename = "img\info.gif"
long picturemaskcolor = 536870912
string powertiptext = "Information"
mle_info mle_info
end type

on page_info.create
this.mle_info=create mle_info
this.Control[]={this.mle_info}
end on

on page_info.destroy
destroy(this.mle_info)
end on

type mle_info from multilineedit within page_info
integer x = 27
integer y = 32
integer width = 1669
integer height = 696
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
boolean autovscroll = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

event constructor;this.tabstop[1]=12

end event

