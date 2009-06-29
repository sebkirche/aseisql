HA$PBExportHeader$n_config.sru
forward
global type n_config from nonvisualobject
end type
type t_windowplacement from structure within n_config
end type
end forward

type t_WINDOWPLACEMENT from structure
	long		length
	long		flags
	long		showCmd
	long		minpos_x
	long		minpos_y
	long		maxpos_x
	long		maxpos_y
	long		normpos_left
	long		normpos_top
	long		normpos_right
	long		normpos_bottom
end type

global type n_config from nonvisualobject
end type
global n_config n_config

type prototypes
private function boolean GetWindowPlacement(long hWnd,ref t_windowplacement lpwndpl )library "user32" alias for "GetWindowPlacement"
private function boolean SetWindowPlacement(long hWnd,ref t_windowplacement lpwndpl )library "user32" alias for "SetWindowPlacement"

end prototypes

type variables
protected:
	//string iniFileName
	string RegKey

end variables

forward prototypes
public function boolean  of_getboolean (string section, string key, boolean default)
public function long  of_getlong (string section, string key, long default)
public function long  of_getlong (string section, string key)
public function double of_getdouble (readonly string section, readonly string key, double default)
public function double of_getdouble (readonly string section, readonly string key)
public function integer of_setboolean (string section, string key, boolean value)
public function string of_getstring (string section, string key)
public function string of_getstring (string section, string key, string default)
public function boolean of_savepos (readonly window w)
public function boolean of_restorepos (readonly window win)
public function boolean of_getboolean (string section, string key)
public function integer of_setlong (string section, string key, long value)
public function boolean of_setdouble (readonly string section, readonly string key, readonly double value)
public function integer of_setstring (string section, string key, string value)
public function string of_gettext (readonly string section, readonly string default)
public subroutine of_settext (readonly string section, string value)
public function boolean of_getkeys (readonly string as_section, ref string as_keys[])
public function boolean of_deletekey (readonly string section, readonly string key)
public function boolean of_toolbar_save (readonly window w)
public function boolean of_toolbar_restore (readonly window w)
public function long of_gettoolbars (readonly menu m, ref integer ai_toolbars[])
public function boolean of_getsarray (string section, string key, ref string value[])
public function integer of_setsarray (string section, string key, string value[])
end prototypes

public function boolean  of_getboolean (string section, string key, boolean default);if lower( of_getstring(section,key,string(default)))=lower(string(true)) then return(true)
return(false)

end function

public function long  of_getlong (string section, string key, long default);string s
s= of_getstring(section,key,string(default))
if isnumber(s) then return long(s)
return default

end function

public function long  of_getlong (string section, string key);return( of_getlong(section,key,0))

end function

public function double of_getdouble (readonly string section, readonly string key, double default);return double(this.of_getstring(section,key,string(default)))

end function

public function double of_getdouble (readonly string section, readonly string key);return double(this.of_getstring(section,key,'0'))

end function

public function integer of_setboolean (string section, string key, boolean value);return( of_setstring(section,key,string(value)))

end function

public function string of_getstring (string section, string key);return( of_getstring(section,key,''))

end function

public function string of_getstring (string section, string key, string default);//return(profilestring(inifilename,section,key,default))

string s
if RegistryGet ( RegKey+section, key, RegString!, s )=1 then return s
return default


end function

public function boolean of_savepos (readonly window w);string section
t_windowplacement wp

if isNull(w) then return false
if not isValid(w) then return false


wp.length=11*4	//11 long values
if GetWindowPlacement(handle(w),wp) then
	section=w.classname()
	of_setlong(section,"x", PixelsToUnits(wp.normpos_left,XPixelsToUnits!) )
	of_setlong(section,"y", PixelsToUnits(wp.normpos_top,YPixelsToUnits!) )
	of_setlong(section,"w", PixelsToUnits(wp.normpos_right - wp.normpos_left,XPixelsToUnits!) )
	of_setlong(section,"h", PixelsToUnits(wp.normpos_bottom - wp.normpos_top,YPixelsToUnits!) )
	if w.windowstate=Maximized! then
		of_setstring(section,"state","maximized")
	else
		of_setstring(section,"state","normal")
	end if
	return true
end if

return false

end function

public function boolean of_restorepos (readonly window win);string section
long x,y,w,h,ww,hh
environment env

if isNull(w) then return false

section=win.classname()

x=of_getlong(section,"x",win.x)
y=of_getlong(section,"y",win.y)
w=of_getlong(section,"w",win.width)
h=of_getlong(section,"h",win.height)

//resize into screen
x=max(0,x)
y=max(0,y)
if GetEnvironment(env)=1 then
	ww=PixelsToUnits(env.ScreenWidth,XPixelsToUnits!)
	hh=PixelsToUnits(env.ScreenHeight,YPixelsToUnits!)
	if x+w>ww then
		if x>0 then
			x=max( 0, ww - w )
			w=ww - x
		else
			w=ww
		end if
	end if
	if y+h>hh then
		if y>0 then
			y=max( 0, hh - h )
			h=hh - y
		else
			h=hh
		end if
	end if
end if

win.move(x,y)
win.resize(w,h)

if of_getstring(section,"state")="maximized" then win.windowstate=Maximized!

return true

end function

public function boolean of_getboolean (string section, string key);return( of_getboolean(section,key,false))

end function

public function integer of_setlong (string section, string key, long value);return( of_setstring(section,key,string(value)))

end function

public function boolean of_setdouble (readonly string section, readonly string key, readonly double value);return this.of_setstring(section,key,string(value))=1

end function

public function integer of_setstring (string section, string key, string value);//return(setprofilestring(iniFileName,section,key,value))

return RegistrySet ( RegKey+section, key, RegString!, value )

end function

public function string of_gettext (readonly string section, readonly string default);long i=1
string ret=''
string value

if isNull(value) then value=''
do while RegistryGet ( RegKey+section, string(i) , RegString!, value )=1
	ret+=value
	i++
loop

if i>1 then return ret
return default


end function

public subroutine of_settext (readonly string section, string value);long i=1
RegistryDelete ( RegKey+section, '' )

if isNull(value) then value=''
do while len(value)>0
	RegistrySet ( RegKey+section, string(i) , RegString!, left(value,1000) )
	value=mid(value,1001)
	i++
loop

end subroutine

public function boolean of_getkeys (readonly string as_section, ref string as_keys[]);//
if RegistryValues ( RegKey+as_section, as_keys )=1 then return true
return false

end function

public function boolean of_deletekey (readonly string section, readonly string key);return RegistryDelete ( RegKey+section, key )=1

end function

public function boolean of_toolbar_save (readonly window w);string tb_class,tb_name,tb_align,s
boolean isvisible
ToolBarAlignment align
long i
int dockrow,offset
int tbx,tby,tbw,tbh
int ai_toolbars[]

of_gettoolbars(w.menuid,ai_toolbars)

if w.WindowType=MDI! or w.WindowType=MDIHelp! then
	s="FrameBar"
else
	s="SheetBar"
end if


for i=1 to UpperBound(ai_toolbars)
	tb_class=s+string(ai_toolbars[i])
	w.GetToolBar(ai_toolbars[i],isvisible,align,tb_name)
	CHOOSE CASE align
		CASE alignatbottom!
			tb_align="bottom"
		CASE alignattop!
			tb_align="top"
		CASE alignatleft!
			tb_align="left"
		CASE alignatright!
			tb_align="right"
		CASE floating!
			tb_align="floating"
	END CHOOSE
	this.of_setString(tb_class,"align",tb_align)
	this.of_setBoolean(tb_class,"isvisible",isvisible)
	this.of_setString(tb_class,"name",tb_name)
	if align=floating! then
		w.GetToolbarPos(ai_toolbars[i],tbx,tby,tbw,tbh)
		this.of_setLong(tb_class,"x",tbx)
		this.of_setLong(tb_class,"y",tby)
		this.of_setLong(tb_class,"w",tbw)
		this.of_setLong(tb_class,"h",tbh)
	else
		w.GetToolbarPos (ai_toolbars[i],dockrow,offset)
		this.of_setLong(tb_class,"dockrow",dockrow)
		this.of_setLong(tb_class,"offset",offset)
	end if
next
return true


end function

public function boolean of_toolbar_restore (readonly window w);string s,tb_class,tb_name,tb_align
boolean isvisible
ToolBarAlignment align
long i
int ai_toolbars[]
int dockrow,offset,tbx,tby,tbw,tbh

if w.WindowType=MDI! or w.WindowType=MDIHelp! then
	s="FrameBar"
else
	s="SheetBar"
end if

of_gettoolbars(w.menuid,ai_toolbars)

for i=1 to UpperBound(ai_toolbars)
	tb_class=s+string(ai_toolbars[i])
	tb_align=of_getString (tb_class,"align",  "")
	isvisible= of_getBoolean(tb_class,"isvisible",true)
	tb_name= of_getString (tb_class,"name",   tb_class)
	CHOOSE CASE tb_align
		CASE "bottom"
			align=alignatbottom!
		CASE "top"
			align=alignattop!
		CASE "left"
			align=alignatleft!
		CASE "right"
			align=alignatright!
		CASE "floating"
			align=floating!
		CASE ELSE
			return false
	END CHOOSE
	w.SetToolBar(ai_toolbars[i],isvisible,align,tb_name)
	if align=floating! then
		w.GetToolbarPos(ai_toolbars[i],tbx,tby,tbw,tbh)
		tbx=of_getLong(tb_class,"x",tbx)
		tby=of_getLong(tb_class,"y",tby)
		tbw=of_getLong(tb_class,"w",tbw)
		tbh=of_getLong(tb_class,"h",tbh)
		w.SetToolbarPos(ai_toolbars[i],tbx,tby,tbw,tbh)
	else
		w.GetToolbarPos(ai_toolbars[i],dockrow,offset)
		dockrow=of_getLong(tb_class,"dockrow",dockrow)
		offset=of_getLong(tb_class,"offset",offset)
		w.SetToolbarPos(ai_toolbars[i],dockrow,offset,false)
	end if
next
return true

end function

public function long of_gettoolbars (readonly menu m, ref integer ai_toolbars[]);//returns toolbars indexes into ai_toolbars for specified window
long			mi,	ml
long			i,		l
boolean new

if isValid(m) then
	ml=UpperBound(m.item)
	for mi=1 to ml
		if len(m.item[mi].ToolbarItemName)>0 then
			l=UpperBound(ai_toolbars)
			new=true
			for i=1 to l
				if ai_toolbars[i] = m.item[mi].ToolbarItemBarIndex then
					new=false
					exit
				end if
			next
			if new then ai_toolbars[l+1]=m.item[mi].ToolbarItemBarIndex
		end if
		if UpperBound(m.Item[mi].Item)>0 then  of_gettoolbars(m.Item[mi],ai_toolbars)
	next
end if
return upperbound(ai_toolbars)

end function

public function boolean of_getsarray (string section, string key, ref string value[]);//return(profilestring(inifilename,section,key,default))

if RegistryGet ( RegKey+section, key, RegMultiString!, value )=1 then return true
return false


end function

public function integer of_setsarray (string section, string key, string value[]);return RegistrySet ( RegKey+section, key, RegMultiString!, value )

end function

on n_config.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_config.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;regkey='HKEY_CURRENT_USER\Software\FM2i\'+GetApplication().classname()+'\'

end event

