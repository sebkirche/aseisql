HA$PBExportHeader$uo_option_master.sru
forward
global type uo_option_master from userobject
end type
end forward

global type uo_option_master from userobject
integer width = 1719
integer height = 1296
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_changed ( )
event ue_apply ( )
event ue_init ( )
end type
global uo_option_master uo_option_master

type variables
public privatewrite boolean ib_changed=false

end variables

forward prototypes
public subroutine of_change ()
public subroutine of_apply ()
end prototypes

event ue_changed();ib_changed=true
parent.triggerevent('ue_changed')

end event

public subroutine of_change ();this.event ue_changed()

end subroutine

public subroutine of_apply ();if ib_changed then
	this.event ue_apply()
	ib_changed=false
end if


end subroutine

on uo_option_master.create
end on

on uo_option_master.destroy
end on

event constructor;this.visible=false

end event

