HA$PBExportHeader$n_history.sru
forward
global type n_history from nonvisualobject
end type
end forward

global type n_history from nonvisualobject
end type
global n_history n_history

type variables
privatewrite int ii_mrumax=26

end variables

forward prototypes
public subroutine of_setmru (readonly string s)
private function integer of_findindex (readonly character mru[], long hash, readonly string s)
public function string of_getmru ()
public subroutine of_add (readonly string s)
public subroutine of_delete (readonly string s)
end prototypes

public subroutine of_setmru (readonly string s);cfg.of_setstring ( "options", "history.mru", s )

end subroutine

private function integer of_findindex (readonly character mru[], long hash, readonly string s);int i,count
count=upperbound(mru)

for i=1 to count
	if cfg.of_getlong('history.'+mru[i],'hash',0)=hash then
		if s=cfg.of_gettext('history.'+mru[i],'') then return i
	end if
next
//not found in history
return 0

end function

public function string of_getmru ();return cfg.of_getstring ( "options", "history.mru" )

end function

public subroutine of_add (readonly string s);//

string mru
int index
long hash,mrulen
string c
int f

if cfg.ib_history_log then
	//cfg.of_getoption(cfg.is_UnixEOL)
	//DM: i think we should not check EOL type because all sql in history in windows mode.
	f=FileOpen(cfg.is_history_log_file, TextMode!, Write!, LockWrite!, Append!, EncodingANSI!)
	FileWriteEx(f, ' ------------------------- '+String(Today(), "yyyy-mm-dd hh:mm:ss")+' ------------------------- ')
	FileWriteEx(f, '~r~n')
	FileWriteEx(f, s)
	FileWriteEx(f, '~r~n~r~n')
	FileClose(f)
end if

mru=of_getmru()
hash=len(s)  //our hash - it's just string length

index=of_findindex(mru,hash,s)

if index>0 then
	//the string is already in history
	//let's modify index
	mru=mid(mru,index,1)+left(mru,index - 1)+ mid(mru,index+1)
else
	//delete the last item in history
	//and add the new one
	mrulen=len(mru)
	if mrulen>=ii_mrumax then 
		c=mid(mru,ii_mrumax,1)
		mru=left(mru,ii_mrumax -1)  //delete the last in mru
	else
		c=char(97+mrulen)
	end if
	mru=c+mru
	cfg.of_settext('history.'+c,s)
	cfg.of_setlong('history.'+c,'hash',hash)
end if
of_setmru(mru)

end subroutine

public subroutine of_delete (readonly string s);//

string mru
int index
long hash,mrulen
string c

mru=of_getmru()
hash=len(s)  //our hash - it's just string length

index=of_findindex(mru,hash,s)

if index>0 then
	c=mid(mru,index,1)
	//the string is in history
	//let's modify index
	mru=left(mru,index - 1)+ mid(mru,index+1)
	//clear data
	cfg.of_settext('history.'+c,"")
	cfg.of_setlong('history.'+c,'hash',0)
end if
of_setmru(mru)

end subroutine

on n_history.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_history.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

