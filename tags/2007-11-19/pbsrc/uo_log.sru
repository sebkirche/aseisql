HA$PBExportHeader$uo_log.sru
forward
global type uo_log from listview
end type
type rect from structure within uo_log
end type
end forward

type rect from structure
	long		left
	long		top
	long		right
	long		bottom
end type

global type uo_log from listview
integer width = 2386
integer height = 280
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
boolean buttonheader = false
boolean extendedselect = true
boolean hideselection = false
boolean fullrowselect = true
listviewview view = listviewreport!
long largepicturemaskcolor = 536870912
string smallpicturename[] = {"img\info.gif","img\error.gif",""}
long smallpicturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
event ue_resize pbm_size
end type
global uo_log uo_log

type prototypes
private function long SendMessage(long win, long msg, long index,ref rect r)library 'user32' alias for 'SendMessageW'

end prototypes

type variables
private long oldheight

end variables

forward prototypes
public subroutine of_ensurevisible (long index)
public function integer of_getcolwidth (long index)
public subroutine of_setcolwidth (long index, long w)
public function boolean of_isvisible (long index)
public function long of_getitematpointer ()
public subroutine of_copy (boolean ab_selected)
public subroutine of_scrollto (long index)
end prototypes

event ue_resize;int ww=4
int i,count

count=TotalColumns()
if count<>4 then return

for i=1 to count -1
	ww+=of_getcolwidth(i)
next

post of_SetColWidth( count, max(10,newwidth - ww) )

end event

public subroutine of_ensurevisible (long index);long LVM_ENSUREVISIBLE=4096+19

send(handle(this),LVM_ENSUREVISIBLE,index -1,0)

end subroutine

public function integer of_getcolwidth (long index);long LVM_GETCOLUMNWIDTH=4096+29

return PixelsToUnits(send(handle(this),LVM_GETCOLUMNWIDTH,index - 1,0),XPixelsToUnits!)

end function

public subroutine of_setcolwidth (long index, long w);long LVM_SETCOLUMNWIDTH=4096+30

send(handle(this),LVM_SETCOLUMNWIDTH,index - 1,UnitsToPixels(w,XUnitsToPixels!))

end subroutine

public function boolean of_isvisible (long index);long topindex,countPerPage,total

total=totalItems()
if total<index then return false

topIndex=send(handle(this),4096+39/*LVM_GETTOPINDEX */,0,0)+1
countPerPage=send(handle(this),4096+40/*LVM_GETCOUNTPERPAGE*/,0,0)

if index>=topIndex and index<topIndex+countPerPage then return true
return false

end function

public function long of_getitematpointer ();rect r
long index,yy,xx
long topindex,countPerPage,total,lastindex

yy=UnitsToPixels(this.PointerY(),YUnitsToPixels!)
xx=UnitsToPixels(this.PointerX(),XUnitsToPixels!)

total=this.totalItems()
if total<1 then return 0

topIndex=send(handle(this),4096+39/*LVM_GETTOPINDEX */,0,0)
countPerPage=send(handle(this),4096+40/*LVM_GETCOUNTPERPAGE*/,0,0)

lastIndex=min(total,topIndex+countPerPage)-1

for index=topindex to lastindex
	SendMessage(handle(this),4096+14/*LVM_GETITEMRECT*/,index,r)
	if yy>=r.top and yy<=r.bottom &
		and xx>=r.left and xx<=r.right then return index+1
next

return 0


end function

public subroutine of_copy (boolean ab_selected);long i,count
listviewitem lvi
string ls,ls_copy
boolean ctrl

ctrl=KeyDown(KeyControl!)

count=totalItems()

for i=1 to count
	getItem(i,lvi)
	if not ab_selected or lvi.selected then
		if ctrl then
			getItem(i,1,ls)
			ls_copy+=ls+'~t'
			getItem(i,2,ls)
			ls_copy+=ls+'~t'
			getItem(i,3,ls)
			ls_copy+=ls+'~t'
			getItem(i,4,ls)
			ls_copy+=ls
		else
			getItem(i,4,ls)
			ls_copy+=ls
		end if
		if i<count then ls_copy+='~r~n'
	end if
next
clipboard(ls_copy)

end subroutine

public subroutine of_scrollto (long index);long LVM_SCROLL  = 4096 + 20

send(handle(this),LVM_SCROLL,0,index - 1)

end subroutine

on uo_log.create
end on

on uo_log.destroy
end on

event constructor;AddColumn ( "time", Left!, 396 )
AddColumn ( "number", Right!, 290 )
AddColumn ( "object", Left!, 742 )
AddColumn ( "message", Left!, 200 )

end event

