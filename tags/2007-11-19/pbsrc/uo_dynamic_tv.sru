HA$PBExportHeader$uo_dynamic_tv.sru
forward
global type uo_dynamic_tv from treeview
end type
end forward

global type uo_dynamic_tv from treeview
integer width = 494
integer height = 360
integer taborder = 1
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string picturename[] = {"Custom039!"}
long picturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
event db_prepare ( long parenthandle,  integer newlevel,  ref string query,  ref boolean isprocedure )
event db_retrieve_row ( long parenthandle,  integer newlevel,  readonly any outparm[],  ref treeviewitem newitem,  ref boolean additem )
event db_error ( )
event db_insert_item ( long handle,  readonly treeviewitem tvi )
end type
global uo_dynamic_tv uo_dynamic_tv

type prototypes
private function long SendMessage(long _hWnd, long Msg,long wParam,ref t_rect lParam) library "user32.dll" alias for "SendMessageW"
private function boolean GetClientRect(long _hWnd,ref T_RECT r)library "user32.dll" alias for "GetClientRect"

end prototypes

type variables
boolean db_busy=false
boolean db_retrieve=false

end variables

forward prototypes
public function long  f_getcurrenthandle ()
public function long  f_findrootitem (long handle)
public function integer  f_dbretrieve ()
public function boolean  f_dbretrieveall (readonly long handle)
public function boolean  f_dbretrieveall ()
public function boolean  f_deletechildren (readonly long handle)
public function boolean  f_dbreloadchildren (readonly long handle)
public function boolean  f_collapseall (readonly long handle)
public function boolean  f_expandallparent (readonly long handle)
public function long f_getcurrentitem (ref treeviewitem tvi)
public function integer f_cleartreeviewitem (ref treeviewitem tvi)
public function integer f_dbretrieve (long parenthandle)
public function long of_insertitemlast (long hparent, readonly string label, readonly any data, integer pic, integer selpic)
public subroutine f_popmenu (readonly menu m)
public function long of_insertitemlast (long hparent, readonly string label, readonly any data, integer pic, integer selpic, boolean child)
public function long of_findchildbyname (long al_root, string s, ref treeviewitem tvi)
public function integer of_picture (string as_name)
public function boolean f_getitemrect (treenavigation n, ref t_rect r)
end prototypes

event db_error();//messagebox(getApplication().displayname+' - Error',sqlca.sqlerrtext,StopSign!)
sqlca.of_error()

end event

public function long  f_getcurrenthandle ();return(FindItem(CurrentTreeItem!,0))

end function

public function long  f_findrootitem (long handle);TreeViewItem tvi
long h
if handle<1 then
	h=FindItem(RootTreeItem!,0)
else
	h=handle
	if GetItem(h,tvi)<1 then return(-1)
	DO WHILE tvi.level>1
		h=findItem(ParentTreeItem!,h)
		if GetItem(h,tvi)<1 then return(-1)
	LOOP
end if
return(h)

end function

public function integer  f_dbretrieve ();return( f_dbRetrieve(0))

end function

public function boolean  f_dbretrieveall (readonly long handle);long				h
pointer			oldpointer
treeViewItem	tvi

oldpointer=SetPointer(HourGlass!)
 f_dbretrieve(handle)
if handle=0 then
	h=this.finditem(RootTreeItem!,0)
else
	h=this.finditem(ChildTreeItem!,handle)
end if
DO WHILE h>0
	this.getItem(h,tvi)
	tvi.expandedonce=true
	this.setItem(h,tvi)
	 f_dbretrieveAll(h)
	h=this.finditem(NextTreeItem!,h)
LOOP
SetPointer(oldpointer)
return true

end function

public function boolean  f_dbretrieveall ();return  f_dbretrieveall(0)

end function

public function boolean  f_deletechildren (readonly long handle);long		h
h=this.FindItem(ChildTreeItem!,handle)
DO WHILE h>0
	if this.DeleteItem(h)=-1 then return false
	h=this.FindItem(ChildTreeItem!,handle)
LOOP
return true

end function

public function boolean  f_dbreloadchildren (readonly long handle);TreeViewItem		tvi
if this. f_deletechildren(handle) then
	if this. f_dbretrieve(handle)>0 then
		if this.getItem(handle,tvi)=1 then
			tvi.expandedonce=true
			this.SetItem(handle,tvi)
			return true
		end if
	end if
end if
return false

end function

public function boolean  f_collapseall (readonly long handle);long h
this.collapseitem(handle)
h=this.FindItem(ChildTreeItem!,handle)
DO WHILE h>0
	this. f_collapseall(h)
	h=this.FindItem(NextTreeItem!,h)
LOOP
return true

end function

public function boolean  f_expandallparent (readonly long handle);long h
h=this.FindItem(ParentTreeItem!,handle)
DO WHILE h>0
	this.expandItem(h)
	h=this.FindItem(ParentTreeItem!,h)
LOOP
return true

end function

public function long f_getcurrentitem (ref treeviewitem tvi);long l
l=this. f_getCurrentHandle()
if l>0 then GetItem(l,tvi)
return(l)

end function

public function integer f_cleartreeviewitem (ref treeviewitem tvi);tvi.Bold=false
tvi.Children=false
tvi.CutHighLighted=false
tvi.Data=0
tvi.DropHighLighted=false
tvi.Expanded=false
tvi.ExpandedOnce=false
tvi.HasFocus=false
tvi.ItemHandle=0
tvi.Label=''
tvi.Level=0
tvi.OverlayPictureIndex=0
tvi.PictureIndex=0
tvi.SelectedPictureIndex=0
tvi.Selected=false
tvi.StatePictureIndex=0
return(1)

end function

public function integer f_dbretrieve (long parenthandle);int ret=1
string query
boolean isProcedure
treeViewItem tvi
long level
any outparm[]
long l
boolean ChildrenFound
boolean AddItem
string lock
pointer oldpointer

if db_busy then return(0)
db_busy=true
if parenthandle>0 then
	GetItem(parenthandle,tvi)
	level=tvi.level+1
else
	deleteItem(0)
	level=1
end if
query=""
oldpointer=SetPointer(HourGlass!)
trigger event db_prepare(ParentHandle,level,query,isProcedure)
if query<>"" then
	if isProcedure then
		DECLARE TreeViewRetrieveP DYNAMIC PROCEDURE FOR SQLSA;
	else
		DECLARE TreeViewRetrieveC DYNAMIC CURSOR FOR SQLSA;
	end if
	
	PREPARE SQLSA FROM :query using SQLCA;
	DESCRIBE SQLSA INTO SQLDA;
	lock=SQLCA.lock
	SQLCA.lock="RU"
	if isProcedure then
		EXECUTE DYNAMIC TreeViewRetrieveP USING DESCRIPTOR SQLDA;
		if SQLCA.sqlcode=-1 then 
			this.event db_error()
			ret=-1
		end if
		FETCH TreeViewRetrieveP USING DESCRIPTOR SQLDA;
	else
		OPEN DYNAMIC TreeViewRetrieveC USING DESCRIPTOR SQLDA;
		if SQLCA.sqlcode=-1 then 
			this.event db_error()
			ret=-1
		end if
		FETCH TreeViewRetrieveC USING DESCRIPTOR SQLDA;
	end if
	ChildrenFound=false
	DO WHILE SQLCA.sqlcode=0
		if SQLDA.NumOutputs<1 then continue
		for l=1 to SQLDA.NumOutputs
			CHOOSE CASE SQLDA.OutParmType[l]
				CASE TypeDate!
					outparm[l]=SQLDA.GetDynamicDate(l)
				CASE TypeDateTime!
					outparm[l]=SQLDA.GetDynamicDateTime(l)
				CASE TypeDecimal!,TypeDouble!,TypeReal!,TypeUInt!,TypeULong!,TypeBoolean!
					outparm[l]=SQLDA.GetDynamicNumber(l)
				CASE TypeLong!
					outparm[l]=long(SQLDA.GetDynamicNumber(l))
				CASE TypeInteger!
					outparm[l]=integer(SQLDA.GetDynamicNumber(l))
				CASE TypeString!
					outparm[l]=SQLDA.GetDynamicString(l)
				CASE TypeTime!
					outparm[l]=SQLDA.GetDynamicTime(l)
			END CHOOSE
		next
		AddItem=true
		f_clearTreeViewItem(tvi)
		trigger Event db_retrieve_row(parenthandle,level,outparm,tvi,AddItem)
		if AddItem then
			long handle
			handle=insertItemLast(ParentHandle,tvi)
			this.event db_insert_item(handle,tvi)
			ChildrenFound=true
		end if
		if isProcedure then
			FETCH TreeViewRetrieveP USING DESCRIPTOR SQLDA;
		else
			FETCH TreeViewRetrieveC USING DESCRIPTOR SQLDA;
		end if
	LOOP
	if SQLCA.sqlcode=-1 then 
		this.event db_error()
		ret=-1
	end if
	if not ChildrenFound then
		if GetItem(ParentHandle,tvi)>0 then
			tvi.children=false
			SetItem(ParentHandle,tvi)
		end if
	end if
	if isProcedure then
		CLOSE TreeViewRetrieveP;
	else
		CLOSE TreeViewRetrieveC;
	end if
	SQLCA.lock=lock
end if
SetPointer(oldpointer)
db_busy=false
return(ret)

end function

public function long of_insertitemlast (long hparent, readonly string label, readonly any data, integer pic, integer selpic);treeViewItem tvi

tvi.expandedonce=true
tvi.data=data
tvi.label=label
tvi.pictureindex=pic
tvi.selectedpictureindex=selpic

return this.insertItemLast(hparent,tvi)

end function

public subroutine f_popmenu (readonly menu m);
t_rect r
long h
treeViewItem tvi
powerobject o
window w

this.setFocus()

h=this.FindItem(CurrentTreeItem!,0)

if h>0 and isValid(m) then
	this.getItem(h,tvi)
	o=this
	do while o.typeof( )<>window!
		o=o.getParent()
	loop
	w=o
	
	f_getItemRect(CurrentTreeItem!,r)
	m.popmenu(r.left+w.pointerx()-this.pointerx(),r.bottom+w.pointery()-this.pointery())
end if

end subroutine

public function long of_insertitemlast (long hparent, readonly string label, readonly any data, integer pic, integer selpic, boolean child);treeViewItem tvi

tvi.expandedonce=false
tvi.data=data
tvi.label=label
tvi.pictureindex=pic
tvi.selectedpictureindex=selpic
tvi.children=child

return this.insertItemLast(hparent,tvi)

end function

public function long of_findchildbyname (long al_root, string s, ref treeviewitem tvi);long h

s=lower(s)
h=FindItem(ChildTreeItem!,al_root)
do while h<>-1
	getItem(h,tvi)
	if lower(tvi.label)=s then return h
	h=FindItem(NextTreeItem!,h)
loop

return h

end function

public function integer of_picture (string as_name);//adds picture into the picture list if not already added
//returns picture index

int i,count
count=upperbound(this.picturename)
as_name=lower(as_name)
for i=1 to count
	if lower(picturename[i]) = as_name then return i
next

picturename[count+1]=as_name
return this.addpicture(as_name)


end function

public function boolean f_getitemrect (treenavigation n, ref t_rect r);long TV_FIRST=4352
long TVM_ENSUREVISIBLE=TV_FIRST + 20
long TVM_GETITEMRECT  =TV_FIRST + 4
long TVM_GETNEXTITEM  =TV_FIRST + 10
long TVGN_CARET       =9
long TVM_HITTEST      =TV_FIRST + 17
long handle
t_rect hittest

choose case n
	case CurrentTreeItem!
		handle=Send(handle(this),TVM_GETNEXTITEM,TVGN_CARET,0)
		send(handle(this), TVM_ENSUREVISIBLE, 0, handle)
	case DropHighlightTreeItem!
		HITTEST.left=UnitsToPixels(this.pointerx(),xUnitsToPixels!)
		HITTEST.top=UnitsToPixels(this.pointery(),yUnitsToPixels!)
		handle=SendMessage(handle(this), TVM_HITTEST,0,HITTEST)
	case else
		return false
end choose

if handle=0 then return false

r.left=handle
if SendMessage(handle(this), TVM_GETITEMRECT,1,r)=0 then 
	r.left=0
	return false
end if
r.left=PixelsToUnits(r.left,XPixelsToUnits!)
r.top=PixelsToUnits(r.top,XPixelsToUnits!)
r.right=PixelsToUnits(r.right,XPixelsToUnits!)
r.bottom=PixelsToUnits(r.bottom,YPixelsToUnits!)

return true


end function

event itempopulate;SetPointer(Arrow!)
 f_DBretrieve(handle)

end event

on uo_dynamic_tv.create
end on

on uo_dynamic_tv.destroy
end on

