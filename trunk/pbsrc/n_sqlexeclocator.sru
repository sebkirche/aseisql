HA$PBExportHeader$n_sqlexeclocator.sru
forward
global type n_sqlexeclocator from nonvisualobject
end type
end forward

global type n_sqlexeclocator from nonvisualobject
event ue_sqlexec_preview ( long al_pos,  readonly string as_query,  long al_id )
event ue_sqlexec_end ( )
event type boolean ue_sqlexec_wantstop ( )
end type
global n_sqlexeclocator n_sqlexeclocator

event ue_sqlexec_preview(long al_pos, readonly string as_query, long al_id);w_main.event ue_sqlexec_preview(al_pos,as_query,al_id)

end event

event ue_sqlexec_end();w_main.event ue_sqlexec_end()

end event

event type boolean ue_sqlexec_wantstop();return w_main.event ue_sqlexec_wantstop()

end event

on n_sqlexeclocator.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_sqlexeclocator.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

