HA$PBExportHeader$uo_br_stubs.sru
forward
global type uo_br_stubs from userobject
end type
type tv_1 from uo_dynamic_tv within uo_br_stubs
end type
end forward

global type uo_br_stubs from userobject
integer width = 704
integer height = 796
long backcolor = 67108864
long tabtextcolor = 33554432
string picturename = "PasteStatement!"
long picturemaskcolor = 12632256
string powertiptext = "Stubs"
event ue_init ( )
event resize pbm_size
tv_1 tv_1
end type
global uo_br_stubs uo_br_stubs

type variables

end variables

forward prototypes
public function boolean of_addstub (long root, readonly string as_name, readonly string as_text)
public function boolean of_addstubs (readonly string file)
public subroutine of_popup ()
private function long of_getlist (readonly string as_word, long h, readonly datastore items, boolean ab_exact)
public function boolean of_isfolder (readonly string s)
public subroutine of_addlistitem (readonly datastore items, readonly string as_item, long al_handle)
public function integer of_getlist (readonly string as_word, ref string as_ret, boolean ab_select)
end prototypes

event ue_init();tv_1.deleteItem(tv_1.findItem(RootTreeItem!,0))
of_addstubs('stubs.sql')
of_addstubs('ustubs.sql')

end event

event resize;tv_1.move(0,0)
tv_1.resize(newwidth,newheight)

end event

public function boolean of_addstub (long root, readonly string as_name, readonly string as_text);long count,i,h,hsch
string names[]
treeviewitem tvi

if trim(as_name)='' then return false

//count=f_gettokens(name,'\',names)
count=gf_parsestring(as_name,'\',names,false)

if count=0 then return false

h=root
for i=1 to count
	//look for item with the same name
	hsch=tv_1.findItem(ChildTreeItem!,h)
	do while hsch<>-1
		tv_1.getItem(hsch,tvi)
		if lower(tvi.label)=lower(trim(names[i])) then exit
		hsch=tv_1.findItem(NextTreeItem!,hsch)
	loop
	
	if hsch=-1 then
		h=tv_1.of_insertitemlast( h, trim(names[i]), '',2,3)
	else
		h=hsch
	end if
next

if len(as_text)>0 then
	tv_1.getItem(h,tvi)
	tvi.data=as_text
	tvi.pictureindex=gn_sqlmenu.typeStubs
	tvi.selectedpictureindex=gn_sqlmenu.typeStubs
	tv_1.setItem(h,tvi)
end if

return true

end function

public function boolean of_addstubs (readonly string file);string fname
int f
string s
string name
string ls_text
long len,root

if handle(app())<>0 then
	fname=space(4000)
	w_main.GetModuleFileName(0,fname,len(fname))
	fname=f_getfilepart(fname,1)
end if

fname+=file//'stubs.sql'
//messageBox('',fname)

f=fileopen(fname)
if f=-1 then return false

root=tv_1.findItem(RootTreeItem!,0)
if root=-1 then root=tv_1.of_insertitemlast( 0/*root*/, 'Stubs','STUBS',8,8)

do while fileread(f,s)>=0
	len=len(s)
	if left(s,3)='--<' and mid(s,len - 2)='>--' then
		of_addstub(root,name,ls_text)
		name=mid(s,4,len - 6)
		ls_text=''
	else
		if ls_text>'' then ls_text+='~r~n'
		ls_text+=s
	end if
loop

of_addstub(root,name,ls_text)
//tv_1.expandItem(root)

fileclose(f)
tv_1.selectItem(root)
tv_1.expandItem(root)

return true

end function

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

private function long of_getlist (readonly string as_word, long h, readonly datastore items, boolean ab_exact);treeviewitem tvi
long count,i
string s
boolean lb_found
boolean lb_folder

//returns the number of found items

lb_folder=of_isfolder(as_word)
count=items.rowcount()
if h=0 then return count
h=tv_1.finditem( ChildTreeItem!, h)
do while h>0
	//if ab_exact and count>0 then exit
	tv_1.getitem(h,tvi)
	//
	s=tvi.label
	if tvi.children then s='\'+s
	
	if s<>'\Menu' then
		lb_found=false
		if tvi.children and tvi.pictureindex=gn_sqlmenu.typeStubs then 
			//this item is a folder and stub at once/ add it as a stub
			if (not ab_exact and lower(left(tvi.label,len(as_word)))=as_word) or (ab_exact and lower(tvi.label)=as_word) then
				of_addlistitem(items,tvi.label,h)
				lb_found=true
			end if
		end if
		if (not ab_exact and lower(left(tvi.label,len(as_word)))=as_word) or (ab_exact and lower(s)=as_word) then
			if lb_folder then
				count+=of_getlist('',h,items,false)
			else
				of_addlistitem(items,s,h)
			end if
			lb_found=true
		end if
		if not lb_found then
			count+=of_getlist(as_word,h,items,ab_exact)
		end if
	end if
	h=tv_1.finditem( NextTreeItem!, h)
loop

return items.rowcount()

end function

public function boolean of_isfolder (readonly string s);return char(s)='\'

end function

public subroutine of_addlistitem (readonly datastore items, readonly string as_item, long al_handle);long i,count
boolean lb_found
string s

lb_found=false
count=items.rowcount()
s=lower(as_item)
for i=1 to count
	if lower(items.getItemString(i,1))=s then 
		lb_found=true
		exit
	end if
next

if not lb_found then
	count++
	items.insertRow(count)
	items.setitem(count,1,as_item)
	items.setitem(count,2,al_handle)
end if

end subroutine

public function integer of_getlist (readonly string as_word, ref string as_ret, boolean ab_select);//ab_select=true if item is selected by user

//returns 1 if one item selected that could be pasted
//returns 2 if several found and list returned
//returns 0 if not found but generic list returned

string s
long i,count,ll_ret
treeviewitem tvi
datastore items
items=create datastore
items.dataobject='d_edit_userlist'

as_ret=''

//try to get list according to the word beginning from root
if as_word<>'' then 
	count=of_getlist(lower(as_word),tv_1.finditem( RootTreeItem!, 0),items,ab_select)
end if

//if word is empty then we are going to display root items
if as_word='' then
	count=of_getlist('',tv_1.finditem( RootTreeItem!, 0),items,ab_select)
end if

if count=0 then goto ret


if count=1 then
	if items.getItemNumber(1,'isfolder')=1 then
		s=items.getItemString(1,'name')
		items.reset()
		count=of_getlist(s,tv_1.finditem( RootTreeItem!, 0),items,true)
	end if
end if

ret:
count=items.rowcount()

if count=0 then
	//do nothing
	ll_ret=0
elseif count=1 and items.getItemNumber(1,'isfolder')=0 then
	tv_1.getitem(items.getItemNumber(1,'handle'),tvi)
	as_ret=tvi.data
	ll_ret=1

else
	for i=1 to count
		if i<>1 then as_ret+='~t'
		as_ret+=items.getItemString(i,1)
		as_ret+='?'+string(1 - items.getItemNumber(i,'isfolder'))
	next
	ll_ret=2
end if

destroy items

return ll_ret

end function

on uo_br_stubs.create
this.tv_1=create tv_1
this.Control[]={this.tv_1}
end on

on uo_br_stubs.destroy
destroy(this.tv_1)
end on

type tv_1 from uo_dynamic_tv within uo_br_stubs
integer x = 37
integer y = 56
integer width = 558
integer height = 376
integer taborder = 10
fontcharset fontcharset = ansi!
string facename = "Microsoft Sans Serif"
boolean hideselection = false
string picturename[] = {"DBConnect!","Custom039!","Custom050!","img\table.bmp","img\proc_g.bmp","img\view.bmp","Structure5!","PasteStatement!","Custom092!","img\search.gif","img\tablesys.bmp","UserObject!","img\trigger.bmp"}
long picturemaskcolor = 12632256
end type

event key;call super::key;if key=KeyF5! then
	parent.event ue_init()
elseif key=KeyEnter! then
	parent.post of_popup()
end if

end event

event doubleclicked;call super::doubleclicked;parent.post of_popup()

end event

event rightclicked;call super::rightclicked;selectItem(handle)
parent.of_popup()

end event

