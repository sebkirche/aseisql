HA$PBExportHeader$n_sqlmessage.sru
forward
global type n_sqlmessage from nonvisualobject
end type
type t_sybmessage from structure within n_sqlmessage
end type
end forward

type t_sybmessage from structure
	long		msgnumber
	long		severity
	long		proc
	long		line
	long		text
end type

global type n_sqlmessage from nonvisualobject
end type
global n_sqlmessage n_sqlmessage

type prototypes
private subroutine RtlMoveMemory( ref t_sybmessage dest, long src, long srclen ) library 'kernel32.dll' alias for "RtlMoveMemory"

end prototypes

type variables
public protectedwrite long msgnumber
public protectedwrite long severity
public protectedwrite string text
public protectedwrite string proc
public long line
public protectedwrite long proclen

private t_sybmessage msg

end variables

forward prototypes
public function boolean of_translatemessage (long wparam, long lparam)
end prototypes

public function boolean of_translatemessage (long wparam, long lparam);long msgsize=20

if wparam<>msgsize then SignalError(0,'The size of internal structure "t_sybmessage" does not fit incoming data.')

//copy lparam argument into internal structure
RtlMoveMemory( msg, lparam, msgsize )

//copy long data
this.msgnumber=msg.msgnumber
this.severity=msg.severity
this.line=msg.line

//convert text data
gn_unicode.of_mblong2string(sqlca.of_utf8(),msg.text,this.text)// of_l2s(msg.text,this.text)
this.proclen=gn_unicode.of_mblong2string(sqlca.of_utf8(),msg.proc,this.proc)//=of_l2s(msg.proc,this.proc)

return true

end function

on n_sqlmessage.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_sqlmessage.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

