HA$PBExportHeader$n_sqlexecsink.sru
$PBExportComments$nonvisual listener object for sql execution
forward
global type n_sqlexecsink from nonvisualobject
end type
end forward

global type n_sqlexecsink from nonvisualobject
event type long sqlexec_resultset ( unsignedlong wparam,  long lparam )
event type long sqlexec_row_end ( unsignedlong wparam,  long lparam )
event type long sqlexec_row_start ( unsignedlong wparam,  long lparam )
event type long sqlexec_field_value ( unsignedlong wparam,  long lparam )
event type long sqlexec_field_info ( unsignedlong wparam,  long lparam )
event type long sqlexec_debug ( unsignedlong wparam,  long lparam )
event type long sqlexec_directory ( unsignedlong wparam,  long lparam )
event type long sqlexec_sql_message ( unsignedlong wparam,  long lparam )
event type long sqlexec_res_info ( unsignedlong wparam,  long lparam )
event type long sqlexec_dir_info ( unsignedlong wparam,  long lparam )
end type
global n_sqlexecsink n_sqlexecsink

event type long sqlexec_resultset(unsignedlong wparam, long lparam);//rstype=wparam //wparam=2 then //rs_type=RS_TYPE_OUT
//colcount=lparam

return 0

end event

event type long sqlexec_row_end(unsignedlong wparam, long lparam);//row=wparam

return 0

end event

event type long sqlexec_row_start(unsignedlong wparam, long lparam);//if il_stop_code<>0 then return il_stop_code //stop!!!
//row=wparam

return 0

end event

event type long sqlexec_field_value(unsignedlong wparam, long lparam);string s

if lparam=0 then
	setNull(s)
else
	gn_unicode.of_mblong2string(sqlca.of_utf8(), lparam,s)
end if

//if isValid(irs_current) then irs_current.of_sybexec_setfield(wparam,s)
return 0

end event

event type long sqlexec_field_info(unsignedlong wparam, long lparam);string s

if lparam=0 then
	setNull(s)
else
	gn_unicode.of_mblong2string(sqlca.of_utf8(), lparam,s)
end if

//if isValid(irs_current) then irs_current.of_sybexec_setfieldinfo(wparam,s)

return 0

end event

event type long sqlexec_debug(unsignedlong wparam, long lparam);//this is only for debug messages from syb_exec.dll
string s

return 0

if lparam=0 then 
	s='<NULL>'
else
	gn_unicode.of_mblong2string(sqlca.of_utf8(), lparam,s) //in_sqlmsg.of_l2s(lparam,s) //normally from the database we should receive unicode data...//maybe in the future...
end if

//have to do something with this string...?


end event

event type long sqlexec_directory(unsignedlong wparam, long lparam);string s

s=String(lparam,"address")
return 0

end event

event type long sqlexec_sql_message(unsignedlong wparam, long lparam);/*
in_sqlmsg.of_translatemessage(wparam,lparam)

if in_sqlmsg.proclen=0 then
	if isValid(iuo_lastexecpage) then
		//message not from procedure and executed from the interface
		in_sqlmsg.line+=iuo_lastexecpage.uo_edit.of_send(iuo_lastexecpage.uo_edit.SCI_LINEFROMPOSITION,currentselpos+currentpos,0)
	end if
end if

of_log(in_sqlmsg.msgnumber,in_sqlmsg.severity,in_sqlmsg.proc,in_sqlmsg.line,in_sqlmsg.text)
*/
return 0

end event

event type long sqlexec_res_info(unsignedlong wparam, long lparam);//
string s
if lparam=0 then return 0

gn_unicode.of_mblong2string(sqlca.of_utf8(), lparam,s)
choose case wparam
	case 1 /*RS_INFO_ROWS*/
//		of_log(0,0,'',0,'('+s+' rows affected)')
	case 2 /*RS_INFO_RET*/
//		of_log(0,0,'',0,'return status = '+s)
	case 3 /*RS_INFO_BR_TABLE*/
//		if isValid(irs_current) then irs_current.of_sybexec_tabname(s)
end choose

return 0

end event

event type long sqlexec_dir_info(unsignedlong wparam, long lparam);//
string key
string value

key=String(wparam,"address")
value=String(lparam,"address")
return 0

end event

on n_sqlexecsink.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_sqlexecsink.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

