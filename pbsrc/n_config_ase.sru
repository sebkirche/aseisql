HA$PBExportHeader$n_config_ase.sru
forward
global type n_config_ase from n_config
end type
end forward

global type n_config_ase from n_config
end type
global n_config_ase n_config_ase

type prototypes
function boolean sql_property_set(long prop,long value) LIBRARY "syb_exec.dll"

end prototypes

type variables
public privatewrite string is_Options="options"
public privatewrite string is_ShowRsSql='resultset.sql.visible'
public privatewrite string is_ShowIndent='indent.visible'
public privatewrite string is_ShowLineNum='line.num.visible'
public privatewrite string is_ShowFoldMargin='fold.margin.visible'
public privatewrite string is_WrapPages='wrap.pages'
public privatewrite string is_UnixEOL='eol.mode.unix'

public privatewrite string is_FontFace='font.face'
public privatewrite string is_FontSize='font.size'

//public privatewrite string is_BGColor='color.back'
//public privatewrite string is_SelectBG='color.select.back'
//public privatewrite string is_SelectFG='color.select.fore'
public privatewrite string is_style  ='style.'
public privatewrite string is_nullstr='NULL'

//configs must be here?
//loaded during initialisation
public boolean ib_debug_log
public boolean ib_debug_correctrow
public boolean ib_debug_expert

public long il_sql_cancel_code=6000 //CS_CANCEL_CURRENT=6000 CS_CANCEL_ALL=6001 CS_CANCEL_ATTN=6002

public string is_resultset_mode='grid'
private string is_resultset_mode_push=''
public long il_resultset_text_maxchar=80


public boolean ib_encoding_default_uft8

public string is_resultset_font_name='Microsoft Sans Serif'
public long il_resultset_font_size=8

public long il_format_datetime=1

public boolean ib_confirm_disconnect=true
public boolean ib_history_log=false
public string is_history_log_file=''

end variables
forward prototypes
public subroutine of_setoption (readonly string name, boolean b)
public function boolean of_getoption (readonly string name)
public subroutine of_invertoption (readonly string name)
public function long of_getstyle (integer i, long def)
public subroutine of_setstyle (integer i, long val)
public function boolean of_getoption (readonly string name, boolean b)
public subroutine of_options (boolean ab_store)
public subroutine of_options (boolean ab_store, readonly string as_key, ref boolean ab_value)
public subroutine of_options (boolean ab_store, readonly string as_key, ref long al_value)
public function integer of_sethostname (string as_value)
public function string of_gethostname ()
public function string of_getdefaulthostname ()
public subroutine of_options (boolean ab_store, readonly string as_key, ref string as_value)
public function boolean of_pushmode (string s)
public function boolean of_popmode ()
end prototypes

public subroutine of_setoption (readonly string name, boolean b);of_setboolean(is_Options,name,b)

end subroutine

public function boolean of_getoption (readonly string name);return of_getboolean(is_options,name)

end function

public subroutine of_invertoption (readonly string name);of_setoption(name,not of_getoption(name))

end subroutine

public function long of_getstyle (integer i, long def);return of_getlong(is_options,is_style+string(i,'00'),def)

end function

public subroutine of_setstyle (integer i, long val);of_setlong(is_options,is_style+string(i,'00'),val)

end subroutine

public function boolean of_getoption (readonly string name, boolean b);return of_getboolean(is_options,name,b)

end function

public subroutine of_options (boolean ab_store);//loads or stores options
//public boolean ib_debug_log
//public boolean ib_debug_correctrow

of_options(ab_store,'history.log',ib_history_log)
of_options(ab_store,'history.log.file',is_history_log_file)

if not ab_store and is_history_log_file='' then
	RegistryGet('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders','Personal',is_history_log_file)
	is_history_log_file+='\aseisql-history.sql'
end if

of_options(ab_store,'confirm.disconnect',ib_confirm_disconnect)

of_options(ab_store,'debug.log',ib_debug_log)
of_options(ab_store,'debug.correct.row',ib_debug_correctrow)
of_options(ab_store,'ct_cancel.type',il_sql_cancel_code)
of_options(ab_store,'resultset.text',is_resultset_mode)//don't load until fixed
//fix old problem in saved registry data:
if isValid(FindClassDefinition('uo_resultset_'+is_resultset_mode)) then
else
	is_resultset_mode='grid'
end if

of_options(ab_store,'encoding.default.utf8',ib_encoding_default_uft8)
of_options(ab_store,'resultset.font.name',is_resultset_font_name)
of_options(ab_store,'resultset.font.size',il_resultset_font_size)

of_options(ab_store,'format.datetime',il_format_datetime)
sql_property_set(0 /*PROP_DATETIME_FORMAT*/, il_format_datetime)

end subroutine

public subroutine of_options (boolean ab_store, readonly string as_key, ref boolean ab_value);if ab_store then
	of_setboolean( 'options', as_key, ab_value)
else
	ab_value=of_getboolean( 'options', as_key, ab_value)
end if

end subroutine

public subroutine of_options (boolean ab_store, readonly string as_key, ref long al_value);if ab_store then
	of_setlong( 'options', as_key, al_value)
else
	al_value=of_getlong( 'options', as_key, al_value)
end if

end subroutine

public function integer of_sethostname (string as_value);if trim(as_value)='' then 
	this.of_setstring('connect','hostname','')
	as_value=of_gethostname()
end if

return this.of_setstring('connect','hostname',as_value)

end function

public function string of_gethostname ();string s

s=this.of_getstring( 'connect', 'hostname')

if trim(s)='' then
	s=this.of_getdefaulthostname()
end if

return s

end function

public function string of_getdefaulthostname ();string s

RegistryGet ( 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName','ComputerName', RegString!, s )

return s

end function

public subroutine of_options (boolean ab_store, readonly string as_key, ref string as_value);if ab_store then
	of_setstring( 'options', as_key, as_value)
else
	as_value=of_getstring( 'options', as_key, as_value)
end if

end subroutine

public function boolean of_pushmode (string s);if is_resultset_mode_push>'' then signalerror(0,'execution mode already pushed.')
is_resultset_mode_push=is_resultset_mode
is_resultset_mode=s
return true

end function

public function boolean of_popmode ();if is_resultset_mode_push>'' then
	is_resultset_mode=is_resultset_mode_push
	is_resultset_mode_push=''
end if
return true

end function

on n_config_ase.create
call super::create
end on

on n_config_ase.destroy
call super::destroy
end on

