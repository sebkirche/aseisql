HA$PBExportHeader$uo_lv.sru
forward
global type uo_lv from listview
end type
type rect from structure within uo_lv
end type
end forward

type rect from structure
	long		left
	long		top
	long		right
	long		bottom
end type

global type uo_lv from listview
integer width = 576
integer height = 148
integer textsize = -8
integer weight = 400
fontcharset fontcharset = russiancharset!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Microsoft Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
boolean buttonheader = false
boolean hideselection = false
boolean fullrowselect = true
listviewview view = listviewreport!
long largepicturemaskcolor = 536870912
string smallpicturename[] = {"img\info.gif","img\error.gif",""}
long smallpicturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
event ue_resize pbm_size
end type
global uo_lv uo_lv

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
public subroutine of_scrollto (long index)
public subroutine of_autosize (long index, boolean header)
public function long of_getlastvisible ()
end prototypes

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

total=totalItems()
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

public subroutine of_scrollto (long index);long LVM_SCROLL  = 4096 + 20

send(handle(this),LVM_SCROLL,0,index - 1)

end subroutine

public subroutine of_autosize (long index, boolean header);long LVM_SETCOLUMNWIDTH=4096+30

if header then
	send(handle(this),LVM_SETCOLUMNWIDTH,index - 1, -2 /*LVSCW_AUTOSIZE_USEHEADER*/ )
else
	send(handle(this),LVM_SETCOLUMNWIDTH,index - 1, -1 /*LVSCW_AUTOSIZE*/ )
end if

end subroutine

public function long of_getlastvisible ();long topindex,countPerPage


topIndex=send(handle(this),4096+39/*LVM_GETTOPINDEX */,0,0)
countPerPage=send(handle(this),4096+40/*LVM_GETCOUNTPERPAGE*/,0,0)


return topIndex+countPerPage

end function

on uo_lv.create
end on

on uo_lv.destroy
end on

