HA$PBExportHeader$uo_tablist.sru
forward
global type uo_tablist from uo_dynamic_tv
end type
end forward

global type uo_tablist from uo_dynamic_tv
integer width = 649
integer height = 472
fontcharset fontcharset = russiancharset!
string facename = "Microsoft Sans Serif"
boolean disabledragdrop = false
string picturename[] = {"NotFound!"}
long picturemaskcolor = 12632256
event type boolean ue_newitem ( readonly uo_tabpage t,  readonly treeviewitem tvi )
end type
global uo_tablist uo_tablist

forward prototypes
public subroutine of_init (boolean ab_add_rs)
end prototypes

event type boolean ue_newitem(readonly uo_tabpage t, readonly treeviewitem tvi);//you can add item info here
//returns false if we don't want to add item

return true

end event

public subroutine of_init (boolean ab_add_rs);long i,count
uo_tabpage t
treeviewitem tvi

count=upperbound(w_main.tab_1.control)
for i=1 to count
	t=w_main.tab_1.control[i]
	
	tvi.label=t.text
	if t.powertiptext<>'' then tvi.label+=' ['+t.powertiptext +']'
	tvi.pictureindex=of_picture( t.picturename )
	tvi.selectedpictureindex=tvi.pictureindex
	tvi.StatePictureIndex=2
	tvi.data=i
	if this.event ue_newitem(t,tvi) then
		this.insertitemlast( 0, tvi )
	end if
next

end subroutine

on uo_tablist.create
end on

on uo_tablist.destroy
end on

