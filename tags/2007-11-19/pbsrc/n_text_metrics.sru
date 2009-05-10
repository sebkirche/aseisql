HA$PBExportHeader$n_text_metrics.sru
forward
global type n_text_metrics from nonvisualobject
end type
type t_size from structure within n_text_metrics
end type
type t_rect from structure within n_text_metrics
end type
end forward

type t_size from structure
	long		cx
	long		cy
end type

type t_rect from structure
	long		left
	long		top
	long		right
	long		bottom
end type

global type n_text_metrics from nonvisualobject
end type
global n_text_metrics n_text_metrics

type prototypes
//DC functions
private function long GetDC(long hwnd) library "user32.dll"
private function long CreateCompatibleDC(long hdc) library "gdi32.dll"
private function boolean ReleaseDC(long hwnd, long hdc)library "user32.dll"
private function boolean DeleteDC(long hdc) library "gdi32.dll"


private function boolean DeleteObject(long hObject)library "gdi32.dll"
private function long SelectObject(long hdc, long handle) library "gdi32.dll"
private function long CreateFont(int nHeight,int nWidth,int nEscapement,int nOrientation,int fnWeight,long fdwItalic,long fdwUnderline,long fdwStrikeOut,long fdwCharSet,long fdwOutputPrecision,long fdwClipPrecision,long fdwQuality,long fdwPitchAndFamily,string lpszFace) library "gdi32.dll" alias for "CreateFontW"


private function boolean GetTextExtentPoint(long hdc,string lpString,long StrLen,ref t_size lpSize) library "gdi32.dll" alias for "GetTextExtentPointW"

private function long DrawText(long hDC,string lpString,long strlen,ref t_rect lpRect,long uFormat) library "User32.dll" alias for "DrawTextW"

private function long GetDeviceCaps(long hdc,long nIndex) library "gdi32.dll"

end prototypes

type variables
private long						loc_dc //local dc
private long						hfont
private long						old_hfont

end variables

forward prototypes
public function long of_gettextw (readonly string as_text)
private function boolean of_destroy ()
public function long of_gettexth (readonly string as_text)
public function boolean of_gettextsize (readonly string as_text, ref long ai_w, ref long ai_h)
public function boolean of_drawtext (readonly dragobject obj, string text)
public subroutine of_setfont (string as_face, long al_size, boolean ab_bold, boolean ab_italic)
end prototypes

public function long of_gettextw (readonly string as_text);long w,h

of_gettextsize(as_text,w,h)
return w

end function

private function boolean of_destroy ();
if old_hfont<>0 then SelectObject(loc_dc,old_hfont)
if hfont<>0 then DeleteObject(hfont)
if loc_dc<>0 then DeleteDC(loc_dc)

return false

end function

public function long of_gettexth (readonly string as_text);long w,h

of_gettextsize(as_text,w,h)
return h

end function

public function boolean of_gettextsize (readonly string as_text, ref long ai_w, ref long ai_h);t_size s
boolean b
if isNull(as_text) then 
	b=true
else
	b=GetTextExtentPoint(loc_dc,as_text,len(as_text),s)
	ai_w=s.cx
	ai_h=s.cy
end if

return b

end function

public function boolean of_drawtext (readonly dragobject obj, string text);long hdc
t_rect r
long ll_oldfnt

hdc=GetDC(handle(obj))

r.right=UnitsToPixels(obj.width,XUnitsToPixels!)
r.bottom=UnitsToPixels(obj.height,YUnitsToPixels!)

ll_oldfnt=SelectObject(hdc,hfont)


DrawText(hDC,text,-1,r,16)


SelectObject(hdc,ll_oldfnt)

ReleaseDC(handle(obj),hdc)

return true

end function

public subroutine of_setfont (string as_face, long al_size, boolean ab_bold, boolean ab_italic);//long ll_dc
long ll_weight=400
long ll_italic=0
double i
of_destroy()

//ll_dc=GetDC(handle(ao_obj))
loc_dc=CreateCompatibleDC(0)//ll_dc)
//if wnd_dc<>0 then ReleaseDC(handle(ao_obj),ll_dc)
if ab_bold then ll_weight=700
if ab_italic then ll_italic=1

i=GetDeviceCaps(loc_dc,90 /*LOGPIXELSY*/)
i=i*al_size
i=i/72
al_size=- i


hfont=CreateFont(al_size,0,0,0,ll_weight,ll_italic,0,0,1,0,0,0,0,as_face)
old_hfont=SelectObject(loc_dc,hfont)


return

end subroutine

on n_text_metrics.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_text_metrics.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;of_destroy()

end event

