HA$PBExportHeader$uo_resultset_export.sru
forward
global type uo_resultset_export from uo_resultset
end type
type dw_1 from datawindow within uo_resultset_export
end type
end forward

global type uo_resultset_export from uo_resultset
boolean ib_multi_resultsets = true
dw_1 dw_1
end type
global uo_resultset_export uo_resultset_export

type variables
string is_directory
int ii_file
string is_table
string is_values[]
Encoding ie_encoding=EncodingUTF8!
long il_group_rows=1
end variables

forward prototypes
public subroutine of_settable (readonly string as_msg)
public subroutine of_seterr (readonly string as_msg)
public subroutine of_setinfo (readonly string as_msg)
public subroutine of_setrow ()
public function string of_encode (string s)
public subroutine of_println (readonly string s)
end prototypes

public subroutine of_settable (readonly string as_msg);dw_1.InsertRow( this.il_rscount )
dw_1.ScrollToRow( this.il_rscount )
dw_1.setItem(this.il_rscount,'table',as_msg)

end subroutine

public subroutine of_seterr (readonly string as_msg);if dw_1.getItemNumber(this.il_rscount,'iserror')=0 then dw_1.setItem(this.il_rscount,'comment',as_msg)
dw_1.setItem(this.il_rscount,'iserror',1)

end subroutine

public subroutine of_setinfo (readonly string as_msg);if dw_1.getItemNumber(this.il_rscount,'iserror')=0 then dw_1.setItem(this.il_rscount,'comment',as_msg)

end subroutine

public subroutine of_setrow ();dw_1.setItem(this.il_rscount,'rows',in_rsinfo[il_rscount].il_rowcount )

end subroutine

public function string of_encode (string s);s=f_replaceall(s,"'","''")
s=f_replaceall(s,"~r","'+char(10)+'")
s=f_replaceall(s,"~n","'+char(13)+'")
s=f_replaceall(s,"~t","'+char(9)+'")
return "'"+s+"'"

end function

public subroutine of_println (readonly string s);blob b
gn_unicode.of_writestream(ii_file, ie_encoding, s)

if cfg.of_getoption(cfg.is_UnixEOL) then
	b=blob('~r',ie_encoding)
else
	b=blob('~r~n',ie_encoding)
end if
FileWrite(ii_file,b)

end subroutine

on uo_resultset_export.create
int iCurrent
call super::create
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on uo_resultset_export.destroy
call super::destroy
destroy(this.dw_1)
end on

event ue_resultset_begin;call super::ue_resultset_begin;string ls_file,ls_table

is_table='ResultSet_'+string(il_rscount,'000')
if this.in_rsinfo[il_rscount].is_name>'' then is_table=this.in_rsinfo[il_rscount].is_name
ls_file=is_directory+is_table+'.sql'

ii_file=FileOpen ( ls_file, StreamMode!, Write!, LockWrite!, Replace!, EncodingANSI! )

this.of_settable( is_table )
if ii_file=-1 then 
	of_seterr('error opening file '+ls_file)
elseif isNull(ii_file) then 
	of_seterr('directory not selected '+ls_file)
end if

of_println("if exists(select 1 from syscolumns where id=object_id('"+is_table+"') and status&128=128) execute('set identity_insert "+is_table+" on')")
of_println("go")

end event

event ue_resultset_end;call super::ue_resultset_end;of_println("if exists(select 1 from syscolumns where id=object_id('"+is_table+"') and status&128=128) execute('set identity_insert "+is_table+" off')")
of_println("go")

of_setinfo('done.')
if ii_file<>-1 then FileClose(ii_file)
ii_file=-1

end event

event constructor;call super::constructor;string s

this.iwo_result=dw_1
cfg.of_options( false, 'export.directory', is_directory)
cfg.of_options( false, 'export.group.rows', il_group_rows)
cfg.of_options( false, 'export.encoding', s)
choose case s
	case 'ANSI'
		ie_encoding=EncodingANSI!
	case 'UTF16'
		ie_encoding=EncodingUTF16LE!
	case else
		ie_encoding=EncodingUTF8!
end choose

end event

event ue_row_end;call super::ue_row_end;string s1, s2, s
long i


for i=1 to in_rsinfo[il_rscount].il_colcount
	s1+=' '+in_rsinfo[il_rscount].it_col[i].name
	if isNull(is_values[i]) then
		s2+=' null'
	else
		s=in_rsinfo[il_rscount].it_col[i].sqltype
		choose case true
			case pos(s,'char')>0 or s='text'
				s=of_encode(is_values[i])
			case pos(s,'date')>0
				s="'"+is_values[i]+"'"
			case pos(s,'time')>0
				s="'"+is_values[i]+"'"
			case pos(s,'binary')>0
				s="0x"+is_values[i]+""
			case else
				s=is_values[i]
		end choose
		s2+=s
	end if
	if i<in_rsinfo[il_rscount].il_colcount then
		s1+=','
		s2+=','
	end if
next
s='insert into '+is_table+' ('+s1+') values ('+s2+')'

of_println(s)
if mod(in_rsinfo[il_rscount].il_rowcount,il_group_rows)=0 then of_println('go')

of_setrow()

end event

event ue_newrow;call super::ue_newrow;long i
is_values[in_rsinfo[il_rscount].il_colcount]=''

for i=1 to in_rsinfo[il_rscount].il_colcount
	setNull(is_values[i])
next


end event

event ue_setfield;call super::ue_setfield;is_values[al_col]=as_value

end event

event destructor;call super::destructor;if ii_file<>-1 then FileClose(ii_file)
ii_file=-1

end event

type mle_1 from uo_resultset`mle_1 within uo_resultset_export
end type

type dw_1 from datawindow within uo_resultset_export
integer y = 332
integer width = 942
integer height = 400
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_export_info"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

