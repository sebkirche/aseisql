HA$PBExportHeader$n_dw_selection.sru
forward
global type n_dw_selection from nonvisualobject
end type
end forward

global type n_dw_selection from nonvisualobject
end type
global n_dw_selection n_dw_selection

type variables
string column[]
long row_start
long row_end
datawindow idw
n_dw_selection thenext

end variables

forward prototypes
public function long of_init (readonly datawindow adw)
private function boolean of_parse (readonly string s)
public function long of_init (readonly string as_sel, readonly datawindow adw)
public function boolean of_iscell ()
public function boolean of_isonecolumn ()
public function boolean of_isnumbercolumn ()
public function string of_tostring (boolean header, boolean data, readonly string coldelim, readonly string rowdelim, boolean quotestr)
public function boolean of_contains (long row, readonly string col)
end prototypes

public function long of_init (readonly datawindow adw);return of_init(adw.describe('datawindow.selected'),adw)

end function

private function boolean of_parse (readonly string s);long pos0=1,pos
long i=1
string ls

do 
	pos=pos(s,'/',pos0)
	if pos>0 then
		ls=mid(s,pos0,pos - pos0)
	else
		ls=mid(s,pos0)
	end if
	if i=1 then row_start=long(ls)
	if i=2 then row_end=long(ls)
	if i>2 then
		column[i -2]=ls
	end if
	pos0=pos+1
	i++
loop while pos>0

if row_start>row_end then
	i=row_start
	row_start=row_end
	row_end=i
end if

return i>2

end function

public function long of_init (readonly string as_sel, readonly datawindow adw);long pos

if as_sel='' then return 0
if isnull(as_sel) then return 0

idw=adw
pos=pos(as_sel,';')
if pos>0 then
	if not of_parse( left(as_sel,pos -1) ) then return 0
	thenext=create n_dw_selection
	return 1+thenext.of_init( mid(as_sel,pos+1),idw )
else
	if not of_parse( as_sel ) then return 0
	return 1
end if

end function

public function boolean of_iscell ();if isValid(thenext) then return false
if upperbound(column)>1 then return false
if row_start<>row_end then return false
if row_start>0 then return true
return false

end function

public function boolean of_isonecolumn ();if isvalid(thenext) then
	if upperbound(this.column)=1 and this.column=thenext.column then
		return thenext.of_isonecolumn()
	end if
end if
return upperbound(this.column)=1

end function

public function boolean of_isnumbercolumn ();long row
string s
string ls_null

ls_null=cfg.of_getstring(cfg.is_options,cfg.is_nullstr)

for row=row_start to row_end
	s=idw.getitemstring(row,column[1])
	if isnull(s) then
	elseif s=ls_null and s<>'' then
	elseif match(s,'^-?[0-9]+\.[0-9]*$') or match(s,'^-?[0-9]*\.[0-9]+$') or match(s,'^-?[0-9]+$') then
	else
		return false
	end if
next

if isvalid(thenext) then
	return thenext.of_isnumbercolumn()
end if

return true

end function

public function string of_tostring (boolean header, boolean data, readonly string coldelim, readonly string rowdelim, boolean quotestr);long icol,ccol
long row
string ret,s
string ls_null
ls_null=cfg.of_getstring(cfg.is_options,cfg.is_nullstr)

ccol=upperbound(column)
if header then
	for icol=1 to ccol
		ret+=idw.describe(column[icol]+'_t.text')
		if icol<ccol then ret+=coldelim
	next
end if
if data then
	if header then ret+=rowdelim
	for row=row_start to row_end
		for icol=1 to ccol
			s=idw.getitemstring(row,column[icol])
			if quotestr then
				if isnull(s) then
					s='null'
				elseif s=ls_null and s<>'' then
					s='null'
				else
					s="'"+s+"'"
				end if
			else
				if isnull(s) then s=''
			end if
			
			ret+=s
			if icol<ccol then ret+=coldelim
		next
		if row<row_end then ret+=rowdelim
	next
	
end if

if isvalid(thenext) then
	ret+=rowdelim+thenext.of_tostring(header,data,coldelim,rowdelim,quotestr)
end if

return ret

end function

public function boolean of_contains (long row, readonly string col);long i
if row_start<=row and row<=row_end then
	for i=1 to upperbound(column)
		if column[i]=col then return true
	next
end if


if isvalid(thenext) then
	return thenext.of_contains(row,col)
end if

return false

end function

on n_dw_selection.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_dw_selection.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;if isvalid(thenext) then destroy thenext

end event

