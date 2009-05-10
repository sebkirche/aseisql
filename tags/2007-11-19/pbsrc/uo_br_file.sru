HA$PBExportHeader$uo_br_file.sru
forward
global type uo_br_file from userobject
end type
type tv_1 from uo_dynamic_tv within uo_br_file
end type
type lb_1 from listbox within uo_br_file
end type
end forward

global type uo_br_file from userobject
integer width = 704
integer height = 992
long backcolor = 67108864
long tabtextcolor = 33554432
string picturename = "TreeView!"
long picturemaskcolor = 12632256
string powertiptext = "File roots"
event resize pbm_size
event ue_init ( )
event ue_openfile ( )
event ue_fold_explore ( )
event ue_root_edit ( )
event ue_root_del ( )
tv_1 tv_1
lb_1 lb_1
end type
global uo_br_file uo_br_file

type prototypes

end prototypes

type variables
boolean ib_busy=false

end variables

forward prototypes
public function boolean of_init (long h)
public function boolean of_popup ()
end prototypes

event resize;tv_1.resize(newwidth,newheight)

end event

event ue_init();//
tv_1.of_insertitemlast( 0, 'File roots', '', 1, 1)
of_init(0)

end event

event ue_openfile();long h
treeviewitem tvi
h=message.wordparm

if tv_1.getItem(h,tvi)=1 then
	w_main.of_openfile(tvi.data,false,0)
end if

end event

event ue_fold_explore();long h
treeviewitem tvi
h=message.wordparm

if tv_1.getItem(h,tvi)=1 then
	run('explorer.exe '+tvi.data)
end if

end event

event ue_root_edit();n_hashtable parm
long h
treeviewitem tvi


h=message.wordparm
parm=create n_hashtable
if h<>0 then
	tv_1.getItem(h,tvi)
	parm.of_set('name',tvi.label)
	parm.of_set('path',string(tvi.data))
end if

OpenWithParm(w_froot,parm)

if parm.of_get( 'ok', false) then
	if h<>0 then
		//delete old data
		cfg.of_setstring('froots.def',tvi.label,'')
	end if
	//create new data
	cfg.of_setstring('froots.def',parm.of_get('name',''),parm.of_get('path',''))
	of_init(tv_1.findItem(rootTreeItem!,0))
end if

destroy parm

end event

event ue_root_del();long h,i
treeviewitem tvi


h=message.wordparm
if h<>0 then
	tv_1.getItem(h,tvi)
	i=MessageBox(app().displayname,'Are you sure you want to delete '+tvi.label+'~r~n from your view ?',Exclamation!,YesNoCancel!)
	if i=1 then
		cfg.of_setstring('froots.def',tvi.label,'')
		tv_1.deleteitem( h )
	end if
end if

end event

public function boolean of_init (long h);long root,i
string ls_roots[],s
treeviewitem tvi

if ib_busy then return true
ib_busy=true


if h=0 or h=-1 then h=tv_1.f_getcurrenthandle( )
if h=0 or h=-1 then h=tv_1.findItem(RootTreeItem!,0)
if h=0 or h=-1 then goto fin

tv_1.getitem( h, tvi)
if tvi.pictureindex=5 then
	h=tv_1.findItem(ParentTreeItem!,h)
	if h=0 or h=-1 then goto fin
	tv_1.getitem( h, tvi)
end if
tv_1.f_deletechildren( h)
tv_1.getitem( h, tvi)
if tvi.level=1 then
	cfg.of_getkeys( 'froots.def', ls_roots)
	for i=1 to upperbound(ls_roots)
		s=cfg.of_getstring('froots.def',ls_roots[i])
		if s<>'' then
			tv_1.of_insertitemlast( h, ls_roots[i], cfg.of_getstring('froots.def',ls_roots[i]) , 2, 2, true)
		end if
	next
	
	tv_1.selectItem(h)
	tv_1.expandItem(h)
	goto fin
end if

if tvi.level>1 and tvi.pictureindex<>5 then
	boolean b
	lb_1.reset( )
	lb_1.dirlist( ''+tvi.data+'\*.*', 16+32768) //dir
	for i=1 to lb_1.Totalitems( )
		s=lb_1.text(i)
		s=mid(s,2,len(s)-2)
		if s='..' then continue
		tv_1.of_insertitemlast( h, s, ''+tvi.data+'\'+s, 3, 4, true)
		b=true
	next
	lb_1.dirlist( ''+tvi.data+'\*.*', 0) //files
	for i=1 to lb_1.Totalitems( )
		s=lb_1.text(i)
		tv_1.of_insertitemlast( h, s, ''+tvi.data+'\'+s, 5, 5, false)
		b=true
	next
	if not b then 
		tvi.children=false
		tv_1.setItem( h, tvi)
	end if
end if

fin:
ib_busy=false
return true

end function

public function boolean of_popup ();long h
m_dynamic m
treeViewItem tvi

tv_1.setFocus()

h=tv_1.f_getcurrentitem( tvi )
if h>0 then
	m=create m_dynamic
	
	if tvi.level=1 then
		m.of_additem( 'New file root', true, this, 'ue_root_edit', 0, '')
	elseif tvi.level=2 then
		m.of_additem( 'Explore here', true, this, 'ue_fold_explore', h, '')
		m.of_additem( '-', true, this, '', 0, '')
		m.of_additem( 'Edit file root', true, this, 'ue_root_edit', h, '')
		m.of_additem( 'Delete file root', true, this, 'ue_root_del', h, '')
		
	else
		if tvi.pictureindex=5 then
			m.of_additem( 'Open file', true, this, 'ue_openfile', h, '')
			//file
		else
			m.of_additem( 'Explore here', true, this, 'ue_fold_explore', h, '')
			//folder
		end if
	end if
	
	tv_1.f_popmenu(m)
	destroy m
end if
return true

end function

on uo_br_file.create
this.tv_1=create tv_1
this.lb_1=create lb_1
this.Control[]={this.tv_1,&
this.lb_1}
end on

on uo_br_file.destroy
destroy(this.tv_1)
destroy(this.lb_1)
end on

type tv_1 from uo_dynamic_tv within uo_br_file
integer taborder = 10
boolean hideselection = false
string picturename[] = {"TreeView!","Sort!","Custom039!","Custom050!","ScriptYes!"}
long picturemaskcolor = 12632256
end type

event itempopulate;of_init(handle)

end event

event doubleclicked;call super::doubleclicked;treeViewItem tvi
if tv_1.getitem( handle, tvi )=1 then
	if tvi.pictureindex=5 then
		parent.postevent('ue_openfile',handle,0)
	end if
end if

end event

event key;call super::key;if key=KeyF5! then
	parent.post of_init(0)
elseif key=KeyEnter! then
	parent.post of_popup()
end if

end event

event rightclicked;call super::rightclicked;selectItem(handle)
parent.of_popup()

end event

type lb_1 from listbox within uo_br_file
boolean visible = false
integer x = 169
integer y = 392
integer width = 411
integer height = 352
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

